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

{******************************************************************}
{*                       AXPROTPG.PAS 1.13                        *}
{******************************************************************}
{* AxProtPg.PAS - Protocols property page editor                  *}
{******************************************************************}

{$I AXDEFINE.INC}

unit AxProtPg;

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, StdCtrls,
  ExtCtrls, Forms, ComServ, ComObj, StdVcl, AxCtrls, Dialogs, AdProtCl,
  ComCtrls;

type
  TApxProtocolPage = class(TPropertyPage)
    Label3: TLabel;
    cbxWriteFailAction: TComboBox;
    chkIncludeDirectory: TCheckBox;
    btnReceiveDirectory: TButton;
    edtReceiveDirectory: TEdit;
    Label2: TLabel;
    chkUpCaseFileNames: TCheckBox;
    chkHonorDirectory: TCheckBox;
    chkAbortNoCarrier: TCheckBox;
    chkRTSLowForWrite: TCheckBox;
    chkProtocolStatusDisplay: TCheckBox;
    Label8: TLabel;
    edtStatusInterval: TEdit;
    UpDown3: TUpDown;
    Label5: TLabel;
    edtFinishWait: TEdit;
    UpDown2: TUpDown;
    Label1: TLabel;
    edtHandshakeRetry: TEdit;
    UpDown1: TUpDown;
    btnConfigure: TButton;
    Label6: TLabel;
    cbxProtocol: TComboBox;
    Bevel2: TBevel;
    Label4: TLabel;
    Label7: TLabel;
    Bevel3: TBevel;
    procedure btnConfigureClick(Sender: TObject);
    procedure btnReceiveDirectoryClick(Sender: TObject);
  private
    procedure ConfigureXYmodem;
    procedure ConfigureZmodem;
    procedure ConfigureKermit;
    procedure ConfigureAscii;
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure UpdatePropertyPage; override;
    procedure UpdateObject; override;
  end;

const
  Class_ApxProtocolPage: TGUID = '{B9918A04-5564-4C09-AB98-5AE78A7AB6C4}';

implementation

{$R *.DFM}

uses
  AxAsciDg, AxKermDg, AxXYmdDg, AxZmdmDg, AxDirDg;

var
  { ascii }
  AsciiCharDelay     : Integer;
  AsciiLineDelay     : Integer;
  AsciiSuppressCtrlZ : WordBool;
  AsciiEOFTimeout    : Integer;
  AsciiEOLChar       : Integer;
  AsciiCRTranslation : TAsciiEOLTranslation;
  AsciiLFTranslation : TAsciiEOLTranslation;

  { kermit }
  BlockCheckMethod    : TBlockCheckMethod;
  KermitHighbitPrefix : Integer;
  KermitRepeatPrefix  : Integer;
  KermitCtlPrefix     : Integer;
  KermitPadCount      : Integer;
  KermitPadCharacter  : Integer;
  KermitMaxLen        : Integer;
  KermitTerminator    : Integer;

  { x/y modem }
  XYModemBlockWait    : Integer;

  { z modem }
  ZModem8K             : WordBool;
  ZModemFileOptions    : TZModemFileOptions;
  ZModemFinishRetry    : Integer;
  ZModemOptionOverride : WordBool;
  ZModemRecover        : WordBool;
  ZModemSkipNoFile     : WordBool;



{== TApxProtocolPage =====================================================}
procedure TApxProtocolPage.UpdatePropertyPage;
begin
  { general }
  edtReceiveDirectory.Text         := OleObject.ReceiveDirectory;
  chkHonorDirectory.Checked        := OleObject.HonorDirectory;
  chkIncludeDirectory.Checked      := OleObject.IncludeDirectory;
  cbxWriteFailAction.ItemIndex     := Integer(OleObject.WriteFailAction);
  chkProtocolStatusDisplay.Checked := OleObject.ProtocolStatusDisplay;
  cbxProtocol.ItemIndex            := Integer(OleObject.Protocol);
  chkAbortNoCarrier.Checked        := OleObject.AbortNoCarrier;
  UpDown1.Position := OleObject.HandshakeRetry;
  {edtHandshakeRetry.Text           := IntToStr(OleObject.HandshakeRetry);}
  chkUpCaseFileNames.Checked       := OleObject.UpcaseFileNames;
  UpDown2.Position := OleObject.FinishWait;
  {edtFinishWait.Text               := IntToStr(OleObject.FinishWait);}
  UpDown3.Position := OleObject.StatusInterval;
  {edtStatusInterval.Text           := IntToStr(OleObject.StatusInterval);}
  chkRTSLowForWrite.Checked        := OleObject.RTSLowForWrite;

  { ascii }
  AsciiCharDelay                   := OleObject.AsciiCharDelay;
  AsciiLineDelay                   := OleObject.AsciiLineDelay;
  AsciiSuppressCtrlZ               := OleObject.AsciiSuppressCtrlZ;
  AsciiEOFTimeout                  := OleObject.AsciiEOFTimeout;
  AsciiEOLChar                     := OleObject.AsciiEOLChar;
  AsciiCRTranslation               := OleObject.AsciiCRTranslation;
  AsciiLFTranslation               := OleObject.AsciiLFTranslation;

  { kermit }
  BlockCheckMethod                 := OleObject.BlockCheckMethod;
  KermitHighbitPrefix              := OleObject.KermitHighbitPrefix;
  KermitRepeatPrefix               := OleObject.KermitRepeatPrefix;
  KermitCtlPrefix                  := OleObject.KermitCtlPrefix;
  KermitPadCount                   := OleObject.KermitPadCount;
  KermitPadCharacter               := OleObject.KermitPadCharacter;
  KermitMaxLen                     := OleObject.KermitMaxLen;
  KermitTerminator                 := OleObject.KermitTerminator;

  { x/y modem }
  XYModemBlockWait                 := OleObject.XYmodemBlockWait;

  { z modem }
  ZModem8K                         := OleObject.Zmodem8K;
  ZModemFileOptions                := OleObject.ZmodemFileOptions;
  ZModemFinishRetry                := OleObject.ZmodemFinishRetry;
  ZModemOptionOverride             := OleObject.ZmodemOptionOverride;
  ZModemRecover                    := OleObject.ZmodemRecover;
  ZModemSkipNoFile                 := OleObject.ZmodemSkipNoFile;

