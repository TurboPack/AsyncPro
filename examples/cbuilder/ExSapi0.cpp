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

#include "ExSapi0.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "AdSapiEn"
#pragma link "cgauges"
#pragma link "OoMisc"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}
//---------------------------------------------------------------------------

TPhraseType __fastcall TForm1::AnalyzePhrase (AnsiString Phrase)
{
  if (Phrase == "help")
    return (ptHelp);
  else if ((Phrase == "close") || (Phrase == "exit") ||
           (Phrase == "goodbye") || (Phrase == "end") ||
           (Phrase == "bye"))
    return (ptQuit);
  else if ((Phrase == "stop speaking") || (Phrase == "hush") ||
           (Phrase == "be quiet") || (Phrase ==  "quiet") ||
           (Phrase == "shut up"))
    return (ptQuiet);
  else if ((Phrase == "what time is it") || (Phrase == "time"))
    return (ptTime);
  else if ((Phrase == "what day is it") || (Phrase == "day"))
    return (ptDate);
  else
    return (ptUnknown);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::SaySomething (AnsiString Something)
{
  Memo1->Lines->Add ("--> " + Something);
  ApdSapiEngine1->Speak (Something);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button1Click(TObject *Sender)
{
  ApdSapiEngine1->WordList->Clear ();
  ApdSapiEngine1->WordList->Add ("close");
  ApdSapiEngine1->WordList->Add ("exit");
  ApdSapiEngine1->WordList->Add ("goodbye");
  ApdSapiEngine1->WordList->Add ("end");
  ApdSapiEngine1->WordList->Add ("bye");

  ApdSapiEngine1->WordList->Add ("stop speaking");
  ApdSapiEngine1->WordList->Add ("hush");
  ApdSapiEngine1->WordList->Add ("be quiet");
  ApdSapiEngine1->WordList->Add ("quiet");
  ApdSapiEngine1->WordList->Add ("shut up");

  ApdSapiEngine1->WordList->Add ("what time is it");
  ApdSapiEngine1->WordList->Add ("time");

  ApdSapiEngine1->WordList->Add ("what day is it");
  ApdSapiEngine1->WordList->Add ("day");

  ApdSapiEngine1->WordList->Add ("help");

  SaySomething ("Welcome to the speech recognition demo.");
  SaySomething ("Say 'Help' to get help");
  ApdSapiEngine1->Listen ();
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ApdSapiEngine1PhraseFinish(TObject *Sender,
      const AnsiString Phrase)
{
  Memo1->Lines->Add ("<-- " + Phrase);
  switch (AnalyzePhrase (Phrase)) {
    case ptHelp :
      SaySomething ("You can say several things to this demo.");
      SaySomething ("'Help' will give you help.");
      if (ApdSapiEngine1->Duplex == sdFull)
        SaySomething ("'Stop Speaking' will cause me to stop speaking the "
                      "current phrase.");
      SaySomething ("'What time is it?' will tell the current time.");
      SaySomething ("'What day is it?' will tell the current day.");
      SaySomething ("'Goodbye' will end this demo.");
      break;
    case ptQuit :
      SaySomething ("Goodbye");
      ApdSapiEngine1->WaitUntilDoneSpeaking ();
      Close ();
      break;
    case ptQuiet :
      ApdSapiEngine1->StopSpeaking ();
      break;
    case ptDate :
      SaySomething ("It is " + FormatDateTime ("mmmm d, yyyy", Now ()) + ".");
      break;
    case ptTime :
      SaySomething ("It is " + FormatDateTime ("h:nam/pm", Now ()) + ".");
      break;
    case ptUnknown :
      SaySomething ("I didn't understand you.");
  }
}
//---------------------------------------------------------------------------




void __fastcall TForm1::FormCreate(TObject *Sender)
{
  if (ApdSapiEngine1->IsSapi4Installed() == false)
  {
    ShowMessage ("SAPI 4 is not installed. This example will now exit.");
    Application->Terminate();
  }
}
//---------------------------------------------------------------------------

