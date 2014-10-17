unit ExDataT2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask;

type
  TfrmAddTrigger = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtTriggerString: TEdit;
    Label2: TLabel;
    edtPacketSize: TMaskEdit;
    Label3: TLabel;
    edtTimeout: TMaskEdit;
    chkIncludeStrings: TCheckBox;
    chkIgnoreCase: TCheckBox;
    chkEnabled: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  public
    TriggerString  : string;
    PacketSize     : Integer;
    Timeout        : Integer;
    IncludeStrings : Boolean;
    IgnoreCase     : Boolean;
    TriggerEnabled : Boolean;
  end;

var
  frmAddTrigger: TfrmAddTrigger;

implementation

{$R *.DFM}

procedure TfrmAddTrigger.FormActivate(Sender: TObject);
begin
  edtTriggerString.Text := '';
  edtPacketSize.Text := '0';
  edtTimeout.Text := '0';
  chkIncludeStrings.Checked := True;
  chkIgnoreCase.Checked := True;
  chkEnabled.Checked := True;
end;

procedure TfrmAddTrigger.btnOkClick(Sender: TObject);
begin
  TriggerString := edtTriggerString.Text;
  PacketSize := StrToIntDef(edtPacketSize.Text, 0);
  Timeout := StrToIntDef(edtTimeout.Text, 0);
  IncludeStrings := chkIncludeStrings.Checked;
  IgnoreCase := chkIgnoreCase.Checked;
  TriggerEnabled := chkEnabled.Checked;
  ModalResult := mrOk;
end;

procedure TfrmAddTrigger.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
