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

unit fxJobDlg;

interface

uses
  {$IFDEF Ver80}
  WinTypes, WinProcs,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AdFView, Menus, OoMisc, AdFaxSrv, AdExcept;

type
  TFaxJobDesigner = class(TForm)
    edtJobName: TEdit;
    edtSender: TEdit;
    edtPhone: TEdit;
    edtHeader: TEdit;
    edtRecipient: TEdit;
    edtTitle: TEdit;
    edtCoverFile: TEdit;
    edtFaxFile: TEdit;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    PopupMenu1: TPopupMenu;
    pumSave: TMenuItem;
    pumLoad: TMenuItem;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    mnuSave: TMenuItem;
    mnuSaveAs: TMenuItem;
    mnuOpen: TMenuItem;
    mnuNew: TMenuItem;
    mnuExit: TMenuItem;
    N1: TMenuItem;
    ViewerPopupMenu: TPopupMenu;
    N4: TMenuItem;
    N25PercentItem1: TMenuItem;
    N50PercentItem1: TMenuItem;
    N75PercentItem1: TMenuItem;
    N100PercentItem1: TMenuItem;
    N200PercentItem1: TMenuItem;
    N400PercentItem1: TMenuItem;
    N5: TMenuItem;
    NoRotateItem1: TMenuItem;
    Rotate90Item1: TMenuItem;
    Rotate180Item1: TMenuItem;
    Rotate270Item1: TMenuItem;
    Nextpage1: TMenuItem;
    Prevpage1: TMenuItem;
    lblPages: TLabel;
    SaveDialog1: TSaveDialog;
    lblNextSched: TLabel;
    lblFileName: TLabel;
    lblFileStatus: TLabel;
    lblNumJobs: TLabel;
    lblJobStatus: TLabel;
    lblJobSched: TLabel;
    lblNumAttempts: TLabel;
    FaxViewer: TApdFaxViewer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure pumSaveClick(Sender: TObject);
    procedure mnuNewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure FaxViewerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ZoomPercentClick(Sender: TObject);
    procedure RotateItemClick(Sender: TObject);
    procedure Nextpage1Click(Sender: TObject);
    procedure Prevpage1Click(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);
    procedure mnuSaveAsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    IsDirty: Boolean;
    JobInfo: TFaxRecipientRec;
    JobHeader: TFaxJobHeaderRec;
    JobFileName: ShortString;
    ViewPercent : Integer;
    FaxJobHandler: TApdFaxJobHandler;
    procedure InitFields;
    procedure PopulateFields;
    procedure UpDateViewPercent(NewPercent: Integer);
  end;

var
  FaxJobDesigner: TFaxJobDesigner;

implementation

{$R *.DFM}

procedure TFaxJobDesigner.Button1Click(Sender: TObject);
begin
  OpenDialog1.Title := 'Open cover text';
  OpenDialog1.Filter := 'Text cover page (*.txt)|*.txt|All files (*.*)|*.*';
  if Uppercase(ExtractFileExt(OpenDialog1.FileName)) <> '.TXT' then
    OpenDialog1.FileName := '';
  if OpenDialog1.Execute then begin
    edtCoverFile.Text := OpenDialog1.FileName;
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
  end;
end;

procedure TFaxJobDesigner.Button2Click(Sender: TObject);
begin
  OpenDialog1.Title := 'Open fax file';
  OpenDialog1.Filter := 'Fax file (*.apf)|*.apf|All files (*.*)|*.*';
  if Uppercase(ExtractFileExt(OpenDialog1.FileName)) <> '.APF' then
    OpenDialog1.FileName := '';
  if OpenDialog1.Execute then begin
    edtFaxFile.Text := OpenDialog1.FileName;
    FaxViewer.FileName := OpenDialog1.FileName;
    N25PercentItem1.Click;
    NextPage1.Enabled := FaxViewer.ActivePage < FaxViewer.NumPages;
    PrevPage1.Enabled := FaxViewer.ActivePage > 1;

    lblPages.Caption := 'Page ' + IntToStr(FaxViewer.ActivePage) + ' of ' +
      IntToStr(FaxViewer.NumPages);
  end;
end;

procedure TFaxJobDesigner.pumSaveClick(Sender: TObject);
begin
  Memo1.Lines.SaveToFile(edtCoverFile.Text);
end;

procedure TFaxJobDesigner.mnuNewClick(Sender: TObject);
begin
  InitFields;
end;

