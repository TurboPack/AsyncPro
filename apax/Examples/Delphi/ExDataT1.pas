unit ExDatat1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, OleCtrls, Apax1_TLB;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    lbxTriggersAssigned: TListBox;
    PopupMenu1: TPopupMenu;
    AddTrigger1: TMenuItem;
    DisableTrigger1: TMenuItem;
    EnableTrigger1: TMenuItem;
    RemoveTrigger1: TMenuItem;
    Label1: TLabel;
    lbxTriggersFired: TListBox;
    Label2: TLabel;
    N1: TMenuItem;
    Clear1: TMenuItem;
    Apax1: TApax;
    procedure AddTrigger1Click(Sender: TObject);
    procedure Apax1DataTrigger(Sender: TObject; Index: Integer;
      Timeout: WordBool; Data: OleVariant; Size: Integer;
      var ReEnable: WordBool);
    procedure Apax1PortOpen(Sender: TObject);
    procedure lbxTriggersFiredDblClick(Sender: TObject);
    procedure DisableTrigger1Click(Sender: TObject);
    procedure RemoveTrigger1Click(Sender: TObject);
    procedure EnableTrigger1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
  private
    function GetSelectedIndex : Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  ExDataT2;


function TForm1.GetSelectedIndex : Integer;
var
  i : Integer;
begin
  Result := -1;
  for i := 0 to Pred(lbxTriggersAssigned.Items.Count) do
    if lbxTriggersAssigned.Selected[i] then begin
      Result := i;
      Break;
    end;
end;

procedure TForm1.Apax1PortOpen(Sender: TObject);
begin
  Apax1.TerminalSetFocus;
end;

procedure TForm1.AddTrigger1Click(Sender: TObject);
var
  Index : Integer;
begin
  with frmAddTrigger do
    if ShowModal = mrOK then begin
      Index := Apax1.AddDataTrigger(TriggerString, PacketSize, Timeout,
        IncludeStrings, IgnoreCase {, TriggerEnabled});
      if (Index > -1) then
        lbxTriggersAssigned.Items.Insert(Index, TriggerString);
    end;
end;

procedure TForm1.Apax1DataTrigger(Sender: TObject; Index: Integer;
  Timeout: WordBool; Data: OleVariant; Size: Integer;
  var ReEnable: WordBool);
begin
  if (Index > -1) and (Index < lbxTriggersAssigned.Items.Count) then
    lbxTriggersFired.Items.Add(lbxTriggersAssigned.Items[Index])
  else
    lbxTriggersFired.Items.Add('Unknown trigger index ' + IntToStr(Index));
  ReEnable := True;
end;

procedure TForm1.lbxTriggersFiredDblClick(Sender: TObject);
begin
  TListBox(Sender).Clear;
end;

procedure TForm1.DisableTrigger1Click(Sender: TObject);
var
  i : Integer;
begin
  i := GetSelectedIndex;
  if (i > -1) then
    Apax1.DisableDataTrigger(i);
end;

procedure TForm1.EnableTrigger1Click(Sender: TObject);
var
  i : Integer;
begin
  i := GetSelectedIndex;
  if (i > -1) then
    Apax1.EnableDataTrigger(i);
end;

procedure TForm1.RemoveTrigger1Click(Sender: TObject);
var
  i : Integer;
begin
  i := GetSelectedIndex;
  if (i > -1) then begin
    lbxTriggersAssigned.Items.Delete(i);
    Apax1.RemoveDataTrigger(i);
  end;
end;

procedure TForm1.Clear1Click(Sender: TObject);
begin
  Apax1.RemoveAllDataTriggers;
  lbxTriggersAssigned.Clear;
end;

end.
