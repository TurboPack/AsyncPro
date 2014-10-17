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

{**********************************************************}
{*                     SENDFAX0.PAS                       *}
{**********************************************************}

{**********************Description*************************}
{*  Shows how to send multiple faxes with optional cover  *}
{*         pages.                                         *}
{**********************************************************}

unit Sendfax0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, OoMisc, AdFax, AdFStat, AdPort, ExtCtrls,
  SendFax1, AdTapi, AdExcept;

type
  PAddEntry = ^TAddEntry;
  TAddEntry = record
    FaxName     : String;
    CoverName   : String;
    PhoneNumber : String;
    NextEntry   : PAddEntry;
  end;

  TsfMain = class(TForm)
    ApdComPort1: TApdComPort;
    ApdFaxStatus1: TApdFaxStatus;
    ApdSendFax1: TApdSendFax;
    SendFax: TButton;
    sfAdd: TButton;
    sfExit: TButton;
    Panel1: TPanel;
    sfFaxClass: TRadioGroup;
    Label1: TLabel;
    sfModemInit: TEdit;
    sfModify: TButton;
    sfDelete: TButton;
    Label2: TLabel;
    sfHeader: TEdit;
    Label3: TLabel;
    sfStationID: TEdit;
    Label4: TLabel;
    sfDialPrefix: TEdit;
    Label5: TLabel;
    sfDialAttempts: TEdit;
    Label6: TLabel;
    sfRetryWait: TEdit;
    sfFaxListBox: TListBox;
    Label7: TLabel;
    ApdFaxLog1: TApdFaxLog;
    sfSelectComPort: TButton;
    ApdTapiDevice1: TApdTapiDevice;
    EnhText: TCheckBox;
    HdrFontBtn: TButton;
    CvrFontBtn: TButton;
    FontDialog1: TFontDialog;
    procedure SendFaxClick(Sender: TObject);
    procedure sfAppendAddList(FName, CName, PNumber : String);
    procedure sfGetAddListEntry(var FName, CName, PNumber : String);
    procedure sfAddPrim;
    procedure sfAddClick(Sender: TObject);
    procedure sfAddFromCmdLine;
    procedure ApdSendFax1FaxNext(CP: TObject; var ANumber, AFileName,
      ACoverName: TPassString);
    procedure ApdSendFax1FaxFinish(CP: TObject; ErrorCode: Integer);
    procedure sfExitClick(Sender: TObject);
    procedure sfModifyClick(Sender: TObject);
    procedure sfDeleteClick(Sender: TObject);
    procedure ApdSendFax1FaxLog(CP: TObject; LogCode: TFaxLogCode);
    procedure sfFaxClassClick(Sender: TObject);
    procedure sfDialAttemptsChange(Sender: TObject);
    procedure sfRetryWaitChange(Sender: TObject);
    procedure sfStationIDChange(Sender: TObject);
    procedure sfDialPrefixChange(Sender: TObject);
    procedure sfModemInitChange(Sender: TObject);
    procedure sfHeaderChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sfSelectComPortClick(Sender: TObject);
    procedure ApdTapiDevice1TapiPortOpen(Sender: TObject);
    procedure ApdTapiDevice1TapiPortClose(Sender: TObject);
    procedure HdrFontBtnClick(Sender: TObject);
    procedure CvrFontBtnClick(Sender: TObject);
  private
    { Private declarations }
    FaxList     : TStringList;
    FaxIndex    : Word;
    InProgress  : Boolean;

    AddsInProgress    : Boolean;
    AddsPending       : Word;
    AddList           : PAddEntry;
    ProcessedCmdLine  : Boolean;

  public
    { Public declarations }
    constructor Create(AComponent : TComponent); override;
    destructor Destroy; override;
    procedure sfAddFromPrinterDriver(var Message: TMessage);
      message APW_PRINTDRIVERJOBCREATED;
  end;

var
  sfMain: TsfMain;

implementation

{$R *.DFM}

function LimitS(const S : String; Len : Word) : String;
  {-Truncate S at Len}
begin
  if Length(S) > Len then
    Result := Copy(S, 1, Len) + '...'
  else
    Result := S;
end;

constructor TsfMain.Create(AComponent : TComponent);
  {-Create the form}
begin
  inherited Create(AComponent);
  FaxList     := TStringList.Create;
  InProgress  := False;
  AddList     := nil;
  AddsPending := 0;
  AddsInProgress := False;
  ProcessedCmdLine := False;
