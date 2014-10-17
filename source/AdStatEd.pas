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
{*                   ADSTATED.PAS 4.06                   *}
{*********************************************************}
{* State machine condition property editor               *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdStatEd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, AdStMach;

type
  TApdStringGrid = class(TStringGrid)
  public
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
  AState: TGridDrawState); override;
  end;

  TfrmStateEdit = class(TForm)
    GroupBox2: TGroupBox;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ConditionGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    ConditionGrid: TApdStringGrid;
    FStateMachine: TApdCustomStateMachine;
    procedure SetStateMachine(const Value: TApdCustomStateMachine);
  public
    { Public declarations }
    Conditions : TStringList;
    AvailableStates : TStringList;
    property StateMachine : TApdCustomStateMachine
      read FStateMachine write SetStateMachine;
  end;

var
  frmStateEdit: TfrmStateEdit;

function EditState(State : TApdCustomState; const Name : string) : Boolean;

implementation

uses AdStatE0;

{$R *.dfm}
const
  HeadingStrs : array[0..12] of string = ('Start|string', 'End|string', 'Ignore|case', 'Size',
    'Timeout', 'Error|code', 'Next|state', 'Caption', 'Color', 'Width',
    'Default|Next','Default|Error','Output|on|Activate');

function EditState(State : TApdCustomState; const Name : string) : Boolean;
var
  StateEdit : TfrmStateEdit;
  I : Integer;
  Str : TStringList;
  Condition : TApdStateCondition;
begin
  Result := False;
  StateEdit := nil;
  Str := nil;
  try
    StateEdit := TfrmStateEdit.Create(nil);
    StateEdit.Caption := Name + ' State conditions editor';
    if State.Parent is TApdCustomStateMachine then
      StateEdit.StateMachine := TApdCustomStateMachine(State.Parent);
    Str := TStringList.Create;
    StateEdit.ConditionGrid.RowCount := State.Conditions.Count + 2;
    for I := 0 to pred(State.Conditions.Count) do begin
      Str.Clear;
      Str.Add(State.Conditions[I].StartString);
      Str.Add(State.Conditions[I].EndString);
      if State.Conditions[I].IgnoreCase then
        Str.Add('Y')
      else
        Str.Add('N');
      Str.Add(IntToStr(State.Conditions[I].PacketSize));
      Str.Add(IntToStr(State.Conditions[I].Timeout));
      Str.Add(IntToStr(State.Conditions[I].ErrorCode));
      if Assigned(State.Conditions[I].NextState) then
        Str.Add(State.Conditions[I].NextState.Name)
      else
        Str.Add('');
      Str.Add(State.Conditions[I].Connectoid.Caption);
      Str.Add(ColorToString(State.Conditions[I].Connectoid.Color));
      Str.Add(IntToStr(State.Conditions[I].Connectoid.Width));
      if State.Conditions[I].DefaultNext then
        Str.Add ('Y')
      else
        Str.Add ('N');
      if State.Conditions[I].DefaultError then
        Str.Add ('Y')
      else
        Str.Add ('N');
      Str.Add (State.Conditions[i].OutputOnActivate);
      StateEdit.ConditionGrid.Rows[I + 1] := Str;
    end;
    if StateEdit.ShowModal = mrOK then begin
      // recreate the conditions
      State.Conditions.Clear;
      for I := 1 to (StateEdit.ConditionGrid.RowCount - 2) do begin
        Condition := State.Conditions.Add;
        Condition.StartString := StateEdit.ConditionGrid.Cells[0, I];
        Condition.EndString := StateEdit.ConditionGrid.Cells[1, I];
        Condition.IgnoreCase := StateEdit.ConditionGrid.Cells[2, I] = 'Y';
        Condition.PacketSize := StrToIntDef(StateEdit.ConditionGrid.Cells[3, I], 0);
        Condition.Timeout := StrToIntDef(StateEdit.ConditionGrid.Cells[4, I], 2048);
        Condition.ErrorCode := StrToIntDef(StateEdit.ConditionGrid.Cells[5, I], 0);
        Condition.NextState := nil;
        if StateEdit.ConditionGrid.Cells[6, I] > '' then
          if Assigned (StateEdit.StateMachine) then
            Condition.NextState :=
              TApdState (StateEdit.StateMachine.Owner.FindComponent (
                   StateEdit.ConditionGrid.Cells[6, I]));
        Condition.Connectoid.Caption := StateEdit.ConditionGrid.Cells[7, I];
        Condition.Connectoid.Color := StringToColor(StateEdit.ConditionGrid.Cells[8, I]);
        Condition.Connectoid.Width := StrToIntDef(StateEdit.ConditionGrid.Cells[9, I], 2);
        Condition.DefaultNext := StateEdit.ConditionGrid.Cells[10, I] = 'Y';
        Condition.DefaultError := StateEdit.ConditionGrid.Cells[11, I] = 'Y';
        Condition.OutputOnActivate := StateEdit.ConditionGrid.Cells[12, I]; 
      end;
    end;
  finally
    Str.Free;
    StateEdit.Free;
  end;
end;

procedure TfrmStateEdit.FormCreate(Sender: TObject);
var
  I : Integer;