end;
{ ----------------------------------------------------------------------- }
procedure TApxProtocolPage.UpdateObject;
begin
  { general }
  OleObject.ReceiveDirectory      := edtReceiveDirectory.Text;
  OleObject.HonorDirectory        := chkHonorDirectory.Checked;
  OleObject.IncludeDirectory      := chkIncludeDirectory.Checked;
  OleObject.WriteFailAction       := cbxWriteFailAction.ItemIndex;
  OleObject.ProtocolStatusDisplay := chkProtocolStatusDisplay.checked;
  OleObject.StatusInterval        := StrToIntDef(edtStatusInterval.Text, 18);
  OleObject.Protocol              := TProtocolType(cbxProtocol.ItemIndex);
  OleObject.AbortNoCarrier        := chkAbortNoCarrier.Checked;
  OleObject.HandshakeRetry        := StrToIntDef(edtHandshakeRetry.Text, 10);
  OleObject.UpcaseFileNames       := chkUpCaseFileNames.Checked;
  OleObject.FinishWait            := StrToIntDef(edtFinishWait.Text, 364);
  OleObject.RTSLowForWrite        := chkRTSLowForWrite.Checked ;

  { ascii }
  OleObject.AsciiCharDelay        := AsciiCharDelay;
  OleObject.AsciiLineDelay        := AsciiLineDelay;
  OleObject.AsciiSuppressCtrlZ    := AsciiSuppressCtrlZ;
  OleObject.AsciiEOFTimeout       := AsciiEOFTimeout;
  OleObject.AsciiEOLChar          := AsciiEOLChar;
  OleObject.AsciiCRTranslation    := AsciiCRTranslation;
  OleObject.AsciiLFTranslation    := AsciiLFTranslation;

  { kermit }
  OleObject.BlockCheckMethod      := BlockCheckMethod;
  OleObject.KermitHighbitPrefix   := KermitHighbitPrefix;
  OleObject.KermitRepeatPrefix    := KermitRepeatPrefix;
  OleObject.KermitCtlPrefix       := KermitCtlPrefix;
  OleObject.KermitPadCount        := KermitPadCount;
  OleObject.KermitPadCharacter    := KermitPadCharacter;
  OleObject.KermitMaxLen          := KermitMaxLen;
  OleObject.KermitTerminator      := KermitTerminator;

  { x/y modem }
  OleObject.XYmodemBlockWait      := XYModemBlockWait;

  { z modem }
  OleObject.Zmodem8K              := ZModem8K;
  OleObject.ZmodemFileOptions     := ZModemFileOptions;
  OleObject.ZmodemFinishRetry     := ZModemFinishRetry;
  OleObject.ZmodemOptionOverride  := ZModemOptionOverride;
  OleObject.ZmodemRecover         := ZModemRecover;
  OleObject.ZmodemSkipNoFile      := ZModemSkipNoFile;
end;
{ ----------------------------------------------------------------------- }
procedure TApxProtocolPage.btnConfigureClick(Sender: TObject);
begin
  case TProtocolType(cbxProtocol.ItemIndex) of
    ptXmodem      : ConfigureXYmodem;
    ptXmodemCRC   : ConfigureXYmodem;
    ptXmodem1K    : ConfigureXYmodem;
    ptXmodem1KG   : ConfigureXYmodem;
    ptYmodem      : ConfigureXYmodem;
    ptYmodemG     : ConfigureXYmodem;
    ptZmodem      : ConfigureZmodem;
    ptKermit      : ConfigureKermit;
    ptAscii       : ConfigureAscii;
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxProtocolPage.ConfigureXYmodem;
var
  XYModemDlg : TApxXYModemOptions;
