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
{*                   ADFIDLG.PAS 4.06                    *}
{*********************************************************}
{* TApdFaxJobInfo dialog                                 *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdFIDlg;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  OOMIsc,
  Buttons,
  Mask;

type
  TApdFaxJobInfoDialog = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblFileName: TLabel;
    lblDateSubmitted: TLabel;
    lblStatus: TLabel;
    lblSender: TLabel;
    lblNumJobs: TLabel;
    lblNextJob: TLabel;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    lblDateNextSend: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    lblJobStatus: TLabel;
    lblAttemptNum: TLabel;
    lblLastResult: TLabel;
    edtPhoneNum: TEdit;
    edtHeaderLine: TEdit;
    edtHeaderRecipient: TEdit;
    edtHeaderTitle: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    btnPrev: TSpeedButton;
    btnNext: TSpeedButton;
    Label14: TLabel;
    lblJobNumber: TLabel;
    btnReset: TButton;
    Label8: TLabel;
    lblDateSample: TLabel;
    lblTimeSample: TLabel;
    edtSchedDate: TEdit;
    edtSchedTime: TEdit;
    Label17: TLabel;
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure EditBoxChange(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    IsDirty: Boolean;
    JobHeader: TFaxJobHeaderRec;
    JobStream: TFileStream;
    JobInfoStream: TMemoryStream;
    CurrentJobNum: Integer;
    procedure SetDirty(NewDirty : Boolean);
  public
    { Public declarations }
    procedure UpdateJobHeader(JobHeader: TFaxJobHeaderRec);
    procedure UpdateJobInfo(JobNum: Integer);
    function ShowDialog (JobFileName, DlgCaption: ShortString): TModalResult;
  end;

implementation

{$R *.DFM}

uses
  UITypes, AnsiStrings, AdFaxSrv, AdExcept;

{ TAdFIDlgForm }

function TApdFaxJobInfoDialog.ShowDialog(JobFileName, DlgCaption: ShortString): TModalResult;
begin
  Caption := string(DlgCaption);
  SetDirty(False);
  lblFileName.Caption := string(JobFileName);
  if not(FileExists(string(JobFileName))) then begin
    Result := mrAbort;
    Exit;
  end;
  lblDateSample.Caption := '( ' + LowerCase(FormatSettings.ShortDateFormat) + ' )';
  lblTimeSample.Caption := '( ' + FormatSettings.ShortTimeFormat + ' )';
  JobInfoStream := nil;
  try
    JobInfoStream := TMemoryStream.Create;
    try
      JobStream := nil;
      try
        JobStream := TFileStream.Create(string(JobFileName),
          fmOpenRead or fmShareDenyNone);
        lblDateSubmitted.Caption := DateTimeToStr(FileDateToDateTime(
        FileGetDate(JobStream.Handle)));

        { read the job header }
        JobStream.ReadBuffer(JobHeader, SizeOf(JobHeader));
        { read the recipient headers }
        JobInfoStream.CopyFrom(JobStream, SizeOf(TFaxRecipientRec) *
          (JobHeader.NumJobs + 1));
      finally
        { make sure we free the job stream }
        JobStream.Free;
      end;
    except
      { the file could not be opened, return mrAbort and exit }
      Result := mrAbort;
      Exit;
    end;

    btnNext.Enabled := CurrentJobNum < JobHeader.NumJobs-1;
    UpdateJobHeader(JobHeader);
    UpdateJobInfo(CurrentJobNum);
    Result := ShowModal;

    if ModalResult = mrOK then begin
      try
        try
          JobStream := TFileStream.Create(string(JobFileName),
            fmOpenWrite or fmShareDenyWrite);
          JobStream.Position := 0;                                         
          { write the job header }
          JobStream.Write(JobHeader, SizeOf(TFaxJobHeaderRec));            
          {JobStream.Seek(SizeOf(JobHeader), soFromBeginning);}            
          JobInfoStream.Seek(0, soFromBeginning);
          { write the recipient headers }
          JobStream.CopyFrom(JobInfoStream, SizeOf(TFaxRecipientRec) * (JobHeader.NumJobs + 1));
        finally
          JobStream.Free;
        end;
      except
        { an exception was raised, return mrAbort to indicate that and exit }
        Result := mrAbort;
      end;
    end;
  finally
    JobInfoStream.Free;
  end;
end;

procedure TApdFaxJobInfoDialog.UpdateJobHeader(JobHeader: TFaxJobHeaderRec);
begin
  case JobHeader.Status of
    stNone : lblStatus.Caption := 'No jobs have been handled';
    stPartial: lblStatus.Caption := 'Some jobs have been handled';
    stComplete: lblStatus.Caption := 'All jobs have been handled';
  end;

  lblSender.Caption := string(JobHeader.Sender);
  lblNumJobs.Caption := IntToStr(JobHeader.NumJobs);
  lblNextJob.Caption := IntToStr(JobHeader.NextJob);
  lblDateNextSend.Caption := DateTimeToStr(JobHeader.SchedDT);
end;

procedure TApdFaxJobInfoDialog.UpdateJobInfo(JobNum: Integer);
var
  JobInfo: TFaxRecipientRec;
begin
  lblJobNumber.Caption := IntToStr(JobNum);
  JobInfoStream.Position := JobNum * SizeOf(TFaxRecipientRec);
  JobInfoStream.ReadBuffer(JobInfo, SizeOf(TFaxRecipientRec));
  case JobInfo.Status of
    stNone: lblJobStatus.Caption := 'This job has not been handled';
    stPartial: lblJobStatus.Caption := 'This job is being handled';
    stComplete: lblJobStatus.Caption := 'This job has been handled';
  end;

  edtSchedDate.Text := DateToStr(JobInfo.SchedDT);
  edtSchedTime.Text := TimeToStr(JobInfo.SchedDT);
  lblAttemptNum.Caption := IntToStr(JobInfo.AttemptNum);
  lblLastResult.Caption := ErrorMsg(JobInfo.LastResult);
  edtPhoneNum.Text := string(JobInfo.PhoneNumber);
  edtHeaderLine.Text := string(JobInfo.HeaderLine);
  edtHeaderRecipient.Text := string(JobInfo.HeaderRecipient);
  edtHeaderTitle.Text := string(JobInfo.HeaderTitle);
  SetDirty(False);
end;

procedure TApdFaxJobInfoDialog.btnPrevClick(Sender: TObject);
begin
  if IsDirty then begin
    if MessageDlg('The data has changed.  Apply the changes?', mtWarning, [mbYes, mbNo], 0) = mrYes then
      btnApply.Click;
  end;
  dec(CurrentJobNum);
  UpdateJobInfo(CurrentJobNum);
  btnPrev.Enabled := CurrentJobNum > 0;
  btnNext.Enabled := CurrentJobNum < JobHeader.NumJobs-1;
end;

procedure TApdFaxJobInfoDialog.btnNextClick(Sender: TObject);
begin
  if IsDirty then begin
    if MessageDlg('The data has changed.  Apply the changes?', mtWarning, [mbYes, mbNo], 0) = mrYes then
      btnApply.Click;
  end;
  inc(CurrentJobNum);
  UpdateJobInfo(CurrentJobNum);
  btnPrev.Enabled := CurrentJobNum > 0;
  btnNext.Enabled := CurrentJobNum < JobHeader.NumJobs -1;
end;

procedure TApdFaxJobInfoDialog.btnApplyClick(Sender: TObject);
var
  JobInfo: TFaxRecipientRec;
begin
  JobInfoStream.Position := CurrentJobNum * SizeOf(TFaxRecipientRec);
  JobInfoStream.ReadBuffer(JobInfo, SizeOf(TFaxRecipientRec));
  case JobInfo.Status of
    stNone: lblJobStatus.Caption := 'This job has not been handled';
    stPartial: lblJobStatus.Caption := 'This job is being handled';
    stComplete: lblStatus.Caption := 'This job has been handled';
  end;

  JobInfo.SchedDT := StrToDate(edtSchedDate.Text) + StrToTime(edtSchedTime.Text);
  JobInfo.PhoneNumber := ShortString(edtPhoneNum.Text);
  JobInfo.HeaderLine := ShortString(edtHeaderLine.Text);
  JobInfo.HeaderRecipient := ShortString(edtHeaderRecipient.Text);
  JobInfo.HeaderTitle := ShortString(edtHeaderTitle.Text);

  JobInfoStream.Position := CurrentJobNum * SizeOf(TFaxRecipientRec);
  JobInfoStream.WriteBuffer(JobInfo, SizeOf(TFaxRecipientRec));
  SetDirty(False);
end;

procedure TApdFaxJobInfoDialog.EditBoxChange(Sender: TObject);
begin
  SetDirty(True);
end;                    

procedure TApdFaxJobInfoDialog.btnResetClick(Sender: TObject);
var
  JobInfo,
  TempInfo : TFaxRecipientRec;                                         
  I : Integer;                                                         
  JobStatus : Byte;                                                    
begin
  JobInfoStream.Position := CurrentJobNum * SizeOf(TFaxRecipientRec);
  JobInfoStream.ReadBuffer(JobInfo, SizeOf(TFaxRecipientRec));
  JobInfo.Status := 0;
  JobInfo.AttemptNum := 0;
  JobInfo.LastResult := 0;
  JobInfoStream.Position := CurrentJobNum * SizeOf(TFaxRecipientRec);
  JobInfoStream.WriteBuffer(JobInfo, SizeOf(TFaxRecipientRec));
  UpdateJobInfo(CurrentJobNum);

  { update JobHeader.Status }                                          
  JobStatus := stNone;                                                 
  JobInfoStream.Position := SizeOf(TFaxJobHeaderRec);                  
  for I := 1 to JobHeader.NumJobs do begin                             
    JobInfoStream.ReadBuffer(TempInfo, SizeOf(TFaxRecipientRec));      
    JobStatus := JobStatus + TempInfo.Status;                          
  end;                                                                 
  if JobStatus = stNone then                                           
    JobHeader.Status := stNone                                         
  else if JobStatus = stComplete * JobHeader.NumJobs then              
    JobHeader.Status := stComplete                                     
  else                                                                 
    JobHeader.Status := stPartial;                                     
  UpdateJobHeader(JobHeader);                                          
  SetDirty(True);                                                      
end;

procedure TApdFaxJobInfoDialog.SetDirty(NewDirty : Boolean);
begin
  IsDirty := NewDirty;
  btnApply.Enabled := IsDirty;
end;

procedure TApdFaxJobInfoDialog.btnOKClick(Sender: TObject);
begin
  if IsDirty then
    btnApplyClick(Sender);
end;

procedure TApdFaxJobInfoDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssAlt in Shift then
    case Key of
      VK_LEFT   : if btnPrev.Enabled then
        btnPrev.Click;
      VK_RIGHT  : if btnNext.Enabled then
        btnNext.Click;
    end;
end;

end.
