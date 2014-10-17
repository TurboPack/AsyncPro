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

{*********************************************************}
{*                   FAXSRVX0.PAS 4.06                   *}
{*********************************************************}

{**********************Description************************}
{* An example of a fax server using TAPI.                *}
{*********************************************************}

unit FaxSrvx0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, OoMisc, AdFax, AdFStat, AdPort, ExtCtrls,
  FaxSrvx1, AdTapi, AdFaxCtl, AdExcept;

type
  PAddEntry = ^TAddEntry;
  TAddEntry = record
    FaxName     : String;
    CoverName   : String;
    PhoneNumber : String;
    NextEntry   : PAddEntry;
  end;

  TfsMain = class(TForm)
    ApdComPort1: TApdComPort;
    ApdFaxStatus1: TApdFaxStatus;
    ApdSendFax1: TApdSendFax;
    SendFax: TButton;
    fsAdd: TButton;
    fsExit: TButton;
    Panel1: TPanel;
    fsFaxClass: TRadioGroup;
    Label1: TLabel;
    fsModemInit: TEdit;
    fsModify: TButton;
    fsDelete: TButton;
    Label2: TLabel;
    fsHeader: TEdit;
    Label3: TLabel;
    fsStationID: TEdit;
    Label4: TLabel;
    fsDialPrefix: TEdit;
    Label5: TLabel;
    fsDialAttempts: TEdit;
    Label6: TLabel;
    fsRetryWait: TEdit;
    fsFaxListBox: TListBox;
    Label7: TLabel;
    ApdFaxLog1: TApdFaxLog;
    fsSelectComPort: TButton;
    ApdTapiDevice1: TApdTapiDevice;
    ApdFaxDriverInterface1: TApdFaxDriverInterface;
    procedure SendFaxClick(Sender: TObject);
    procedure fsAppendAddList(FName, CName, PNumber : String);
    procedure fsGetAddListEntry(var FName, CName, PNumber : String);
    procedure fsAddPrim;
    procedure fsAddClick(Sender: TObject);
    procedure ApdSendFax1FaxNext(CP: TObject; var ANumber, AFileName,
      ACoverName: TPassString);
    procedure ApdSendFax1FaxFinish(CP: TObject; ErrorCode: Integer);
    procedure fsExitClick(Sender: TObject);
    procedure fsModifyClick(Sender: TObject);
    procedure fsDeleteClick(Sender: TObject);
    procedure ApdSendFax1FaxLog(CP: TObject; LogCode: TFaxLogCode);
    procedure fsFaxClassClick(Sender: TObject);
    procedure fsDialAttemptsChange(Sender: TObject);
    procedure fsRetryWaitChange(Sender: TObject);
    procedure fsStationIDChange(Sender: TObject);
    procedure fsDialPrefixChange(Sender: TObject);
    procedure fsModemInitChange(Sender: TObject);
    procedure fsHeaderChange(Sender: TObject);
    procedure fsSelectComPortClick(Sender: TObject);
    procedure ApdTapiDevice1TapiPortOpen(Sender: TObject);
    procedure ApdTapiDevice1TapiPortClose(Sender: TObject);
    procedure ApdFaxDriverInterface1DocStart(Sender: TObject);
    procedure ApdFaxDriverInterface1DocEnd(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FaxList     : TStringList;
    FaxIndex    : Word;
    InProgress  : Boolean;

    AddsInProgress    : Boolean;
    AddsPending       : Word;
    AddList           : PAddEntry;

  public
    { Public declarations }
    constructor Create(AComponent : TComponent); override;
    destructor Destroy; override;
    procedure AddPrim(var Message : TMessage);
      message apw_AddPrim;
  end;

var
  fsMain: TfsMain;

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

constructor TfsMain.Create(AComponent : TComponent);
  {-Create the form}
begin
  inherited Create(AComponent);
  FaxList     := TStringList.Create;
  InProgress  := False;
  AddList     := nil;
  AddsPending := 0;
  AddsInProgress := False;
end;

destructor TfsMain.Destroy;
begin
  FaxList.Free;
  inherited Destroy;
end;

procedure TfsMain.SendFaxClick(Sender: TObject);
  {-Send the faxes}
begin
  if not InProgress then begin
    InProgress := True;

    {Get user's values}
    FaxIndex := 0;
    ApdSendFax1.FaxClass := TFaxClass(fsFaxClass.ItemIndex+1);
    try
      ApdSendFax1.DialAttempts := StrToInt(fsDialAttempts.Text);
      ApdSendFax1.DialRetryWait := StrToInt(fsRetryWait.Text);
    except
    end;
    ApdSendFax1.StationID := fsStationID.Text;
    ApdSendFax1.DialPrefix := fsDialPrefix.Text;
    ApdSendFax1.ModemInit := fsModemInit.Text;
    ApdSendFax1.HeaderLine := fsHeader.Text;

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

procedure TfsMain.fsAppendAddList(FName, CName, PNumber : String);
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

procedure TfsMain.fsGetAddListEntry(var FName, CName, PNumber : String);
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

procedure TfsMain.fsAddPrim;
  {-Display the Add dialog for all Add requests queued}
var
  S : String;
  FName, CName, PNumber : String;
begin
  {prevent multiple occurances of dialog from being displayed}
  AddsInProgress := True;

  {set the button text}
  fsFaxList.flAction.Caption := '&Add';

  while AddsPending > 0 do begin
    {set the data}
    with fsFaxList do begin
      fsGetAddListEntry(FName, CName, PNumber);
      FaxName := FName;
      CoverName := CName;
      PhoneNumber := PNumber;
    end;

    {show the dialog}
    if (fsFaxList.ShowModal = mrOK) and
       (fsFaxList.PhoneNumber <> '') and
       (fsFaxList.FaxName <> '') then begin
      {add this fax entry to the list}
      S := fsFaxList.PhoneNumber + '^' + fsFaxList.FaxName;
      if fsFaxList.CoverName <> '' then
        S := S + '^' + fsFaxList.CoverName;
      FaxList.Add(S);

      {add this fax entry to the list box}
      S := Format('%-20S %-20S %-20S',
                  [LimitS(fsFaxList.PhoneNumber, 20),
                   LimitS(fsFaxList.FaxName, 20),
                   LimitS(fsFaxList.CoverName, 20)]);
      fsFaxListBox.Items.Add(S);
    end;
  end;

  AddsInProgress := False;
end;

procedure TfsMain.fsAddClick(Sender: TObject);
  {-Handle an Add request from the form button}
begin
  fsAppendAddList('', '', '');
  fsAddPrim;
end;

procedure TfsMain.ApdSendFax1FaxNext(CP: TObject;
                                     var ANumber, AFileName,
                                     ACoverName: TPassString);
  {-Return the next fax to send}
var
  S : String;
  CaretPos : Byte;
begin
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

procedure TfsMain.ApdSendFax1FaxFinish(CP: TObject; ErrorCode: Integer);
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

procedure TfsMain.fsExitClick(Sender: TObject);
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

procedure TfsMain.fsModifyClick(Sender: TObject);
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
  if fsFaxListBox.ItemIndex = -1 then
    Exit;

  {Set the button text}
  fsFaxList.flAction.Caption := '&Modify';

  {Note the listbox index, use it get data from FileList}
  SaveIndex := fsFaxListBox.ItemIndex;
  S := FaxList[SaveIndex];
  CPos := Pos('^', S);
  fsFaxList.PhoneNumber := Copy(S, 1, CPos-1);
  S := Copy(S, CPos+1, 255);
  CPos := Pos('^', S);
  if CPos = 0 then
    fsFaxList.FaxName := S
  else begin
    fsFaxList.FaxName := Copy(S, 1, CPos-1);
    fsFaxList.CoverName := Copy(S, CPos+1, 255);
  end;

  {Show the dialog}
  if fsFaxList.ShowModal = mrOK then begin
    {Modify the FaxList entry}
    S := fsFaxList.PhoneNumber + '^' + fsFaxList.FaxName;
    if fsFaxList.CoverName <> '' then
      S := S + '^' + fsFaxList.CoverName;
    FaxList.Strings[SaveIndex] := S;

    {Add this fax entry to the list box}
    S := Format('%-20S %-20S %-20S',
                [LimitS(fsFaxList.PhoneNumber, 20),
                 LimitS(fsFaxList.FaxName, 20),
                 LimitS(fsFaxList.CoverName, 20)]);
    fsFaxListBox.Items[SaveIndex] := S;
  end;
end;

procedure TfsMain.fsDeleteClick(Sender: TObject);
  {-Delete the selected fax entry}
var
  Index : Word;
begin
  if InProgress then begin
    MessageBeep(0);
    Exit;
  end;

  if fsFaxListBox.ItemIndex <> -1 then begin
    Index := fsFaxListBox.ItemIndex;
    fsFaxListBox.Items.Delete(Index);
    FaxList.Delete(Index);
  end;
end;

procedure TfsMain.ApdSendFax1FaxLog(CP: TObject; LogCode: TFaxLogCode);
  {-Remote this fax entry from the lists, if finished okay}
begin
  if LogCode = lfaxTransmitOK then begin
    Sysutils.DeleteFile(ApdSendFax1.FaxFile);
    Dec(FaxIndex);
    fsFaxListBox.Items.Delete(FaxIndex);
    FaxList.Delete(FaxIndex);
  end;
end;

procedure TfsMain.fsFaxClassClick(Sender: TObject);
  {-Set the new desired fax class}
begin
  ApdSendFax1.FaxClass := TFaxClass(fsFaxClass.ItemIndex+1);
end;

procedure TfsMain.fsDialAttemptsChange(Sender: TObject);
  {-Set the new desired dial attempts}
begin
  try
    ApdSendFax1.DialAttempts := StrToInt(fsDialAttempts.Text);
  except
  end;
end;

procedure TfsMain.fsRetryWaitChange(Sender: TObject);
  {-Set the new desired retry wait}
begin
  try
    ApdSendFax1.DialRetryWait := StrToInt(fsRetryWait.Text);
  except
  end;
end;

procedure TfsMain.fsStationIDChange(Sender: TObject);
  {-Set the new station ID}
begin
  ApdSendFax1.StationID := fsStationID.Text;
end;

procedure TfsMain.fsDialPrefixChange(Sender: TObject);
  {-Set the new dial prefix}
begin
  ApdSendFax1.DialPrefix := fsDialPrefix.Text;
end;

procedure TfsMain.fsModemInitChange(Sender: TObject);
  {-Set the new modem init string}
begin
  ApdSendFax1.ModemInit := fsModemInit.Text;
end;

procedure TfsMain.fsHeaderChange(Sender: TObject);
  {-Set the new header line}
begin
  ApdSendFax1.HeaderLine := fsHeader.Text;
end;

procedure TfsMain.fsSelectComPortClick(Sender: TObject);
begin
  ApdTapiDevice1.SelectDevice;
end;

procedure TfsMain.ApdTapiDevice1TapiPortOpen(Sender: TObject);
begin
  {TAPI port is configured and open, star the fax session}
  ApdSendFax1.StartTransmit;
end;

procedure TfsMain.ApdTapiDevice1TapiPortClose(Sender: TObject);
begin
  InProgress := False;
end;

procedure TfsMain.ApdFaxDriverInterface1DocStart(Sender: TObject);
var
  FaxFile : array[0..255] of char;
begin
  {Generate a unique filename}
  {$IFDEF Win32}
  GetTempFilename('.', '~AP', 0, FaxFile);
  {$ELSE}
  GetTempFilename(char(0 or tf_ForceDrive), DefApfExt, 0, FaxFile);
  {$ENDIF}
  ApdFaxDriverInterface1.FileName := ExpandFilename(StrPas(faxFile));
end;

procedure TfsMain.ApdFaxDriverInterface1DocEnd(Sender: TObject);
begin
  { Queue the job for display in the Add dialog.}
  fsAppendAddList(ApdFaxDriverInterface1.FileName, '', '');

  if not AddsInProgress then
    {we're called in the context of the driver here, so we can't do UI stuff directly}
    PostMessage(Handle,apw_AddPrim,0,0);
end;

procedure TfsMain.AddPrim(var Message: TMessage);
  {- call the AddPrim routine }
begin
  fsAddPrim;
end;

procedure TfsMain.FormCreate(Sender: TObject);
begin
  { Set the header to include the version }
  if fsHeader.Text = 'Fax sent by $I using APro    $D $T' then
    fsHeader.Text := 'Fax sent by $I using APro ' + ApdComPort1.Version + '    $D $T'
end;

end.
