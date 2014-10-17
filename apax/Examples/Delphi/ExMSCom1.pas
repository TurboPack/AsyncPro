unit ExMSCom1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OleCtrls, Apax1_TLB, Menus, ExtCtrls;

type
  TForm1 = class(TForm)
    GroupBox6: TGroupBox;
    lbxOnComm: TListBox;
    GroupBox7: TGroupBox;
    btnOutput: TButton;
    edtPut: TEdit;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label3: TLabel;
    edtSettings: TEdit;
    chkDTREnable: TCheckBox;
    chkRTSEnable: TCheckBox;
    rgHandshaking: TRadioGroup;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label7: TLabel;
    edtOutBufferSize: TEdit;
    edtSThreshold: TEdit;
    GroupBox5: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    rgInputMode: TRadioGroup;
    edtInputLen: TEdit;
    edtRTThreshold: TEdit;
    edtInBufferSize: TEdit;
    btnSet: TButton;
    Apax1: TApax;
    lbxInputData: TListBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtCommPort: TEdit;
    btnOpen: TButton;
    btnClose: TButton;
    procedure btnOutputClick(Sender: TObject);
    procedure Apax1Comm(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    procedure InputData;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.btnOutputClick(Sender: TObject);
var
  Data : OleVariant;
  i : Integer;
begin
  Data := VarArrayCreate([1, Length(edtPut.Text)], varByte);
  for i := 1 to Length(edtPut.Text) do
    Data[i] := Ord(edtPut.Text[i]);
  Apax1.Output := Data;
end;

procedure TForm1.InputData;
var
  Data : OleVariant;
  S : string;
  i : Integer;
begin
  if (Apax1.InBufferCount > 0) then begin
    Data := Apax1.Input;
    case Apax1.InputMode of
      comInputModeText : lbxInputData.Items.Add(VarToStr(Data));
      comInputModeBinary :
        begin
          S := '';
          for i := VarArrayLowBound(Data, 1) to VarArrayHighBound(Data, 1) do
            S := S + ' $' + IntToHex(Data[i], 2);
          lbxInputData.Items.Add(S);
        end;
    end;
  end;
end;

procedure TForm1.Apax1Comm(Sender: TObject);
begin
  case Apax1.CommEvent of
    comEvSend        : lbxOnComm.Items.Add('comEvSend');
    comEvReceive     : begin
                         lbxOnComm.Items.Add('comEvReceive');
                         InputData;
                       end;
    comEvCTS         : lbxOnComm.Items.Add('comEvCTS');
    comEvDSR         : lbxOnComm.Items.Add('comEvDSR');
    comEvCD          : lbxOnComm.Items.Add('comEvCD');
    comEvRing        : lbxOnComm.Items.Add('comEvRing');
    comEventBreak    : lbxOnComm.Items.Add('comEventBreak');
    comEventCTSTO    : lbxOnComm.Items.Add('comEventCTSTO');
    comEventDSRTO    : lbxOnComm.Items.Add('comEventDSRTO');
    comEventFrame    : lbxOnComm.Items.Add('comEventFrame');
    comEventOverrun  : lbxOnComm.Items.Add('comEventOverrun');
    comEventCDTO     : lbxOnComm.Items.Add('comEventCDTO');
    comEventRxOver   : lbxOnComm.Items.Add('comEventRxOver');
    comEventRxParity : lbxOnComm.Items.Add('comEventRxParity');
    comEventTxFull   : lbxOnComm.Items.Add('comEventTxFull');
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  edtCommPort.Text        := IntToStr(Apax1.CommPort);
  edtSettings.Text        := Apax1.Settings;
  chkDTREnable.Checked    := Apax1.DTREnable;
  chkRTSEnable.Checked    := Apax1.RTSEnable;
  rgHandshaking.ItemIndex := Integer(Apax1.Handshaking);
  edtOutBufferSize.Text   := IntToStr(Apax1.OutBufferSize);
  edtSThreshold.Text      := IntToStr(Apax1.SThreshold);
  rgInputMode.ItemIndex   := Integer(Apax1.InputMode);
  edtInBufferSize.Text    := IntToStr(Apax1.InBufferSize);
  edtRTThreshold.Text     := IntToStr(Apax1.RTThreshold);
end;

procedure TForm1.btnSetClick(Sender: TObject);
begin
  Apax1.Settings := edtSettings.Text;
  Apax1.DTREnable := chkDTREnable.Checked;
  Apax1.RTSEnable := chkRTSEnable.Checked;
  Apax1.Handshaking := HandshakeConstants(rgHandshaking.ItemIndex);
  Apax1.OutBufferSize := StrToIntDef(edtOutBufferSize.Text, 512);
  Apax1.SThreshold := StrToIntDef(edtSThreshold.Text, 0);
  Apax1.InputMode := InputModeConstants(rgInputMode.ItemIndex);
  Apax1.InBufferSize := StrToIntDef(edtInBufferSize.Text, 1024);
  Apax1.RTThreshold := StrToIntDef(edtRTThreshold.Text, 0);
end;

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  Apax1.CommPort := StrToIntDef(edtCommPort.Text, 0);
  Apax1.PortOpen;
  edtCommPort.Text := IntToStr(Apax1.CommPort);
end;

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  Apax1.Close;
end;

end.
