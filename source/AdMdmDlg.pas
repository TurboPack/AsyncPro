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
{*                   ADMDMDLG.PAS 5.00                   *}
{*********************************************************}
{* Modem status dialog for TAdModemStatus component      *}
{*********************************************************}  

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdMdmDlg;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Forms,
  Controls,
  OOMisc,
  AdMdm,
  StdCtrls,
  Buttons,
  ExtCtrls,
  ImgList,
  ImageList;

type
  TApdModemStatusDialog = class(TForm)
    gbxStatus: TGroupBox;
    btnCancel: TButton;
    btnDetail: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    lblStatus: TLabel;
    lblUsingDevice: TLabel;
    lblUsingPort: TLabel;
    lblElapsedTime: TLabel;
    gbxDetail: TGroupBox;
    memDetail: TMemo;
    ImageList1: TImageList;
    procedure btnDetailClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FModem: TAdCustomModem;
    procedure SetModem(const NewModem : TAdCustomModem);
  public
    { Public declarations }
    property Modem : TAdCustomModem
      read FModem write SetModem;
    procedure UpdateDisplay(
      const StatusStr, TimeStr, DetailStr : string;
      Action : TApdModemStatusAction);

  end;

var
  ApxModemStatusDialog: TApdModemStatusDialog;

implementation

{$R *.dfm}

procedure TApdModemStatusDialog.btnDetailClick(Sender: TObject);
begin
  if btnDetail.Tag = 0 then begin
    { show the whole dialog (include detail) }
    btnDetail.Tag := 1;
    gbxDetail.Visible := True;
    ClientHeight := gbxDetail.Top + gbxDetail.Height + 8 + btnCancel.Height;
  end else begin
    { show the small dialog (no detail) }
    btnDetail.Tag := 0;
    gbxDetail.Visible := False;
    ClientHeight := gbxStatus.Top + gbxStatus.Height + 8 + btnCancel.Height;
  end;
  btnDetail.Glyph := nil;
  ImageList1.GetBitmap(btnDetail.Tag, btnDetail.Glyph);
end;

procedure TApdModemStatusDialog.UpdateDisplay(
  const StatusStr, TimeStr, DetailStr : string;
  Action : TApdModemStatusAction);
  { this method is called periodically by the TApdModem component }
  { when the OnModemStatus, OnModemLog and a few other events are }
  { generated, or at other various places. }
begin
  case Action of
    msaStart : begin         { first time status display (clears everything) }
                 memDetail.Lines.Clear;
                 Show;
               end;
    msaClose : begin         { last time, cleans up }
                 Close;
               end;
    msaUpdate : begin        { normal updating }
                  lblStatus.Caption := StatusStr;
                  lblElapsedTime.Caption := 'Elapsed time: ' + TimeStr;
                  if DetailStr <> '' then
                    memDetail.Lines.Add(DetailStr);
                end;
    msaDetailReplace : begin { replaces last line of details }
                         lblStatus.Caption := StatusStr;
                         lblElapsedTime.Caption := 'Elapsed time: ' + TimeStr;
                         if DetailStr <> '' then
                           if memDetail.Lines.Count = 0 then
                             memDetail.Lines.Add(DetailStr)
                           else
                             memDetail.Lines[pred(memDetail.Lines.Count)] := DetailStr;
                      end;
    msaClear : begin         { clears all details and adds DetailStr }
                 memDetail.Lines.Clear;
                 if DetailStr <> '' then
                   memDetail.Lines.Add(DetailStr);
               end;
  end;
end;

procedure TApdModemStatusDialog.FormCreate(Sender: TObject);
var
  BMP : TBitmap;
begin
  { initialize the captions }
  btnDetail.Tag := 1;
  btnDetail.Click;
  BMP := nil;
  try
    BMP := TBitmap.Create;
    BMP.Width := btnDetail.Glyph.Width div 2;
    BMP.Height := btnDetail.Glyph.Height;
{    ImageList1.Width := btnDetail.Glyph.Width div 2;
    with btnDetail.Glyph do
      R := Rect(0, 0, Width div 2, Height);
    BMP.Canvas.CopyRect(R, btnDetail.Glyph.Canvas, R);
    ImageList1.Add(BMP, nil);
    with btnDetail.Glyph do
      R := Rect(Width div 2, 0, Width, Height);
    BMP.Canvas.CopyRect(R, btnDetail.Glyph.Canvas, R);
    ImageList1.Add(BMP, nil);}
  finally
    BMP.Free;
  end;

end;

procedure TApdModemStatusDialog.btnCancelClick(Sender: TObject);
begin
  if Assigned(FModem) then
    Postmessage(FModem.Handle, apw_CancelCall, 0, 0);                    {!!.06}
end;

procedure TApdModemStatusDialog.SetModem(const NewModem : TAdCustomModem);
begin
  FModem := NewModem;
  if Assigned(FModem) then begin                                         {!!.06}
    lblUsingDevice.Caption := FModem.SelectedDevice.Name;
    if Assigned(FModem.ComPort) then                                     {!!.06}
      lblUsingPort.Caption := Format('COM%d', [FModem.ComPort.ComNumber]){!!.06}
    else                                                                 {!!.06}
      lblUsingPort.Caption := 'No com port component assigned';          {!!.06}
  end;                                                                   {!!.06}
end;


end.