end;

destructor TsfMain.Destroy;
begin
  FaxList.Free;
  inherited Destroy;
end;

procedure TsfMain.FormShow(Sender: TObject);
  {-Handle any command line arguments}
begin
  if not ProcessedCmdLine then begin
    sfAddFromCmdLine;
    ProcessedCmdLine := True;
    if sfHeader.Text = 'Fax sent by $I using APro    $D $T' then
      sfHeader.Text := 'Fax sent by $I using APro ' + ApdComPort1.Version + '   $D $T';
  end;
end;

procedure TsfMain.SendFaxClick(Sender: TObject);
  {-Send the faxes}
begin
  if not InProgress then begin
    InProgress := True;

    {Get user's values}
    FaxIndex := 0;
    ApdSendFax1.FaxClass := TFaxClass(sfFaxClass.ItemIndex+1);
    try
      ApdSendFax1.DialAttempts := StrToInt(sfDialAttempts.Text);
      ApdSendFax1.DialRetryWait := StrToInt(sfRetryWait.Text);
    except
    end;
    ApdSendFax1.EnhTextEnabled := EnhText.Checked;
    ApdSendFax1.StationID := sfStationID.Text;
    ApdSendFax1.DialPrefix := sfDialPrefix.Text;
    ApdSendFax1.ModemInit := sfModemInit.Text;
    ApdSendFax1.HeaderLine := sfHeader.Text;

    if (ApdComPort1.TapiMode = tmOn) or
       ((ApdComPort1.TapiMode = tmAuto) and
        (ApdTapiDevice1.SelectedDevice <> '')) then begin
      {Tell TAPI to configure and open the port}
      ApdTapiDevice1.ConfigAndOpen;
    end else begin
      {Open the port and start sending}
      try
        ApdComPort1.Open := True;
      except
        InProgress := False;
        raise;
      end;
      ApdSendFax1.StartTransmit;
    end;
  end else
    MessageBeep(0);
end;

procedure TsfMain.sfAppendAddList(FName, CName, PNumber : String);
  {-Append a job to the list waiting to be displayed in the Add dialog}
var
  NewEntry : PAddEntry;
begin
  if AddList = nil then begin
    {empty list}
    GetMem(AddList, sizeof(TAddEntry));
    NewEntry := AddList;
  end else begin
    {find end of list}
    NewEntry := AddList;
    while NewEntry^.NextEntry <> nil do
      NewEntry := NewEntry^.NextEntry;
    GetMem(NewEntry^.NextEntry, sizeof(TAddEntry));
    NewEntry := NewEntry^.NextEntry;
  end;
  FillChar(NewEntry^, SizeOf(TAddEntry), 0);

  with NewEntry^ do begin
    FaxName := FName;
    CoverName := CName;
    PhoneNumber := PNumber;
    NextEntry := nil;
  end;

  inc(AddsPending);
end;

procedure TsfMain.sfGetAddListEntry(var FName, CName, PNumber : String);
  {-Return the values from the first entry in list}
var
  TempEntry : PAddEntry;
begin
  if AddList = nil then
    exit;

  TempEntry := AddList;
  AddList := AddList^.NextEntry;
  with TempEntry^ do begin
    FName := FaxName;
    CName := CoverName;
    PNumber := PhoneNumber;
  end;
  FreeMem(TempEntry, SizeOf(TAddEntry));
  dec(AddsPending);
end;

procedure TsfMain.sfAddPrim;
  {-Display the Add dialog for all Add requests queued}
var
  S : String;
  FName, CName, PNumber : String;
begin
  {prevent multiple occurances of dialog from being displayed}
  AddsInProgress := True;

  {set the button text}
  sfFaxList.flAction.Caption := '&Add';

  while AddsPending > 0 do begin
    {set the data}
    with sfFaxList do begin
      sfGetAddListEntry(FName, CName, PNumber);
      FaxName := FName;
      CoverName := CName;
      PhoneNumber := PNumber;
    end;

    {show the dialog}
    if (sfFaxList.ShowModal = mrOK) and
       (sfFaxList.PhoneNumber <> '') and
       (sfFaxList.FaxName <> '') then begin
      {add this fax entry to the list}
      S := sfFaxList.PhoneNumber + '^' + sfFaxList.FaxName;
      if sfFaxList.CoverName <> '' then
        S := S + '^' + sfFaxList.CoverName;
      FaxList.Add(S);

      {add this fax entry to the list box}
      S := Format('%-20S %-20S %-20S',
                  [LimitS(sfFaxList.PhoneNumber, 20),
                   LimitS(sfFaxList.FaxName, 20),
                   LimitS(sfFaxList.CoverName, 20)]);
      sfFaxListBox.Items.Add(S);
    end;
  end;

  AddsInProgress := False;
end;

procedure TsfMain.sfAddClick(Sender: TObject);
  {-Handle an Add request from the form button}
begin
  sfAppendAddList('', '', '');
  sfAddPrim;
end;

procedure TsfMain.sfAddFromPrinterDriver(var Message: TMessage);
  {-Handle an Add request message send by APFSENDF.DRV printer driver}
var
  JobID  : Word;
  KeyBuf : array[0..8] of Char;
  zFName : array[0..255] of Char;
begin
  {The message received from the printer driver has a job identifier
   in the wParam field.  This job identifier points to an entry in the
   SendFax.Ini file which the printer driver has added.  As SendFax
   handles each message, it should delete that job entry from the Ini
   file and queue the job for display in the Add dialog.}
  with Message do begin
    JobID := wParam;
    StrCopy(KeyBuf, 'Job');
    KeyBuf[3] := Chr(Lo(JobID));
    KeyBuf[4] := #0;
    GetPrivateProfileString('FaxJobs', KeyBuf, '', zFName, sizeof(zFName),
                            'SENDFAX.INI');
    {now delete the entry so the ID can be re-used by the printer driver}
    WritePrivateProfileString('FaxJobs', KeyBuf, nil, 'SENDFAX.INI');
  end;

  sfAppendAddList(StrPas(zFName), '', '');

  if not AddsInProgress then
    sfAddPrim;
end;

procedure TsfMain.sfAddFromCmdLine;
  {-Handle an Add request specified on the command line}
begin
  if ParamStr(1) = '/F' then begin
    sfAppendAddList(ParamStr(2), '', '');

    if not AddsInProgress then
      sfAddPrim;
  end;
end;

procedure TsfMain.ApdSendFax1FaxNext(CP: TObject;
                                     var ANumber, AFileName,
                                     ACoverName: TPassString);
  {-Return the next fax to send}
var
  S : String;
  CaretPos : Byte;
begin
  if FaxList.Count = 0 then Exit;
  try
    S := FaxList[FaxIndex];
    CaretPos := Pos('^', S);
    ANumber := Copy(S, 1, CaretPos-1);
    S := Copy(S, CaretPos+1, 255);
    CaretPos := Pos('^', S);
    if CaretPos = 0 then begin
      AFileName := S;
      ACoverName := '';
    end else begin
      AFileName := Copy(S, 1, CaretPos-1);
      ACoverName := Copy(S, CaretPos+1, 255);
    end;
    Inc(FaxIndex);
  except
    ANumber := '';
    AFileName := '';
    ACoverName := '';
  end;
end;

procedure TsfMain.ApdSendFax1FaxFinish(CP: TObject; ErrorCode: Integer);
  {-Display a finished message}
begin
  ShowMessage('Finished: ' + ErrorMsg(ErrorCode));
  if ApdComPort1.TapiMode = tmOn then
    if ApdTapiDevice1.CancelCall then
      {Call cancelled immediately, clear InProgress flag}
      InProgress := False
    else
      {CancelCall proceeding in background, waiting for OnTapiPortClose}
  else begin
    {Not using TAPI, just close the port and clear the InProgress flag}
    ApdComPort1.Open := False;
    InProgress := False;
  end;
end;

procedure TsfMain.sfExitClick(Sender: TObject);
  {-Exit the application}
var
  TempEntry : PAddEntry;
begin
  while AddList <> nil do begin
    TempEntry := AddList;
    AddList := AddList^.NextEntry;
    FreeMem(TempEntry, SizeOf(TAddEntry));
  end;
  Close;
end;

procedure TsfMain.sfModifyClick(Sender: TObject);
  {-Modify the selected fax entry}
var
  SaveIndex : Integer;
  CPos : Word;
  S : String;
begin
  if InProgress then begin
    MessageBeep(0);
    Exit;
  end;

  {Exit if nothing selected}
  if sfFaxListBox.ItemIndex = -1 then
    Exit;

  {Set the button text}
  sfFaxList.flAction.Caption := '&Modify';

  {Note the listbox index, use it get data from FileList}
  SaveIndex := sfFaxListBox.ItemIndex;
  S := FaxList[SaveIndex];
  CPos := Pos('^', S);
  sfFaxList.PhoneNumber := Copy(S, 1, CPos-1);
  S := Copy(S, CPos+1, 255);
  CPos := Pos('^', S);
  if CPos = 0 then
    sfFaxList.FaxName := S
  else begin
    sfFaxList.FaxName := Copy(S, 1, CPos-1);
    sfFaxList.CoverName := Copy(S, CPos+1, 255);
  end;

  {Show the dialog}
  if sfFaxList.ShowModal = mrOK then begin
    {Modify the FaxList entry}
    S := sfFaxList.PhoneNumber + '^' + sfFaxList.FaxName;
    if sfFaxList.CoverName <> '' then
      S := S + '^' + sfFaxList.CoverName;
    FaxList.Strings[SaveIndex] := S;

    {Add this fax entry to the list box}
    S := Format('%-20S %-20S %-20S',
                [LimitS(sfFaxList.PhoneNumber, 20),
                 LimitS(sfFaxList.FaxName, 20),
                 LimitS(sfFaxList.CoverName, 20)]);
    sfFaxListBox.Items[SaveIndex] := S;
  end;
end;

procedure TsfMain.sfDeleteClick(Sender: TObject);
  {-Delete the selected fax entry}
var
  Index : Word;
begin
  if InProgress then begin
    MessageBeep(0);
    Exit;
  end;

  if sfFaxListBox.ItemIndex <> -1 then begin
    Index := sfFaxListBox.ItemIndex;
    sfFaxListBox.Items.Delete(Index);
    FaxList.Delete(Index);
  end;
end;

procedure TsfMain.ApdSendFax1FaxLog(CP: TObject; LogCode: TFaxLogCode);
  {-Remote this fax entry from the lists, if finished okay}
begin
  if LogCode = lfaxTransmitOK then begin
    Dec(FaxIndex);
    sfFaxListBox.Items.Delete(FaxIndex);
    FaxList.Delete(FaxIndex);
  end;
end;

procedure TsfMain.sfFaxClassClick(Sender: TObject);
  {-Set the new desired fax class}
begin
  ApdSendFax1.FaxClass := TFaxClass(sfFaxClass.ItemIndex+1);
end;

procedure TsfMain.sfDialAttemptsChange(Sender: TObject);
  {-Set the new desired dial attempts}
begin
  try
    ApdSendFax1.DialAttempts := StrToInt(sfDialAttempts.Text);
  except
  end;
end;

procedure TsfMain.sfRetryWaitChange(Sender: TObject);
  {-Set the new desired retry wait}
begin
  try
    ApdSendFax1.DialRetryWait := StrToInt(sfRetryWait.Text);
  except
  end;
end;

procedure TsfMain.sfStationIDChange(Sender: TObject);
  {-Set the new station ID}
begin
  ApdSendFax1.StationID := sfStationID.Text;
end;

procedure TsfMain.sfDialPrefixChange(Sender: TObject);
  {-Set the new dial prefix}
begin
  ApdSendFax1.DialPrefix := sfDialPrefix.Text;
end;

procedure TsfMain.sfModemInitChange(Sender: TObject);
  {-Set the new modem init string}
begin
  ApdSendFax1.ModemInit := sfModemInit.Text;
end;

procedure TsfMain.sfHeaderChange(Sender: TObject);
  {-Set the new header line}
begin
  ApdSendFax1.HeaderLine := sfHeader.Text;
end;

procedure TsfMain.sfSelectComPortClick(Sender: TObject);
begin
  ApdTapiDevice1.SelectDevice;
end;

procedure TsfMain.ApdTapiDevice1TapiPortOpen(Sender: TObject);
begin
  {TAPI port is configured and open, star the fax session}
  ApdSendFax1.StartTransmit;
end;

procedure TsfMain.ApdTapiDevice1TapiPortClose(Sender: TObject);
begin
  InProgress := False;
end;

procedure TsfMain.HdrFontBtnClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(ApdSendFax1.EnhHeaderFont);
  if FontDialog1.Execute then
    ApdSendFax1.EnhHeaderFont.Assign(FontDialog1.Font);
end;

procedure TsfMain.CvrFontBtnClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(ApdSendFax1.EnhFont);
  if FontDialog1.Execute then
    ApdSendFax1.EnhFont.Assign(FontDialog1.Font);
end;

end.