procedure TFaxJobDesigner.InitFields;
begin
  IsDirty := False;
  JobFileName := '';
  edtJobName.Text := '';
  edtSender.Text := '';
  edtPhone.Text := '';
  edtHeader.Text := '';
  edtRecipient.Text := '';
  edtTitle.Text := '';
  edtCoverFile.Text := '';
  edtFaxFile.Text := '';
  Memo1.Lines.Clear;
  lblFileName.Caption := '<no file opened>';
  lblFileStatus.Caption := 'Unknown';
  lblNextSched.Caption := '';
  lblNumJobs.Caption := '0';
  lblJobStatus.Caption := 'Unknown';
  lblJobSched.Caption := '';
  lblNumAttempts.Caption := '0';
  with JobHeader do begin
    ID := apfDefJobHeaderID;
    Status := stNone;
    JobName := '';
    Sender := '';
    SchedDT := Now;
    NumJobs := 0;
    NextJob := 0;
    FillChar(Padding, SizeOf(Padding), #0);
  end;
  with JobInfo do begin
    Status := 0;
    SchedDT := Now;
    AttemptNum := 0;
    LastResult := ecOK;
    HeaderLine := '';
    HeaderRecipient := '';
    HeaderTitle := '';
    FillChar(Padding, SizeOf(Padding), #0);
  end;
  PopulateFields;
end;

procedure TFaxJobDesigner.FormCreate(Sender: TObject);
begin
  FaxJobHandler := TApdFaxJobHandler.Create(Self);
  InitFields;
end;

procedure TFaxJobDesigner.mnuOpenClick(Sender: TObject);
var
  S: String;
begin
  OpenDialog1.Title := 'Open fax job';
  OpenDialog1.Filter := 'Fax job files (*.apj)|*.apj|All files (*.*)|*.*';
  if Uppercase(ExtractFileExt(OpenDialog1.FileName)) <> '.APJ' then
    OpenDialog1.FileName := '';
  if OpenDialog1.Execute then begin
    IsDirty := False;
    Caption := 'Fax job designer - ' + OpenDialog1.FileName;
    InitFields;
    JobFileName := OpenDialog1.FileName;
    S := OpenDialog1.FileName;
    if FaxJobHandler.ExtractCoverFile(S, ChangeFileExt(S, '.txt')) then
      Memo1.Lines.LoadFromFile(ChangeFileExt(S, '.txt'));
    edtCoverFile.Text := ChangeFileExt(S, '.txt');

    FaxJobHandler.ExtractAPF(S, ChangeFileExt(S, '.apf'));
    edtFaxFile.Text := ChangeFileExt(S, '.apf');
    FaxViewer.FileName := ChangeFileExt(S, '.apf');
    N25PercentItem1.Click;
    lblPages.Caption := 'Page ' + IntToStr(FaxViewer.ActivePage) + ' of ' +
      IntToStr(FaxViewer.NumPages);
    NextPage1.Enabled := FaxViewer.ActivePage < FaxViewer.NumPages;
    PrevPage1.Enabled := FaxViewer.ActivePage > 1;


    FaxJobHandler.GetRecipient(S, 1, JobInfo);
    FaxJobHandler.GetJobHeader(S, JobHeader);

    PopulateFields;
  end;
end;

procedure TFaxJobDesigner.PopulateFields;
var
  S: ShortString;
begin
  edtJobName.Text := JobHeader.JobName;
  edtSender.Text := JobHeader.Sender;
  edtPhone.Text := JobInfo.PhoneNumber;
  edtHeader.Text := JobInfo.HeaderLine;
  edtRecipient.Text := JobInfo.HeaderRecipient;
  edtTitle.Text := JobInfo.HeaderTitle;

  lblFileName.Caption := JobFileName;
  case JobHeader.Status of
    stNone: S := 'No jobs have been sent';
    stPartial: S := 'Some jobs have been sent';
    stComplete: S := 'All jobs have been sent';
  end;
  lblFileStatus.Caption := S;

  lblNextSched.Caption := 'Job #' + IntToStr(JobHeader.NextJob) +
    ' is scheduled for ' + DateTimeToStr(JobHeader.SchedDT);
  lblNumJobs.Caption := IntToStr(JobHeader.NumJobs);
  case JobInfo.Status of
    stNone: begin
      if JobInfo.LastResult = ecOK then
        S := 'This job has not been sent'
      else
        S := 'This job is awaiting retry';
    end;
    stPartial: S := 'This job is being sent';
    stComplete: begin
      if JobInfo.LastResult = ecOK then
        S := 'This job was sent OK'
      else
        S := 'This job failed (' + ErrorMsg(JobInfo.LastResult) + ')';
    end;
  end;
  lblJobStatus.Caption := S;
  lblJobSched.Caption := DateTimeToStr(JobInfo.SchedDT);
  lblNumAttempts.Caption := IntToStr(JobInfo.AttemptNum);
end;

procedure TFaxJobDesigner.FaxViewerMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    ViewerPopupMenu.Popup(X + Left + FaxViewer.Left, Y + Top + FaxViewer.Top);
end;

procedure TFaxJobDesigner.ZoomPercentClick(Sender: TObject);
begin
  UpdateViewPercent((Sender as TMenuItem).Tag);
end;

procedure TFaxJobDesigner.UpDateViewPercent(NewPercent: Integer);
begin
  if (NewPercent = ViewPercent) then
    Exit;

  ViewPercent := NewPercent;

  if (NewPercent = 100) then
    FaxViewer.Scaling := False
  else begin
    FaxViewer.BeginUpdate;
    FaxViewer.Scaling   := True;
    FaxViewer.HorizMult := NewPercent;
    FaxViewer.HorizDiv  := 100;
    FaxViewer.VertMult  := NewPercent;
    FaxViewer.VertDiv   := 100;
    FaxViewer.EndUpdate;
  end;

  N25PercentItem1.Checked  := ViewPercent = 25;
  N50PercentItem1.Checked  := ViewPercent = 50;
  N75PercentItem1.Checked  := ViewPercent = 75;
  N100PercentItem1.Checked := ViewPercent = 100;
  N200PercentItem1.Checked := ViewPercent = 200;
  N400PercentItem1.Checked := ViewPercent = 400;
end;

procedure TFaxJobDesigner.RotateItemClick(Sender: TObject);
begin
  FaxViewer.Rotation := TViewerRotation((Sender as TMenuItem).Tag);
  NoRotateItem1.Checked  := FaxViewer.Rotation = vr0;
  Rotate90Item1.Checked  := FaxViewer.Rotation = vr90;
  Rotate180Item1.Checked := FaxViewer.Rotation = vr180;
  Rotate270Item1.Checked := FaxViewer.Rotation = vr270;
end;

procedure TFaxJobDesigner.Nextpage1Click(Sender: TObject);
begin
  FaxViewer.NextPage;
  NextPage1.Enabled := FaxViewer.NumPages > FaxViewer.ActivePage;
  PrevPage1.Enabled := FaxViewer.ActivePage > 1;
  lblPages.Caption := 'Page ' + IntToStr(FaxViewer.ActivePage) + ' of ' +
    IntToStr(FaxViewer.NumPages);
end;

procedure TFaxJobDesigner.Prevpage1Click(Sender: TObject);
begin
  FaxViewer.PrevPage;
  NextPage1.Enabled := FaxViewer.NumPages > FaxViewer.ActivePage;
  PrevPage1.Enabled := FaxViewer.ActivePage > 1;
  lblPages.Caption := 'Page ' + IntToStr(FaxViewer.ActivePage) + ' of ' +
    IntToStr(FaxViewer.NumPages);
end;

procedure TFaxJobDesigner.mnuSaveClick(Sender: TObject);
begin
  if JobFileName = '' then begin
    SaveDialog1.Title := 'Save as';
    SaveDialog1.Filter := 'Fax job files (*.apj)|*.apj|All files (*.*)|*.*';
    if SaveDialog1.Execute then
      JobFileName := SaveDialog1.FileName
    else
      Exit;
  end;
  Memo1.Lines.SaveToFile(edtCoverFile.Text);
  JobInfo.PhoneNumber := edtPhone.Text;
  JobInfo.HeaderLine := edtHeader.Text;
  JobInfo.HeaderRecipient := edtRecipient.Text;
  FaxJobHandler.MakeJob(edtFaxFile.Text, edtCoverFile.Text, edtJobName.Text,
    edtSender.Text, JobFileName, JobInfo);
  IsDirty := False;
end;

procedure TFaxJobDesigner.mnuSaveAsClick(Sender: TObject);
begin
  SaveDialog1.Title := 'Save as';
  SaveDialog1.Filter := 'Fax job files (*.apj)|*.apj|All files (*.*)|*.*';
  SaveDialog1.FileName := JobFileName;
  if SaveDialog1.Execute then begin
    JobFileName := SaveDialog1.FileName;
    mnuSaveClick(Sender);
  end;
end;

procedure TFaxJobDesigner.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  MR: TModalResult;
begin
  if IsDirty then begin
    MR := MessageDlg('Save changes?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);
    if MR = mrYes then
      mnuSave.Click;
    if MR = mrCancel then
      CanClose := False;
  end;
end;

procedure TFaxJobDesigner.FormDestroy(Sender: TObject);
begin
  FaxJobHandler.Free;
end;

procedure TFaxJobDesigner.mnuExitClick(Sender: TObject);
begin
  Close;
end;

end.
