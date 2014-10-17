object ApxZModemOptions: TApxZModemOptions
  Left = 500
  Top = 93
  ActiveControl = btnOk
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'X/YModem Options'
  ClientHeight = 198
  ClientWidth = 346
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 184
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 262
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 329
    Height = 153
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 17
      Width = 115
      Height = 13
      Caption = '&File management option:'
    end
    object Label2: TLabel
      Left = 8
      Top = 122
      Width = 53
      Height = 13
      Caption = 'Finish &retry:'
    end
    object chkZModem8K: TCheckBox
      Left = 8
      Top = 95
      Width = 97
      Height = 17
      Caption = 'ZModem&8K'
      TabOrder = 0
    end
    object cbxZModemFileOptions: TComboBox
      Left = 134
      Top = 13
      Width = 186
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'No options'
        'Transfer if new, newer or longer'
        'Transfer if newer'
        'Transfer if new, append if already exists '
        'Transfer regardless'
        'Transfer if new or newer'
        'Transfer if new or different date or length'
        'Transfer only if new')
    end
    object edtZModemFinishRetry: TEdit
      Left = 73
      Top = 118
      Width = 49
      Height = 21
      TabOrder = 2
    end
    object chkZModemOptionOverride: TCheckBox
      Left = 8
      Top = 41
      Width = 145
      Height = 18
      Caption = '&Override sender'#39's options'
      TabOrder = 3
    end
    object chkZModemRecover: TCheckBox
      Left = 8
      Top = 77
      Width = 161
      Height = 17
      Caption = '&ZModem recover'
      TabOrder = 4
    end
    object chkZModemSkipNoFile: TCheckBox
      Left = 8
      Top = 59
      Width = 145
      Height = 17
      Caption = '&Skip if file already exists'
      TabOrder = 5
    end
  end
end
