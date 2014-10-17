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
 * The Original Code is LNS Software Systems
 *
 * The Initial Developer of the Original Code is LNS Software Systems
 *
 * Portions created by the Initial Developer are Copyright (C) 1998-2007
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)
unit XferOptFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TXferOptForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    CharDelayEdit: TEdit;
    Label2: TLabel;
    CRXlateCombo: TComboBox;
    Label3: TLabel;
    LFXlateCombo: TComboBox;
    Label4: TLabel;
    EOFTimeoutEdit: TEdit;
    Label5: TLabel;
    LineDelayEdit: TEdit;
    Label6: TLabel;
    IgnEOFBtn: TCheckBox;
    Label7: TLabel;
    EOLCharEdit: TEdit;
    GroupBox2: TGroupBox;
    Label8: TLabel;
    PktLengthEdit: TEdit;
    Label9: TLabel;
    MaxWinEdit: TEdit;
    Label10: TLabel;
    KTimeoutEdit: TEdit;
    GroupBox3: TGroupBox;
    Label11: TLabel;
    OverwriteCombo: TComboBox;
    Label12: TLabel;
    OptOverrideBtn: TCheckBox;
    Label13: TLabel;
    RecoverBtn: TCheckBox;
    Label14: TLabel;
    SkipNoFileBtn: TCheckBox;
    SaveBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    Label15: TLabel;
    DestDirEdit: TEdit;
    procedure FormShow(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  XferOptForm: TXferOptForm;

implementation

uses EmulatorFrm, AdProtcl, Registry;

{$R *.DFM}

procedure TXferOptForm.FormShow(Sender: TObject);
begin
    with EmulatorForm.XferProtocol do
    begin
        CharDelayEdit.Text := IntToStr(AsciiCharDelay);
        case AsciiCRTranslation of
          aetNone:              CRXlateCombo.ItemIndex := 0;
          aetStrip:             CRXlateCombo.ItemIndex := 1;
          aetAddLFAfter:        CRXlateCombo.ItemIndex := 2;
          else                  CRXlateCombo.ItemIndex := -1;
        end;
        case AsciiLFTranslation of
          aetNone:              LFXlateCombo.ItemIndex := 0;
          aetStrip:             LFXlateCombo.ItemIndex := 1;
          aetAddCRBEfore:       LFXlateCombo.ItemIndex := 2;
          else                  CRXlateCombo.ItemIndex := -1;
        end;
        EOFTimeoutEdit.Text := IntToStr(AsciiEOFTimeout div 18);
        LineDelayEdit.Text := IntToStr(AsciiLineDelay);
        EOLCharEdit.Text := IntToStr(Ord(AsciiEOLChar));
        IgnEOFBtn.Checked := AsciiSuppressCtrlZ;
        PktLengthEdit.Text := IntToStr(KermitMaxLen);
        MaxWinEdit.Text := IntToStr(KermitMaxWindows);
        KTimeoutEdit.Text := IntToStr(KermitTimeoutSecs);
        case ZmodemFileOption of
          zfoWriteNewerLonger:   OverwriteCombo.ItemIndex := 0;
          zfoWriteAppend:        OverwriteCombo.ItemIndex := 1;
          zfoWriteClobber:       OverwriteCombo.ItemIndex := 2;
          zfoWriteNewer:         OverwriteCombo.ItemIndex := 3;
          zfoWriteDifferent:     OverwriteCombo.ItemIndex := 4;
          zfoWriteProtect:       OverwriteCombo.ItemIndex := 5;
          else                   OverwriteCombo.ItemIndex := -1;
        end;
        OptOverrideBtn.Checked := not ZmodemOptionOverride;
        RecoverBtn.Checked := ZmodemRecover;
        SkipNoFileBtn.Checked := ZmodemSkipNoFile;
        DestDirEdit.Text := DestinationDirectory;
    end;
end;

procedure TXferOptForm.SaveBtnClick(Sender: TObject);
var
    stemp         : String;
    charDelay     : Integer;
    crXlate       : TAsciiEOLTranslation;
    lfXlate       : TAsciiEOLTranslation;
    eofTimeout    : Integer;
    lineDelay     : Integer;
    eolChar       : Char;
    pktLen        : Integer;
    maxWin        : Integer;
    ktimeout      : Integer;
    overwrite     : TZmodemFileOptions;
    reg           : TRegistry;
    bStat         : Boolean;

begin
    stemp := TrimLeft(TrimRight(CharDelayEdit.Text));
    charDelay := 0;
    if (stemp <> '') then
    begin
        try
            charDelay := StrToInt(stemp);
        except
            CharDelayEdit.SetFocus;
            raise Exception.Create('This field must be a valid integer.');
        end;
    end;
    case CRXlateCombo.ItemIndex of
      0:      crXlate := aetNone;
      1:      crXlate := aetStrip;
      2:      crXlate := aetAddLFAfter;
      else
      begin
        CRXlateCombo.SetFocus;
        raise Exception.Create('This field must have a value.');
      end;
    end;
    case LFXlateCombo.ItemIndex of
      0:      lfXlate := aetNone;
      1:      lfXlate := aetStrip;
      2:      lfXlate := aetAddCRBEfore;
      else
      begin
        LFXlateCombo.SetFocus;
        raise Exception.Create('This field must have a value.');
      end;
    end;
    stemp := TrimLeft(TrimRight(EOFTimeoutEdit.Text));
    eofTimeout := 0;
    if (stemp <> '') then
    begin
        try
            eofTimeout := StrToInt(stemp);
        except
            EOFTimeoutEdit.SetFocus;
            raise Exception.Create('This field must have a value.');
        end;
    end;
    eofTimeout := eofTimeout * 18;
    stemp := TrimLeft(TrimRight(LineDelayEdit.Text));
    lineDelay := 0;
    if (stemp <> '') then
    begin
        try
            lineDelay := StrToInt(stemp);
        except
            LineDelayEdit.SetFocus;
            raise Exception.Create('This field must be a valid integer.');
        end;
    end;
    stemp := TrimLeft(TrimRight(EOLCharEdit.Text));
    eolChar := Chr(0);
    if (stemp <> '') then
    begin
        try
            eolChar := Chr(StrToInt(stemp));
        except
            EOLCharEdit.SetFocus;
            raise Exception.Create('This field must be a valid integer.');
        end;
    end;
    if (eolChar = Chr(0)) then
    begin
        EOLCharEdit.SetFocus;
        raise Exception.Create('This field must have a value.');
    end;
    stemp := TrimLeft(TrimRight(PktLengthEdit.Text));
    pktLen := 0;
    if (stemp <> '') then
    begin
        try
            pktLen := StrToInt(stemp);
        except
            PktLengthEdit.SetFocus;
            raise Exception.Create('This field must be a valid integer.');
        end;
    end;
    if ((pktLen < 40) or (pktLen > 1024)) then
    begin
        PktLengthEdit.SetFocus;
        raise Exception.Create('This field must have a value between 40 and 1024.');
    end;
    stemp := TrimLeft(TrimRight(MaxWinEdit.Text));
    maxWin := 0;
    if (stemp <> '') then
    begin
        try
            maxWin := StrToInt(stemp);
        except
            MaxWinEdit.SetFocus;
            raise Exception.Create('This field must be a valid integer.');
        end;
    end;
    if ((maxWin < 0) or (maxWin > 27)) then
    begin
        MaxWinEdit.SetFocus;
        raise Exception.Create('This field must have a value between 0 and 27.');
    end;
    stemp := TrimLeft(TrimRight(KTimeoutEdit.Text));
    ktimeout := 0;
    if (stemp <> '') then
    begin
        try
            ktimeout := StrToInt(stemp);
        except
            KTimeoutEdit.SetFocus;
            raise Exception.Create('This field must be a valid integer.');
        end;
    end;
    if (ktimeout = 0) then
    begin
        KTimeoutEdit.SetFocus;
        raise Exception.Create('This field must have a value.');
    end;
    case OverwriteCombo.ItemIndex of
      0:       overwrite := zfoWriteNewerLonger;
      1:       overwrite := zfoWriteAppend;
      2:       overwrite := zfoWriteClobber;
      3:       overwrite := zfoWriteNewer;
      4:       overwrite := zfoWriteDifferent;
      5:       overwrite := zfoWriteProtect;
      else
      begin
        OverwriteCombo.SetFocus;
        raise Exception.Create('This field must have a value.');
      end;
    end;

    with EmulatorForm.XferProtocol do
    begin
        AsciiCharDelay := charDelay;
        AsciiCRTranslation := crXlate;
        AsciiEOFTimeout := eofTimeout;
        AsciiEOLChar := eolChar;
        AsciiLFTranslation := lfXlate;
        AsciiLineDelay := lineDelay;
        AsciiSuppressCtrlZ := IgnEOFBtn.Checked;
        KermitMaxLen := pktLen;
        KermitMaxWindows := maxWin;
        KermitTimeoutSecs := ktimeout;
        ZmodemFileOption := overwrite;
        ZmodemOptionOverride := not OptOverrideBtn.Checked;
        ZmodemRecover := RecoverBtn.Checked;
        ZmodemSkipNoFile := SkipNoFileBtn.Checked;
        DestinationDirectory := TrimLeft(TrimRight(DestDirEdit.Text));
    end;

    reg := TRegistry.Create;
    try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        bStat := reg.OpenKey(OptKey, True);
        if (bStat) then
        begin
            reg.WriteInteger('AsciiCharDelay', charDelay);
            reg.WriteInteger('AsciiCRTranslation', Integer(crXlate));
            reg.WriteInteger('AsciiEOFTimeout', eofTimeout);
            reg.WriteInteger('AsciiEOLChar', Ord(eolChar));
            reg.WriteInteger('AsciiLFTranslation', Integer(lfXlate));
            reg.WriteInteger('AsciiLineDelay', lineDelay);
            reg.WriteInteger('AsciiSuppressCtrlZ', Integer(IgnEOFBtn.Checked));
            reg.WriteInteger('KermitMaxLen', pktLen);
            reg.WriteInteger('KermitMaxWindows', maxWin);
            reg.WriteInteger('KermitTimeoutSecs', ktimeout);
            reg.WriteInteger('ZmodemFileOption', Integer(overwrite));
            reg.WriteInteger('ZmodemOptionOverride', Integer(not OptOverrideBtn.Checked));
            reg.WriteInteger('ZmodemRecover', Integer(RecoverBtn.Checked));
            reg.WriteInteger('ZmodemSkipNoFile', Integer(SkipNoFileBtn.Checked));
            reg.WriteString('DestinationDirectory', TrimLeft(TrimRight(DestDirEdit.Text)));
        end;
    finally
        reg.Free;
    end;
    ModalResult := mrOk;
end;

procedure TXferOptForm.HelpBtnClick(Sender: TObject);
begin
    Application.HelpContext(55);
end;

end.