begin
  { free the ConditionGrid put here at design-time, we're creating a new one }
  ConditionGrid := TApdStringGrid.Create(Self);
  ConditionGrid.Parent := GroupBox2;
  with ConditionGrid do begin
    Left := 8;
    Top := 16;
    Width := 513;
    Height := 130;
    ColCount := 13;
    DefaultColWidth := 50;
    FixedCols := 0;
    Font.Charset := DEFAULT_CHARSET;
    Font.Color := clWindowText;
    Font.Height := -11;
    Font.Name := 'MS Sans Serif';
    Font.Style := [];
    Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goColSizing,
                goHorzLine, goRowSelect];
    ParentFont := False;
    TabOrder := 0;
    OnSelectCell := ConditionGridSelectCell;
  end;
  ConditionGrid.DefaultRowHeight := ConditionGrid.Canvas.TextHeight('W') + 8;
  ConditionGrid.RowHeights[0] := ConditionGrid.DefaultRowHeight + ConditionGrid.Canvas.TextHeight('W');
  for I := 0 to pred(ConditionGrid.ColCount) do begin
    ConditionGrid.Cells[I, 0] := HeadingStrs[I];
  end;
  Conditions := TStringList.Create;
  AvailableStates := TStringList.Create;

  {$IFDEF Delphi4}
  BorderStyle := bsSizeable;
  ConditionGrid.Anchors := [akLeft,akTop,akRight,akBottom];
  GroupBox2.Anchors := [akLeft,akTop,akRight,akBottom];
  Constraints.MinHeight := btnOK.Height * 9;
  Constraints.MinWidth := btnOK.Width * 4;
  ConditionGrid.Anchors := [akLeft, akTop, akRight, akBottom];
  {$ELSE}
  BorderStyle := bsDialog;
  {$ENDIF}
end;

