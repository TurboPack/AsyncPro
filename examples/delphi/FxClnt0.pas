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
{*                   FXCLNT0.PAS 4.06                    *}
{*********************************************************}

{**********************Description************************}
{
  FaxClient is an example project demonstrating the TApdFaxClient component.
  The properties of the TApdFaxClient are controlled through the edit controls
  on the form. All properties relate to the TApdFaxClient.Recipient property
  fields. You can use this project to create and view fax jobs, or use it with
  the FaxSrvr example to submit jobs for sending.

  The TApdFaxDriverInterface component will intercept print jobs, display this
  dialog, and let you create a fax job out of it.

  Cover File: The path/name of a text cover file
  Fax file: The name of the APF that will be sent
  Header Line: The line of text at the top of the fax
  Header Recipient: The recipient of the fax (used for replaceable tags)
  Header Title: The title of the fax document
  Job name: The friendly title of the fax job
  Phone number: The phone number of the recipient's fax machine
  Sender: The name of the sender (you)
  Job file name: The name of the fax job file you want to create. To automatically
    submit it to an ApdFaxServerManager for queing, enter the path that the
    ApdFaxServerManager is watching (MonitorDir).  You could also copy the file
    manually or use the ApdFaxClient.CopyToServer method.

  The 'Make job' button creates a new fax job containing the information from the
    edit controls.
  The 'Add recipient' button will add the information from the edit controls to an
    existing job file to send it to multiple recipients
  The 'Job Info Dialog' button will display the recipient information contained
    in the specified fax job file
  The 'Job Designer' button will display a Job Designer form, which will show
    the APF in an ApdFaxViewer, allow editing of the cover file, and editing of
    other recipient fields.  You can also design a new job.
  The 'Clear' button will set all edit control text to an empty string
  The 'Exit' button will exit this project

}

{*********************************************************}

unit FxClnt0;

interface

uses
  {$IFDEF Ver80}
  WinTypes, WinProcs,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OoMisc, AdFaxSrv, AdFaxCtl, FxJobDlg;

type
  TfrmFaxClient0 = class(TForm)
    ApdFaxClient1: TApdFaxClient;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edtCoverFileName: TEdit;
    edtFaxFileName: TEdit;
    edtHeaderLine: TEdit;
    edtHeaderRecipient: TEdit;
    edtHeaderTitle: TEdit;
    edtJobName: TEdit;
    edtPhoneNumber: TEdit;
    edtSchedDate: TEdit;
    edtSender: TEdit;
    edtJobFileName: TEdit;
    ApdFaxDriverInterface1: TApdFaxDriverInterface;
    btnMakeJob: TButton;
    btnClear: TButton;
    btnJobInfoDialog: TButton;
    btnAddRecipient: TButton;
    btnJobDesigner: TButton;
    btnExit: TButton;
    Label11: TLabel;
    edtSchedTime: TEdit;
    lblDateSample: TLabel;
    lblTimeSample: TLabel;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ApdFaxDriverInterface1DocEnd(Sender: TObject);
    procedure btnMakeJobClick(Sender: TObject);
    procedure btnAddRecipientClick(Sender: TObject);
    procedure btnJobInfoDialogClick(Sender: TObject);
    procedure btnJobDesignerClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure BrowseBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ClearControls;
  end;

var
  frmFaxClient0: TfrmFaxClient0;

implementation

{$R *.DFM}

procedure TfrmFaxClient0.ClearControls;
begin
  edtCoverFileName.Text := '';
  edtFaxFileName.Text := '';
  edtHeaderLine.Text := '';
  edtHeaderRecipient.Text := '';
  edtHeaderTitle.Text := '';
  edtJobName.Text := '';
  edtPhoneNumber.Text := '';
  edtSchedDate.Text := DateToStr(Date);
  edtSchedTime.Text := TimeToStr(Time);
  edtSender.Text := '';
  edtJobFileName.Text := '';
end;

procedure TfrmFaxClient0.FormCreate(Sender: TObject);
begin
  ClearControls;
  lblDateSample.Caption := '( ' + LowerCase(ShortDateFormat) + ' )';
  lblTimeSample.Caption := '( ' + ShortTimeFormat + ' )';
  if ParamCount > 0 then begin
    edtJobFileName.Text := ParamStr(1);
  end;
end;

