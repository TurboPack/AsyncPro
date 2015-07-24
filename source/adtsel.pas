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
{*                    ADTSEL.PAS 4.06                    *}
{*********************************************************}
{* TAPI Device Selection dialog                          *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdTSel;
  {-Property editor, end-user dialog for selecting TAPI devices or ports}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons,
  AwUser,
  AdPort,
  AdExcept,
  AdTUtil,
  OOMisc,
  AdSelCom,
  LnsWin32, Controls;
type
  TDeviceSelectionForm = class(TForm)
    dsfComboBox    : TComboBox;
    dsfOkBitBtn    : TBitBtn;
    dsfCancelBitBtn: TBitBtn;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dsfOkBitBtnClick(Sender: TObject);
    procedure dsfCancelBitBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FPortItemList      : TStringList;
    FTapiMode          : TTapiMode;
    FComNumber         : Word;
    FDeviceName        : string;
    FShowTapiDevices   : Boolean;
    FShowPorts         : Boolean;                                  
    FEnumerated        : Boolean;
    FShowOnlySupported : Boolean;
    FEnableVoice       : Boolean;                                        {!!.02}
  public
    { Public declarations }
    procedure EnumComPorts;
    procedure EnumTapiPorts;
    procedure EnumAllPorts;

    constructor Create(AOwner : TComponent); override;
    property PortItemList : TStringList
      read FPortItemList write FPortItemList;
    property TapiMode : TTapiMode
      read FTapiMode write FTapiMode;
    property ComNumber : Word
      read FComNumber write FComNumber;
    property DeviceName : string
      read FDeviceName write FDeviceName;
    property EnableVoice : Boolean                                       {!!.02}
      read FEnableVoice write FEnableVoice;                              {!!.02}
    property ShowTapiDevices : Boolean
      read FShowTapiDevices write FShowTapiDevices;
    property ShowPorts : Boolean
      read FShowPorts write FShowPorts;
    property ShowOnlySupported : Boolean                               
      read FShowOnlySupported write FShowOnlySupported;
  end;

const
  DirectTo = 'Direct to COM';

var
  DeviceSelectionForm: TDeviceSelectionForm;

implementation

{$R *.DFM}

procedure TempCallback(Device   : Integer;
                       Message  : Integer;
                       Instance : Integer;
                       Param1   : Integer;
                       Param2   : Integer;
                       Param3   : Integer); stdcall;
begin
end;

constructor TDeviceSelectionForm.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FEnumerated      := False;
end;

procedure TDeviceSelectionForm.FormCreate(Sender: TObject);
begin
  FTapiMode := tmAuto;
  FPortItemList := TStringList.Create;
end;

procedure TDeviceSelectionForm.EnumComPorts;
var
  Loop      : Word;
begin
  for Loop := 1 to MaxComHandles do begin                        
    if IsPortAvailable(Loop) then
      FPortItemList.Add(DirectTo+IntToStr(Loop));
    Application.ProcessMessages;
  end;
end;

procedure TDeviceSelectionForm.EnumTapiPorts;
var
  I          : Word;
  Count      : DWORD;
  LineApp    : TLineApp;
  LineExt    : TLineExtensionID;
  ApiVersion : Integer;
  LineCaps   : PLineDevCaps;
  S          : AnsiString;
  VS         : TVarString;
begin
  {Initialize a TAPI line}
  if tuLineInitialize(LineApp,
                      hInstance,
                      TempCallback,
                      '',
                      Count) = 0 then begin

    {Enumerate all line devices, add names to the list box}
    for I := 1 to Count do begin
      {Negotiate the API version to use for this device}
      if tuLineNegotiateApiVersion(LineApp, I-1,
                                   TapiHighVer,
                                   TapiHighVer,
                                   ApiVersion,
                                   LineExt) = 0 then begin
        {Get the device capabilities}
        if tuLineGetDevCapsDyn(LineApp, I-1,
                               ApiVersion,
                               0,
                               LineCaps) = 0 then begin

          {Extract the device name}
          with LineCaps^ do begin
            SetLength(S, LineNameSize);
            Move(LineCaps^.Data[LineNameOffset], S[1], LineNameSize);
          end;

          if ShowOnlySupported then begin
            { check to see if it's capable of data }
            { if the device is not supported, then we'll set S to '' }
            if ((LineCaps^.MediaModes and LINEMEDIAMODE_DATAMODEM) = 0) then
              { it can't make a data connection }
              if ((LineCaps^.MediaModes and LINEMEDIAMODE_AUTOMATEDVOICE) = 0){!!.02}
                and FEnableVoice then                                         {!!.02}
                { it can't make an automated voice call either}
                S := ''
              else begin
                { it can make a data and Automated voice call, does it support wave? }
                { see if it supports the Wave/in and wave/out device classes }
                FillChar(VS, SizeOf(TVarString), 0);
                if (tuLineGetID(LineApp, 0, 0, LINECALLSELECT_LINE, VS, 'wave/in') <> 0) and
                   (tuLineGetID(LineApp, 0, 0, LINECALLSELECT_LINE, VS, 'wave/out') <> 0) then
                  S := '';
              end;
            if ((LineCaps^.LineFeatures and LINEFEATURE_MAKECALL) = 0) then
              { it can't make a call, so we can't use it }
              S := '';
          end;

          {Free the buffer allocated by LineGetDevCapsDyn}
          FreeMem(LineCaps, LineCaps^.TotalSize);

          {Add the name our list if it's valid}
          if S <> '' then
            FPortItemList.Add(string(Copy(S, 1, Length(S)-1)));
        end;
      end;
    end;
  end;

  {Shutdown this line}
  tuLineShutdown(LineApp);
end;

procedure TDeviceSelectionForm.EnumAllPorts;
  {-Collect the TAPI devices and comport numbers}
begin
  Screen.Cursor := crHourGlass;

  {Show TAPI devices only if requested}
  if ShowTapiDevices then
    EnumTapiPorts;

  {Show ports only if requested}
  if (ShowPorts) and not(ShowOnlySupported and EnableVoice) then         {!!.02}
    EnumComPorts;

  Screen.Cursor := crDefault;
end;

procedure TDeviceSelectionForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FPortItemList) then
    FPortItemList.Free;
end;

procedure TDeviceSelectionForm.dsfOkBitBtnClick(Sender: TObject);
begin

  DeviceName := dsfComboBox.Items[dsfComboBox.ItemIndex];
  if Pos(DirectTo, DeviceName) > 0 then begin
    TapiMode := tmOff;
    ComNumber := StrToInt(Copy(DeviceName, Length(DirectTo)+1, Length(DeviceName)));
  end else begin
    TapiMode := tmAuto;
    ComNumber := 0;
  end;

  ModalResult := mrOK;
end;

procedure TDeviceSelectionForm.dsfCancelBitBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TDeviceSelectionForm.FormShow(Sender: TObject);
begin
  if not FEnumerated then begin
    EnumAllPorts;
    dsfComboBox.Items := FPortItemList;

   { Highlite the active device in the list }
    with dsfComboBox do
      if FTapiMode = tmOff then begin
        ItemIndex := Items.IndexOf(DirectTo+IntToStr(ComNumber));
      end else begin
        ItemIndex := Items.IndexOf(FDeviceName);
      end;
    FEnumerated := True;
    if dsfComboBox.ItemIndex < 0 then dsfComboBox.ItemIndex := 0;
  end;
end;

end.

