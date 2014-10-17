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
 *   Sebastian Zierer
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   ADXPROT.PAS 4.06                    *}
{*********************************************************}
{* Generic protocol options dialog                       *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdXProt;

interface

uses
  SysUtils,
  Windows,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  AdProtcl;

type
  TProtocolOptions = class(TForm)
    GeneralOptions: TGroupBox;
    gWriteFail: TComboBox;
    Label1: TLabel;
    gHonorDirectory: TCheckBox;
    gIncludeDirectory: TCheckBox;
    gRTSLowForWrite: TCheckBox;
    gAbortNoCarrier: TCheckBox;
    ZmodemOptions: TGroupBox;
    zOptionOverride: TCheckBox;
    zSkipNoFile: TCheckBox;
    zRecover: TCheckBox;
    z8K: TCheckBox;
    zFileManagment: TComboBox;
    Label2: TLabel;
    OK: TButton;
    Cancel: TButton;
    KermitOptions: TGroupBox;
    AsciiOptions: TGroupBox;
    Label3: TLabel;
    kBlockLen: TEdit;
    Label5: TLabel;
    kWindows: TEdit;
    Label6: TLabel;
    kTimeout: TEdit;
    Label7: TLabel;
    sInterCharDelay: TEdit;
    Label8: TLabel;
    sInterLineDelay: TEdit;
    sCRTrans: TComboBox;
    Label9: TLabel;
    Label10: TLabel;
    sLFTrans: TComboBox;
    Label11: TLabel;
    sEOFTimeout: TEdit;
    procedure CancelClick(Sender: TObject);
    procedure OKClick(Sender: TObject);

  private
    FProtocol : TApdProtocol;
    Executed  : Boolean;

  protected
    function GetProtocol : TApdProtocol;
    procedure SetProtocol(NewProtocol : TApdProtocol);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;

    property Protocol : TApdProtocol
      read GetProtocol write SetProtocol;
  end;

var
  ProtocolOptions: TProtocolOptions;

implementation

{$R *.DFM}

function Str2Int(const S : String) : Integer;
var
  Code : Integer;
begin
  Val(S, Result, Code);
  if Code <> 0 then
    Result := 0;
end;

constructor TProtocolOptions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FProtocol := TApdProtocol.Create(Self);
  Executed := False;
end;

destructor TProtocolOptions.Destroy;
begin
  FProtocol.Free;
  inherited Destroy;
end;

function TProtocolOptions.Execute: Boolean;
begin
  {Update dialog controls, general...}
  gHonorDirectory.Checked := FProtocol.HonorDirectory;
  gIncludeDirectory.Checked := FProtocol.IncludeDirectory;
  gRTSLowForWrite.Checked := FProtocol.RTSLowForWrite;
  gAbortNoCarrier.Checked := FProtocol.AbortNoCarrier;
  gWriteFail.ItemIndex := Ord(FProtocol.WriteFailAction);

  {Zmodem...}
  zOptionOverride.Checked := FProtocol.ZmodemOptionOverride;
  zSkipNoFile.Checked := FProtocol.ZmodemSkipNoFile;
  zRecover.Checked := FProtocol.ZmodemRecover;
  z8K.Checked := FProtocol.Zmodem8K;
  zFileManagment.ItemIndex := Ord(FProtocol.ZmodemFileOption);

  {Kermit...}
  kBlockLen.Text := IntToStr(FProtocol.KermitMaxLen);
  kWindows.Text := IntToStr(FProtocol.KermitMaxWindows);
  kTimeout.Text := IntToStr(FProtocol.KermitTimeoutSecs);

  {ASCII...}
  sInterCharDelay.Text := IntToStr(FProtocol.AsciiCharDelay);
  sInterLineDelay.Text := IntToStr(FProtocol.AsciiLineDelay);
  sCRTrans.ItemIndex := Ord(FProtocol.AsciiCRTranslation);
  sLFTrans.ItemIndex := Ord(FProtocol.AsciiLFTranslation);
  sEOFTimeout.Text := IntToStr(FProtocol.AsciiEOFTimeout);

  {Execute}
  ShowModal;
  Result := ModalResult = mrOK;
  Executed := Result;
end;

function TProtocolOptions.GetProtocol : TApdProtocol;
begin
  if Executed then begin
    {Get values from dialog controls, general...}
    FProtocol.HonorDirectory := gHonorDirectory.Checked;
    FProtocol.IncludeDirectory := gIncludeDirectory.Checked;
    FProtocol.RTSLowForWrite := gRTSLowForWrite.Checked;
    FProtocol.AbortNoCarrier := gAbortNoCarrier.Checked;
    FProtocol.WriteFailAction := TWriteFailAction(gWriteFail.ItemIndex);

    {Zmodem...}
    FProtocol.ZmodemOptionOverride := zOptionOverride.Checked;
    FProtocol.ZmodemSkipNoFile := zSkipNoFile.Checked;
    FProtocol.ZmodemRecover := zRecover.Checked;
    FProtocol.Zmodem8K := z8K.Checked;
    FProtocol.ZmodemFileOption := TZmodemFileOptions(zFileManagment.ItemIndex);

    {Kermit...}
    FProtocol.KermitMaxLen := Str2Int(kBlockLen.Text);
    FProtocol.KermitMaxWindows := Str2Int(kWindows.Text);
    FProtocol.KermitTimeoutSecs := Str2Int(kTimeout.Text);

    {ASCII...}
    FProtocol.AsciiCharDelay := Str2Int(sInterCharDelay.Text);
    FProtocol.AsciiLineDelay := Str2Int(sInterLineDelay.Text);
    FProtocol.AsciiCRTranslation := TAsciiEOLTranslation(sCRTrans.ItemIndex);
    FProtocol.AsciiLFTranslation := TAsciiEOLTranslation(sLFTrans.ItemIndex);
    FProtocol.AsciiEOFTimeout := Str2Int(sEOFTimeout.Text);
  end;
  Result := FProtocol;
end;

procedure TProtocolOptions.SetProtocol(NewProtocol : TApdProtocol);
begin
  if NewProtocol <> FProtocol then
    FProtocol.Assign(NewProtocol);
end;

procedure TProtocolOptions.CancelClick(Sender: TObject);
begin
  ModalResult := idCancel;
end;

procedure TProtocolOptions.OKClick(Sender: TObject);
begin
  ModalResult := idOK;
end;

end.