procedure TfrmFaxClient0.ApdFaxDriverInterface1DocEnd(Sender: TObject);
begin
  edtFaxFileName.Text := ApdFaxDriverInterface1.FileName;
  edtHeaderTitle.Text := ApdFaxDriverInterface1.DocName;
  edtJobName.Text := ApdFaxDriverInterface1.DocName;
  edtFaxFileName.Enabled := False;
  edtSchedDate.Text := DateToStr(Date);
  edtSchedTime.Text := TimeToStr(Time);
  Show;
  Application.Restore;
end;

procedure TfrmFaxClient0.btnMakeJobClick(Sender: TObject);
begin
  ApdFaxClient1.CoverFileName := edtCoverFileName.Text;
  ApdFaxClient1.FaxFileName := edtFaxFileName.Text;
  ApdFaxClient1.HeaderLine := edtHeaderLine.Text;
  ApdFaxClient1.HeaderRecipient := edtHeaderRecipient.Text;
  ApdFaxClient1.HeaderTitle := edtHeaderTitle.Text;
  ApdFaxClient1.JobName := edtJobName.Text;
  ApdFaxClient1.PhoneNumber := edtPhoneNumber.Text;
  ApdFaxClient1.ScheduleDateTime := StrToDate(edtSchedDate.Text) + StrToTime(edtSchedTime.Text);
  ApdFaxClient1.Sender := edtSender.Text;
  ApdFaxClient1.JobFileName := edtJobFileName.Text;
  ApdFaxClient1.MakeFaxJob;
end;

procedure TfrmFaxClient0.btnAddRecipientClick(Sender: TObject);
begin
  ApdFaxClient1.CoverFileName := edtCoverFileName.Text;
  ApdFaxClient1.FaxFileName := edtFaxFileName.Text;
  ApdFaxClient1.HeaderLine := edtHeaderLine.Text;
  ApdFaxClient1.HeaderRecipient := edtHeaderRecipient.Text;
  ApdFaxClient1.HeaderTitle := edtHeaderTitle.Text;
  ApdFaxClient1.JobName := edtJobName.Text;
  ApdFaxClient1.PhoneNumber := edtPhoneNumber.Text;
  ApdFaxClient1.ScheduleDateTime := StrToDate(edtSchedDate.Text) + StrToTime(edtSchedTime.Text);
  ApdFaxClient1.Sender := edtSender.Text;
  ApdFaxClient1.JobFileName := edtJobFileName.Text;
  ApdFaxClient1.AddRecipient(edtJobFileName.Text, ApdFaxClient1.Recipient);
end;

procedure TfrmFaxClient0.btnJobInfoDialogClick(Sender: TObject);
begin
  if edtJobName.Text <> '' then
    ApdFaxClient1.ShowFaxJobInfoDialog(edtJobFileName.Text, edtJobName.Text)
  else
    ApdFaxClient1.ShowFaxJobInfoDialog(edtJobFileName.Text, edtJobFileName.Text)  
end;

procedure TfrmFaxClient0.btnJobDesignerClick(Sender: TObject);
begin
  with TFaxJobDesigner.Create(Self) do begin
    try
      ShowJobModal(edtJobFileName.Text);
    finally
      Free;
    end;
  end;
end;

procedure TfrmFaxClient0.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFaxClient0.btnClearClick(Sender: TObject);
begin
  ClearControls;
end;

procedure TfrmFaxClient0.BrowseBtnClick(Sender: TObject);
begin
  case TButton(Sender).Tag of
    1 : begin  { browse for cover file }
      OpenDialog1.Filter := 'Text files (*.txt)|*.txt|All files (*.*)|*.*';
      OpenDialog1.Title := 'Select cover file';
    end;
    2 : begin  { browse for APF }
      OpenDialog1.Filter := 'Fax files (*.apf)|*.apf|All files (*.*)|*.*';
      OpenDialog1.Title := 'Select fax file';
    end;
    3 : begin  { browse for job file }
      OpenDialog1.Filter := 'Fax job files (*.apj)|*.apj|All files (*.*)|*.*';
      OpenDialog1.Title := 'Select job file';
    end;
  end;
  if OpenDialog1.Execute then
    case TButton(Sender).Tag of
      1 : edtCoverFileName.Text := OpenDialog1.FileName;
      2 : edtFaxFileName.Text := OpenDialog1.FileName;
      3 : edtJobFileName.Text := OpenDialog1.FileName;
    end;
end;

end.