begin
  try
    XYModemDlg := TApxXYModemOptions.Create(Self);
    try
      XYModemDlg.XYModemBlockWait := XYModemBlockWait;
      if (XYModemDlg.ShowModal = mrOK) then
        XYModemBlockWait := XYModemDlg.XYModemBlockWait;
    finally
      XYModemDlg.Free;
    end;
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxProtocolPage.ConfigureZmodem;
var
  ZModemDlg : TApxZModemOptions;
begin
  try
    ZModemDlg := TApxZModemOptions.Create(Self);
    try
      ZModemDlg.ZModem8K              := ZModem8K;
      ZModemDlg.ZModemFileOptions     := ZModemFileOptions;
      ZModemDlg.ZModemFinishRetry     := ZModemFinishRetry;
      ZModemDlg.ZModemOptionOverride  := ZModemOptionOverride;
      ZModemDlg.ZModemRecover         := ZModemRecover;
      ZModemDlg.ZModemSkipNoFile      := ZModemSkipNoFile;
      if (ZModemDlg.ShowModal = mrOK) then begin
        ZModem8K             := ZModemDlg.ZModem8K;
        ZModemFileOptions    := ZModemDlg.ZModemFileOptions;
        ZModemFinishRetry    := ZModemDlg.ZModemFinishRetry;
        ZModemOptionOverride := ZModemDlg.ZModemOptionOverride;
        ZModemRecover        := ZModemDlg.ZModemRecover;
        ZModemSkipNoFile     := ZModemDlg.ZModemSkipNoFile;
      end;
    finally
      ZModemDlg.Free;
    end;
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxProtocolPage.ConfigureKermit;
var
  KermitDlg : TApxKermitOptions;
begin
  try
    KermitDlg := TApxKermitOptions.Create(Self);
    try
      KermitDlg.BlockCheckMethod      := BlockCheckMethod;
      KermitDlg.KermitHighbitPrefix   := KermitHighbitPrefix;
      KermitDlg.KermitRepeatPrefix    := KermitRepeatPrefix;
      KermitDlg.KermitCtlPrefix       := KermitCtlPrefix;
      KermitDlg.KermitPadCount        := KermitPadCount;
      KermitDlg.KermitPadCharacter    := KermitPadCharacter;
      KermitDlg.KermitMaxLen          := KermitMaxLen;
      KermitDlg.KermitTerminator      := KermitTerminator;
      if (KermitDlg.ShowModal = mrOK) then begin
        BlockCheckMethod     := KermitDlg.BlockCheckMethod;
        KermitHighbitPrefix  := KermitDlg.KermitHighbitPrefix;
        KermitRepeatPrefix   := KermitDlg.KermitRepeatPrefix;
        KermitCtlPrefix      := KermitDlg.KermitCtlPrefix;
        KermitPadCount       := KermitDlg.KermitPadCount;
        KermitPadCharacter   := KermitDlg.KermitPadCharacter;
        KermitMaxLen         := KermitDlg.KermitMaxLen;
        KermitTerminator     := KermitDlg.KermitTerminator;
      end;
    finally
      KermitDlg.Free;
    end;
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxProtocolPage.ConfigureAscii;
var
  AsciiDlg : TApxAsciiOptions;
begin
  try
    AsciiDlg := TApxAsciiOptions.Create(Self);
    try
      AsciiDlg.AsciiCharDelay     :=  AsciiCharDelay;
      AsciiDlg.AsciiLineDelay     :=  AsciiLineDelay;
      AsciiDlg.AsciiSuppressCtrlZ :=  AsciiSuppressCtrlZ;
      AsciiDlg.AsciiEOFTimeout    :=  AsciiEOFTimeout;
      AsciiDlg.AsciiEOLChar       :=  AsciiEOLChar;
      AsciiDlg.AsciiCRTranslation :=  AsciiCRTranslation;
      AsciiDlg.AsciiLFTranslation :=  AsciiLFTranslation;
      if (AsciiDlg.ShowModal = mrOK) then begin
        AsciiCharDelay     := AsciiDlg.AsciiCharDelay;
        AsciiLineDelay     := AsciiDlg.AsciiLineDelay;
        AsciiSuppressCtrlZ := AsciiDlg.AsciiSuppressCtrlZ;
        AsciiEOFTimeout    := AsciiDlg.AsciiEOFTimeout;
        AsciiEOLChar       := AsciiDlg.AsciiEOLChar;
        AsciiCRTranslation := AsciiDlg.AsciiCRTranslation;
        AsciiLFTranslation := AsciiDlg.AsciiLFTranslation;
      end;
    finally
      AsciiDlg.Free;
    end;
  except
  end;
end;
{ ----------------------------------------------------------------------- }
procedure TApxProtocolPage.btnReceiveDirectoryClick(Sender: TObject);
var
  DirDlg : TAxDirectoryDlg;
begin
  try
    DirDlg := TAxDirectoryDlg.Create(Self);
    try
      if DirDlg.Execute then
        edtReceiveDirectory.Text := DirDlg.SelectedFolder;
    finally
      DirDlg.Free;
    end;
  except
  end;
end;

initialization
  TActiveXPropertyPageFactory.Create(
    ComServer,
    TApxProtocolPage,
    Class_ApxProtocolPage);
end.
