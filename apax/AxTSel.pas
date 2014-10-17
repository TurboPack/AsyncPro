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
{*                        AXTSEL.PAS 1.13                         *}
{******************************************************************}
{* AxTSel.PAS - Tapi selection dialog                             *}
{******************************************************************}

unit AxTSel;

interface

uses
  WinProcs,
  WinTypes,
  Messages,
  SysUtils,
  Classes,
  Controls,
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
  AwWin32, ExtCtrls;

type
  TTapiDeviceSelectionForm = class(TForm)
    Panel1: TPanel;
    cbxTapiDevices: TComboBox;
    Label1: TLabel;
    edtPhoneNumber: TEdit;
    btnCancel: TButton;
    btnOK: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FEnumerated : Boolean;
    FTapiDevice : string;
    function  GetTapiDevice : string;
    function  GetNumber : string;
    procedure SetNumber(const Value : string);
    procedure EnumTapiDevices(List : TStrings);
  public
    { Public declarations }
    FEnableVoice : Boolean;
    ShowOnlySupported : Boolean;

    constructor Create(AOwner : TComponent); override;
    property TapiDevice : string
      read GetTapiDevice write FTapiDevice;
    property Number : string
      read GetNumber write SetNumber;

  end;

var
  TapiDeviceSelectionForm: TTapiDeviceSelectionForm;

implementation

{$R *.DFM}

{ ----------------------------------------------------------------------- }
procedure TempCallback(Device, Message, Instance, Param1, Param2, Param3   : Longint); stdcall;
begin
end;
{ ----------------------------------------------------------------------- }
constructor TTapiDeviceSelectionForm.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FEnumerated      := False;
end;
{ ----------------------------------------------------------------------- }
procedure TTapiDeviceSelectionForm.EnumTapiDevices(List : TStrings);
var
  I          : Word;
  Count      : DWORD;
  LineApp    : TLineApp;
  LineExt    : TLineExtensionID;
  ApiVersion : LongInt;
  LineCaps   : PLineDevCaps;
  S          : String;
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
            {$IFDEF H+}
            Move(LineCaps^.Data[LineNameOffset], PChar(S)^, LineNameSize);
            {$ELSE}
            Move(LineCaps^.Data[LineNameOffset], S[1], LineNameSize);
            {$ENDIF}
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
            List.Add(Copy(S, 1, Length(S)-1));
        end;
      end;
    end;
  end;

  {Shutdown this line}
  tuLineShutdown(LineApp);
end;
{ ----------------------------------------------------------------------- }
procedure TTapiDeviceSelectionForm.FormShow(Sender: TObject);
begin
  if not FEnumerated then begin
    Screen.Cursor := crHourGlass;
    EnumTapiDevices(cbxTapiDevices.Items);
    Screen.Cursor := crDefault;
    cbxTapiDevices.ItemIndex := cbxTapiDevices.Items.IndexOf(FTapiDevice);
    FEnumerated := True;
    if cbxTapiDevices.ItemIndex < 0 then
      cbxTapiDevices.ItemIndex := 0;
  end;
end;
{ ----------------------------------------------------------------------- }
function  TTapiDeviceSelectionForm.GetTapiDevice : string;
begin
  Result := cbxTapiDevices.Items[cbxTapiDevices.ItemIndex];
end;
{ ----------------------------------------------------------------------- }
function  TTapiDeviceSelectionForm.GetNumber : string;
begin
  Result := edtPhoneNumber.Text;
end;
{ ----------------------------------------------------------------------- }
procedure TTapiDeviceSelectionForm.SetNumber(const Value : string);
begin
  edtPhoneNumber.Text := Value;
end;
{ ----------------------------------------------------------------------- }
procedure TTapiDeviceSelectionForm.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;
{ ----------------------------------------------------------------------- }
procedure TTapiDeviceSelectionForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

