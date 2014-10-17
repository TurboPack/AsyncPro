object frmAddTrigger: TfrmAddTrigger
  Left = 365
  Top = 226
  ActiveControl = edtTriggerString
  BorderStyle = bsDialog
  Caption = 'Add Data Trigger'
  ClientHeight = 175
  ClientWidth = 413
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 248
    Top = 144
    Width = 75
    Height = 25
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 334
    Top = 144
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 401
    Height = 129
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 28
      Width = 63
      Height = 13
      Caption = 'Trigger &String'
    end
    object Label2: TLabel
      Left = 16
      Top = 60
      Width = 57
      Height = 13
      Caption = '&Packet Size'
    end
    object Label3: TLabel
      Left = 16
      Top = 92
      Width = 60
      Height = 13
      Caption = '&Timeout (ms)'
    end
    object edtTriggerString: TEdit
      Left = 88
      Top = 24
      Width = 297
      Height = 21
      TabOrder = 0
    end
    object edtPacketSize: TMaskEdit
      Left = 88
      Top = 56
      Width = 57
      Height = 21
      EditMask = '9999;0; '
      MaxLength = 4
      TabOrder = 1
    end
    object edtTimeout: TMaskEdit
      Left = 88
      Top = 88
      Width = 57
      Height = 21
      EditMask = '999999;0; '
      MaxLength = 6
      TabOrder = 2
    end
    object chkIncludeStrings: TCheckBox
      Left = 272
      Top = 58
      Width = 97
      Height = 17
      Alignment = taLeftJustify
      Caption = '&Include Strings'
      TabOrder = 3
    end
    object chkIgnoreCase: TCheckBox
      Left = 272
      Top = 90
      Width = 97
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Ignore &Case'
      TabOrder = 4
    end
    object chkEnabled: TCheckBox
      Left = 168
      Top = 58
      Width = 73
      Height = 17
      Alignment = taLeftJustify
      Caption = '&Enabled'
      TabOrder = 5
    end
  end
end