procedure TfrmStateEdit.FormDestroy(Sender: TObject);
begin
  { don't need to free the objects, they are still in use }
  Conditions.Free;
  AvailableStates.Free;
end;

procedure TfrmStateEdit.SetStateMachine(
  const Value: TApdCustomStateMachine);
begin
  FStateMachine := Value;
  AvailableStates.Clear;
  if FStateMachine <> nil then
    AvailableStates := FStateMachine.StateNames;
end;

procedure TfrmStateEdit.ConditionGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  btnEdit.Enabled := ARow in [1..ConditionGrid.RowCount - 2];
  btnDelete.Enabled := btnEdit.Enabled;
end;

procedure TfrmStateEdit.btnAddClick(Sender: TObject);
var
  CondEdit : TfrmConditionEdit;
  I : Integer;
begin
  CondEdit := nil;
  try
    CondEdit := TfrmConditionEdit.Create(nil);
    CondEdit.Clear;
    CondEdit.AvailStates.Clear;
    CondEdit.AvailStates := AvailableStates;
    if CondEdit.ShowModal = mrOK then begin
      I := ConditionGrid.RowCount - 1;
      ConditionGrid.Cells[0, I] := CondEdit.edtStartString.Text;
      ConditionGrid.Cells[1, I] := CondEdit.edtEndString.Text;
      if CondEdit.chkIgnoreCase.Checked then
        ConditionGrid.Cells[2, I] := 'Y'
      else
        ConditionGrid.Cells[2, I] := 'N';
      ConditionGrid.Cells[3, I] := CondEdit.edtPacketSize.Text;
      ConditionGrid.Cells[4, I] := CondEdit.edtTimeout.Text;
      ConditionGrid.Cells[5, I] := CondEdit.edtErrorCode.Text;
      ConditionGrid.Cells[6, I] := CondEdit.cbxNextState.Text;
      ConditionGrid.Cells[7, I] := CondEdit.edtCaption.Text;
      ConditionGrid.Cells[8, I] := CondEdit.cbxColor.Text;
      ConditionGrid.Cells[9, I] := CondEdit.edtWidth.Text;
      if CondEdit.DefaultNext.Checked then
        ConditionGrid.Cells[10, I] := 'Y'
      else
        ConditionGrid.Cells[10, I] := 'N';
      if CondEdit.DefaultError.Checked then
        ConditionGrid.Cells[11, I] := 'Y'
      else
        ConditionGrid.Cells[11, I] := 'N';
      ConditionGrid.Cells[12, I] := CondEdit.edtOutputOnActivate.Text;
      ConditionGrid.RowCount := ConditionGrid.RowCount + 1;
    end;

  finally
    CondEdit.Free;
  end;
end;

procedure TfrmStateEdit.btnEditClick(Sender: TObject);
var
  CondEdit : TfrmConditionEdit;
  I : Integer;
begin
  CondEdit := nil;
  try
    I := ConditionGrid.Row;
    CondEdit := TfrmConditionEdit.Create(nil);
    CondEdit.AvailStates.Clear;
    CondEdit.AvailStates := AvailableStates;
    CondEdit.edtStartString.Text := ConditionGrid.Cells[0, I];
    CondEdit.edtEndString.Text := ConditionGrid.Cells[1, I];
    CondEdit.chkIgnoreCase.Checked := ConditionGrid.Cells[2, I] = 'Y';
    CondEdit.edtPacketSize.Text := ConditionGrid.Cells[3, I];
    CondEdit.edtTimeout.Text := ConditionGrid.Cells[4, I];
    CondEdit.edtErrorCode.Text := ConditionGrid.Cells[5, I];
//    CondEdit.cbxNextState.Text := ConditionGrid.Cells[6, I];
//    CondEdit.cbxNextState.ItemIndex := CondEdit.cbxNextState.Items.IndexOf(ConditionGrid.Cells[6,I]);
    CondEdit.SetNextState(ConditionGrid.Cells[6, I]);
    CondEdit.edtCaption.Text := ConditionGrid.Cells[7, I];
//    CondEdit.cbxColor.Text := ConditionGrid.Cells[8, I];
    CondEdit.SetColor(ConditionGrid.Cells[8,I]);
    CondEdit.edtWidth.Text := ConditionGrid.Cells[9, I];
    CondEdit.DefaultNext.Checked := ConditionGrid.Cells[10, I] = 'Y';
    CondEdit.DefaultError.Checked := ConditionGrid.Cells[11, I] = 'Y';
    CondEdit.edtOutputOnActivate.Text := ConditionGrid.Cells[12, I];

    if CondEdit.ShowModal = mrOK then begin
      ConditionGrid.Cells[0, I] := CondEdit.edtStartString.Text;
      ConditionGrid.Cells[1, I] := CondEdit.edtEndString.Text;
      if CondEdit.chkIgnoreCase.Checked then
        ConditionGrid.Cells[2, I] := 'Y'
      else
        ConditionGrid.Cells[2, I] := 'N';
      ConditionGrid.Cells[3, I] := CondEdit.edtPacketSize.Text;
      ConditionGrid.Cells[4, I] := CondEdit.edtTimeout.Text;
      ConditionGrid.Cells[5, I] := CondEdit.edtErrorCode.Text;
      ConditionGrid.Cells[6, I] := CondEdit.cbxNextState.Text;
      ConditionGrid.Cells[7, I] := CondEdit.edtCaption.Text;
      ConditionGrid.Cells[8, I] := CondEdit.cbxColor.Text;
      ConditionGrid.Cells[9, I] := CondEdit.edtWidth.Text;
      if CondEdit.DefaultNext.Checked then
        ConditionGrid.Cells[10, I] := 'Y'
      else
        ConditionGrid.Cells[10, I] := 'N';
      if CondEdit.DefaultError.Checked then
        ConditionGrid.Cells[11, I] := 'Y'
      else
        ConditionGrid.Cells[11, I] := 'N';
      ConditionGrid.Cells[12, I] := CondEdit.edtOutputOnActivate.Text;
    end;
  finally
    CondEdit.Free;
  end;
end;

procedure TfrmStateEdit.btnDeleteClick(Sender: TObject);
var
  I : Integer;
begin
  for I := ConditionGrid.Row to ConditionGrid.RowCount do begin
    ConditionGrid.Rows[I].Clear;
    ConditionGrid.Rows[I] := ConditionGrid.Rows[I + 1];
  end;
  ConditionGrid.RowCount := ConditionGrid.RowCount - 1;
end;

procedure TfrmStateEdit.FormResize(Sender: TObject);
begin
  { move controls horizontally }
  btnCancel.Left := Width - btnCancel.Width - 16;
  btnOK.Left := btnCancel.Left - btnOK.Width - 8;
  GroupBox2.Width := Width - 16 - GroupBox2.Left;
  btnDelete.Left := GroupBox2.Width - btnDelete.Width - 8;
  btnEdit.Left := btnDelete.Left - btnEdit.Width - 8;
  btnAdd.Left := btnEdit.Left - btnAdd.Width - 8;
  ConditionGrid.Width := GroupBox2.Width - 16;
  { now move them vertically }
  btnCancel.Top := ClientHeight - btnCancel.Height - 8;
  btnOK.Top := btnCancel.Top;
  GroupBox2.Height := btnCancel.Top - GroupBox2.Top - 8;
  btnDelete.Top := GroupBox2.ClientHeight - btnDelete.Height - 8;
  btnEdit.Top := btnDelete.Top;
  btnAdd.Top := btnDelete.Top;

end;

{ TApdStringGrid }

procedure TApdStringGrid.DrawCell(ACol, ARow: Integer;
  ARect: TRect; AState: TGridDrawState);
var
  S : string;
begin
  { draw multi-line boxes }
  if (ARow = 0) and (Pos('|', Cells[ACol, ARow]) > 0) then begin
    S := Copy(Cells[ACol, ARow], 1, Pos('|', Cells[ACol, ARow]) - 1);
    Canvas.TextRect(ARect, ARect.Left + 2, ARect.Top + 2, S);
    S := Copy(Cells[ACol, ARow], Length(S) + 2, Length(Cells[ACol, ARow]));
    ARect.Top := ARect.Top + Canvas.TextHeight(S);
    Canvas.TextRect(ARect, ARect.Left + 2, ARect.Top + 2, S);
  end else
    inherited;
end;


end.

