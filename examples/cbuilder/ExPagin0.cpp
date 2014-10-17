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
#include <vcl\vcl.h>
#include <Filectrl.hpp>

#pragma hdrstop

#include "ExPagin0.h"
#include "ExPagin1.h"
#include "ExPagin2.h"
//---------------------------------------------------------------------------
#pragma link "AdPort"
#pragma link "OoMisc"
#pragma link "AdPager"
#pragma link "AdWnPort"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::mmoMsgChange(TObject *Sender)
{
  UpdateMessage();
}
//---------------------------------------------------------------------------


void __fastcall TForm1::UpdateMessage()
{
  TAPPager->Message->Assign(mmoMsg->Lines);
  SNPPPager->Message->Assign(mmoMsg->Lines);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::lbUsersClick(TObject *Sender)
{
  GetUserInfo(GetCurUser());
  edPagerID->Text = CurPagerID;
  edPagerAddr->Text = CurPagerAddress;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::GetUserInfo(String User)
{
  String UserDat = GetEntry(User);

  int PBar   = UserDat.Pos("|");
  int PComma = UserDat.Pos(",");
  int PColon = UserDat.Pos(":");

  PageType   = UserDat.SubString(1, PBar - 1);

  if ((PageType == "TAP")) {
    CurPagerAddress = UserDat.SubString(PBar + 1, (PComma - 1) - PBar);
    CurWSPort       = "";
    CurPagerID      = UserDat.SubString(PComma + 1, UserDat.Length() - PComma);
  }
  else if ((PageType == "SNPP")) {
    CurPagerAddress = UserDat.SubString(PBar + 1, (PColon - 1) - PBar);
    CurWSPort       = UserDat.SubString(PColon + 1, (PComma - 1) - PColon);
    CurPagerID      = UserDat.SubString(PComma + 1, UserDat.Length() - PComma);
  }
  else /* bad entry */ {
    CurPagerAddress = "";
    CurWSPort       = "";
    CurPagerID      = "";
  };
}
//---------------------------------------------------------------------------
String __fastcall TForm1::GetCurUser()
{
  return lbUsers->Items->Strings[lbUsers->ItemIndex];
}
//---------------------------------------------------------------------------

String  __fastcall TForm1::GetEntry(String User)
{
  return  PagerList->ReadString("PAGERS", User, "");
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ClearCurVars()
{
  CurUser         = "";
  CurPagerID      = "";
  CurPagerAddress = "";
  CurWSPort       = "";
}
//---------------------------------------------------------------------------

void __fastcall TForm1::GetUsers()
{
  lbUsers->Items->Clear();
  PagerList->ReadSection("PAGERS", lbUsers->Items);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ClearEds()
{
  edPagerAddr->Text = "";
  edPagerID->Text = "";
}
//---------------------------------------------------------------------------


void __fastcall TForm1::btnSendClick(TObject *Sender)
{
  int i;
  btnSend->Caption = "Please Wait";
  btnSend->Enabled = FALSE;

  PacketCt = 0;
  AckCt = 0;

  i = 0;
  Cancelled = FALSE;
  while ((!Cancelled) && (i <= (lbUsers->Items->Count) - 1)) {
    if (lbUsers->Selected[i]) {
      CurUser = lbUsers->Items->Strings[i];
      GetUserInfo(CurUser);

      if (PageType == "TAP") {
        SendByTAP();
      }
      else if (PageType == "SNPP") {
        SendBySNPP();
      }
      else {
        Application->MessageBox("Unknown transmission type requested", "Error", MB_OK || MB_ICONEXCLAMATION);
      }
    }

    i++;
  }

  btnSend->Caption = "Send";
  btnSend->Enabled = TRUE;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::SendByTAP()
{
  TAPPager->PhoneNumber = CurPagerAddress;
  TAPPager->PagerID     = CurPagerID;
  TAPPager->Message     = mmoMsg->Lines;
  TAPPager->Send();
}
//---------------------------------------------------------------------------


void __fastcall TForm1::SendBySNPP()
{
  WinsockPort->WsAddress = CurPagerAddress;
  WinsockPort->WsPort = CurWSPort;
  SNPPPager->PagerID = CurPagerID;
  SNPPPager->Message = mmoMsg->Lines;
  SNPPPager->Send();

}
//---------------------------------------------------------------------------


void __fastcall TForm1::TAPQuit()
{
  TAPPager->CancelCall();
  TAPPager->Disconnect();
}
//---------------------------------------------------------------------------


void __fastcall TForm1::SNPPQuit()
{
  SNPPPager->Quit();
}
//---------------------------------------------------------------------------


void __fastcall TForm1::btnDisconnectClick(TObject *Sender)
{
  if (PageType == "TAP") {
    TAPQuit();
  }
  else if (PageType == "SNPP") {
    SNPPQuit();
  }
  else {
    Application->MessageBox("Unknown protocol", "Error", MB_OK || MB_ICONEXCLAMATION);
  };
  Cancelled = TRUE;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormClose(TObject *Sender, TCloseAction &Action)
{
  Cancelled = TRUE;
  TAPQuit();
  SNPPQuit();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  ClearCurVars();
  PageType        = "TAP";

  PagerList = new TIniFile(ExtractFilePath(Application->ExeName) + PAGER_FILE);
  GetUsers();
  ClearEds();

  PagerINI = new TIniFile(ExtractFilePath(Application->ExeName) + PAGER_INIT);
  Logging = PagerINI->ReadBool("INIT", "LOGGING", FALSE);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormDestroy(TObject *Sender)
{
  PagerList->Free();
  PagerINI->Free();  
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormShow(TObject *Sender)
{
  UpdateMessage();  
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ComPortTriggerAvail(TObject *CP, WORD Count)
{
  char Ch;

  for (WORD i = 1; i<= Count; i++) {
    Ch = ComPort->GetChar();

    switch (Ch) {
      case 13: {
        mmoPageStatus->Lines->Add(LineBuff);
        LineBuff = "";
        break;
      };

      case 10: {
      break; /* ignore */
      }

      default: {
        LineBuff = LineBuff + Ch;
      }
    }

  }
}
//---------------------------------------------------------------------------
void __fastcall TForm1::SetStatus(String StatusMsg)
{
  String S = "Status: " + StatusMsg;
  Label7->Caption = S;
}
//---------------------------------------------------------------------------


void __fastcall TForm1::SNPPPagerSNPPEvent(TObject *Sender, int Code,
  AnsiString Msg)
{
  mmoPageStatus->Lines->Add(Msg);  
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnEditClick(TObject *Sender)
{
  if (lbUsers->ItemIndex == -1) {
    Application->MessageBox("No user selected", "Error", MB_OK | MB_ICONINFORMATION);
    return ;
  };

  Form2->edName->Text        = GetCurUser();
  Form2->edName->ReadOnly    = TRUE;
  Form2->edPagerAddr->Text   = edPagerAddr->Text;
  Form2->edPagerID->Text     = edPagerID->Text;
  Form2->Caption             = "Update User";
  int Rslt = Form2->ShowModal();
  if (Rslt == mrOk) {
    AddEntry(Form2->edName->Text, EntryType[Form2->RadioGroup1->ItemIndex], Form2->edPagerAddr->Text, Form2->edPagerID->Text);
    GetUsers();
  };
  Form2->ClearEds();
}
//---------------------------------------------------------------------------

void __fastcall TForm1::AddEntry(String Name, String Protocol, String Addr, String PagerID)
{
  PagerList->WriteString("PAGERS", Name, Protocol + "|" + Addr + "," + PagerID);
  GetUsers();
}
//---------------------------------------------------------------------------


void __fastcall TForm1::btnAddClick(TObject *Sender)
{
  Form2->edName->ReadOnly = FALSE;
  Form2->Caption = "Add New User";
  int Rslt = Form2->ShowModal();
  if (Rslt == mrOk)
  {
    AddEntry(Form2->edName->Text, EntryType[Form2->RadioGroup1->ItemIndex], Form2->edPagerAddr->Text, Form2->edPagerID->Text);
    GetUsers();
  };
  Form2->ClearEds();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnRemoveClick(TObject *Sender)
{
  int Rslt = Application->MessageBox("You are about to remove the selected user from the list, proceed?", "Inquiry", MB_YESNO | MB_ICONQUESTION);
  if (Rslt == ID_YES) {
    PagerList->DeleteKey("PAGERS", GetCurUser());
    GetUsers();
  };
}
//---------------------------------------------------------------------------
void __fastcall TForm1::cbLoggingClick(TObject *Sender)
{
  Logging = cbLogging->Checked;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::btnViewLogClick(TObject *Sender)
{
  InitLogFile();
  ViewLog();
}
//---------------------------------------------------------------------------

void __fastcall TForm1::InitLogFile()
{
  String LName = PagerINI->ReadString("INIT", "LOGFILE", "");

  String LPath = ExtractFilePath(LName);
  LName = ExtractFileName(LName);

  if (!DirectoryExists(LPath)) {
    /* no such directory, use default */
    LPath = ExtractFilePath(Application->ExeName);
  };

  if ((LName == "") || (!FileExists(LPath + LName))) {
    /* create file */
    TFileStream *F = new TFileStream(LPath+LName, fmCreate);
    F->Free();

    /* store new log path */
    PagerINI->WriteString("INIT", "LOGFILE", LPath + LName);
  };

  LogName = LPath + LName;
}
//---------------------------------------------------------------------------


void __fastcall TForm1::ViewLog()
{
  Form3->Memo1->Lines->LoadFromFile(LogName);
  Form3->Edit1->Text = LogName;
  Form3->ShowModal();
  if (Form3->Changed)
  {
    LogName = Form3->Edit1->Text;
    PagerINI->WriteString("INIT", "LOGFILE", LogName);
    SetLogFiles();
    InitLogFile();
  };
}
//---------------------------------------------------------------------------


void __fastcall TForm1::btnClearLogClick(TObject *Sender)
{
  ClearLog();
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ClearLog()
{
  int Rslt = Application->MessageBox("You are about to delete the pager log, proceed?", "Inquiry", MB_YESNO | MB_ICONQUESTION);
  if (Rslt == ID_YES) {
    if (FileExists(LogName)) {
      DeleteFile(LogName.c_str());
      InitLogFile();
    }
  }
}
//---------------------------------------------------------------------------

Boolean __fastcall TForm1::GetLogging()
{
  return cbLogging->Checked;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::SetLogging(Boolean AreLogging)
{
  cbLogging->Checked = AreLogging;
  PagerINI->WriteBool("INIT", "LOGGING", AreLogging);
  SetLogFiles();
}
//---------------------------------------------------------------------------

void __fastcall TForm1::SetLogFiles()
{
  LogName = PagerINI->ReadString("INIT", "LOGFILE", "");
  InitLogFile();

  if (Logging) {
    TAPLog->HistoryName = LogName;
    SNPPLog->HistoryName = LogName;
  }
  else {
    TAPLog->HistoryName = "";
    SNPPLog->HistoryName = "";
  };
}
//---------------------------------------------------------------------------


void __fastcall TForm1::btnExitClick(TObject *Sender)
{
  Close();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::TAPPagerTAPStatus(TObject *Sender,
      TTapStatus Event)
{
  switch (Event) {
    case psLoginPrompt:  {
      SetStatus("Got Login Prompt");
      break;
    }


    case psLoggedIn: {
      SetStatus("Logged In");
      break;
    }


    case psLoginErr:  {
      SetStatus("Login Error");
      break;
    }


    case psLoginFail: {
      SetStatus("Login Failed");
      break;
    }


    case psMsgOkToSend: {
      SetStatus("Got OK to Send");
      break;
    }

    case psSendingMsg: {
      PacketCt++;
      SetStatus("Sending packet " + IntToStr(PacketCt) + "...");
      break;
    };

    case psMsgAck: {
      AckCt++;
      SetStatus("Packet " + IntToStr(AckCt) + " Acknowledged");
      break;
    }

    case psMsgCompleted:   {
      SetStatus("Message Completed");
      break;
    }

    case psMsgNak: {
      SetStatus("Message Error");
      break;
    }

    case psMsgRs:  {
      SetStatus("Message Abort");
      break;
    }

    case psDone: {
      SetStatus("Page Done");
      break;
    }

  }
}
//---------------------------------------------------------------------------
