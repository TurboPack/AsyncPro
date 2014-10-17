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
{*                       AXLINEDG.PAS 1.13                        *}
{******************************************************************}
{* AxLineDg.PAS - Serial comm port properties editor dialog       *}
{******************************************************************}

{$I AXDEFINE.INC}

unit AxLineDg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ExtCtrls, AdPort;

type
  TApxLineDlg = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    Bevel1: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    cbxBaudRate: TComboBox;
    cbxParity: TComboBox;
    cbxDataBits: TComboBox;
    cbxStopBits: TComboBox;
    Bevel2: TBevel;
    Label8: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    chkUseDTR: TCheckBox;
    chkUseRTS: TCheckBox;
    chkSWTransmit: TCheckBox;
    chkSWReceive: TCheckBox;
    chkRequireDSR: TCheckBox;
    chkRequireCTS: TCheckBox;
    edtXonChar: TEdit;
    edtXoffChar: TEdit;
    Label9: TLabel;
    Bevel3: TBevel;
    Label10: TLabel;
    Bevel4: TBevel;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cbxBaudRateChange(Sender: TObject);
  private
    { Private declarations }
  public
    Baud             : Integer;
    ComNumber        : Integer;
    DataBits         : Integer;
    DTR              : WordBool;
    HWFlowUseDTR     : WordBool;
    HWFlowUseRTS     : WordBool;
    HWFlowRequireDSR : WordBool;
    HWFlowRequireCTS : WordBool;
    Parity           : TParity;
    PromptForPort    : WordBool;
    RS485Mode        : WordBool;
    RTS              : WordBool;
    StopBits         : Integer;
    SWFlowOptions    : TSWFlowOptions;
    XOffChar         : Integer;
    XOnChar          : Integer;
  end;

var
  ApxLineDlg: TApxLineDlg;

implementation

{$R *.DFM}

const
  BaudValues : array[0..9] of Integer =
    (300, 600, 1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200);


{ ----------------------------------------------------------------------- }
procedure TApxLineDlg.FormActivate(Sender: TObject);
var
  SWOpts : TSWFlowOptions;
begin
//  chkPromptForPort.Checked := PromptForPort;
//  edtComNumber.Text := IntToStr(ComNumber);

//  rgBaud.ItemIndex := 6;
  cbxBaudRate.Text := IntToStr(Baud);
{  CheckBaud := Baud;
  for i := 0 to 9 do
    if CheckBaud = BaudValues[i] then begin
      rgBaud.ItemIndex := i;
      Break;
    end;}
//  rgDataBits.ItemIndex := 8 - Databits;
  cbxDataBits.ItemIndex := 8 - DataBits;
//  rgStopBits.ItemIndex := StopBits - 1;
  cbxStopBits.ItemIndex := StopBits - 1;
//  rgParity.ItemIndex := Integer(Parity);
  cbxParity.ItemIndex := Integer(Parity);
  chkUseDTR.Checked := HWFlowUseDTR;
  chkUseRTS.Checked := HWFlowUseRTS;
  chkRequireDSR.Checked := HWFlowRequireDSR;
  chkRequireCTS.Checked := HWFlowRequireCTS;

  { SW flow options }
  SWOpts := SWFlowOptions;
  chkSWTransmit.Checked := (SWOpts = swfBoth) or (SWOpts = swfTransmit);
  chkSWReceive.Checked  := (SWOpts = swfBoth) or (SWOpts  = swfReceive);
  edtXOnChar.Text := IntToStr(XOnChar);
  edtXOffChar.Text := IntToStr(XOffChar);
end;
{ ----------------------------------------------------------------------- }
procedure TApxLineDlg.btnOkClick(Sender: TObject);
var
  SWOpts : TSWFlowOptions;
begin
//  PromptForPort := chkPromptForPort.Checked;
//  ComNumber := StrToIntDef(edtComNumber.Text, 0);

  Baud := StrToIntDef(cbxBaudRate.Text, Baud);
  //BaudValues[rgBaud.ItemIndex];
//  Databits := 8 - rgDataBits.ItemIndex;
  DataBits := 8 - cbxParity.ItemIndex;
//  StopBits := rgStopBits.ItemIndex + 1;
  StopBits := cbxStopBits.ItemIndex + 1;
  Parity := TParity(cbxParity.ItemIndex);
  HWFlowUseDTR := chkUseDTR.Checked;
  HWFlowUseRTS := chkUseRTS.Checked;
  HWFlowRequireDSR := chkRequireDSR.Checked;
  HWFlowRequireCTS := chkRequireCTS.Checked;

  { SW flow options }
  if chkSWTransmit.Checked then
    if chkSWReceive.Checked then
      SWOpts := swfBoth
    else
      SWOpts := swfTransmit
  else if chkSWReceive.Checked then
    SWOpts := swfReceive
  else
    SWOpts := swfNone;
  SWFlowOptions := SWOpts;
  XOnChar := StrToInt(edtXOnChar.Text);
  XOffChar := StrToInt(edtXOffChar.Text);
  ModalResult := mrOk;
end;
{ ----------------------------------------------------------------------- }
procedure TApxLineDlg.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;
{ ----------------------------------------------------------------------- }
procedure TApxLineDlg.cbxBaudRateChange(Sender: TObject);
begin
  if Length(cbxBaudRate.Text) > 0 then
    if StrToIntDef(cbxBaudRate.Text, -1) = -1 then
      cbxBaudRate.Text := IntToStr(Baud);
end;

end.
