object ComPortOptions: TComPortOptions
  Left = 231
  Top = 165
  BorderStyle = bsDialog
  Caption = 'Com Port Options'
  ClientHeight = 234
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object FlowControlBox: TGroupBox
    Left = 344
    Top = 8
    Width = 161
    Height = 161
    Caption = '&Flow control:'
    TabOrder = 5
    object Label1: TLabel
      Left = 14
      Top = 103
      Width = 46
      Height = 13
      Caption = 'Xon char:'
    end
    object Label2: TLabel
      Left = 14
      Top = 131
      Width = 46
      Height = 13
      Caption = 'Xoff char:'
    end
    object DTRRTS: TCheckBox
      Left = 12
      Top = 21
      Width = 97
      Height = 17
      Caption = 'DTR/DSR'
      TabOrder = 0
    end
    object RTSCTS: TCheckBox
      Left = 12
      Top = 40
      Width = 97
      Height = 17
      Caption = 'RTS/CTS'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object SoftwareXmit: TCheckBox
      Left = 12
      Top = 59
      Width = 138
      Height = 17
      Caption = 'Software transmit'
      TabOrder = 2
    end
    object SoftwareRcv: TCheckBox
      Left = 12
      Top = 78
      Width = 133
      Height = 17
      Caption = 'Software receive'
      TabOrder = 3
    end
    object Edit1: TEdit
      Left = 86
      Top = 99
      Width = 27
      Height = 21
      TabOrder = 4
      Text = '17'
    end
    object Edit2: TEdit
      Left = 86
      Top = 127
      Width = 27
      Height = 21
      TabOrder = 5
      Text = '19'
    end
  end
  object Bauds: TRadioGroup
    Left = 8
    Top = 112
    Width = 169
    Height = 113
    Caption = '&Baud rates:'
    Columns = 2
    Items.Strings = (
      '300'
      '600'
      '1200'
      '2400'
      '4800'
      '9600'
      '19200'
      '38400'
      '57600'
      '115200')
    TabOrder = 1
  end
  object Paritys: TRadioGroup
    Left = 188
    Top = 8
    Width = 145
    Height = 89
    Caption = '&Parity:'
    Columns = 2
    Items.Strings = (
      'None'
      'Odd'
      'Even'
      'Mark'
      'Space')
    TabOrder = 2
  end
  object Databits: TRadioGroup
    Left = 188
    Top = 112
    Width = 145
    Height = 57
    Caption = '&Data bits:'
    Columns = 2
    Items.Strings = (
      '8'
      '7'
      '6'
      '5')
    TabOrder = 3
  end
  object Stopbits: TRadioGroup
    Left = 188
    Top = 176
    Width = 145
    Height = 49
    Caption = '&Stop bits:'
    Columns = 2
    Items.Strings = (
      '1'
      '2')
    TabOrder = 4
  end
  object Comports: TGroupBox
    Left = 8
    Top = 8
    Width = 169
    Height = 93
    Caption = 'ComPorts'
    TabOrder = 0
    object PortComboBox: TComboBox
      Left = 8
      Top = 20
      Width = 153
      Height = 21
      TabOrder = 0
      OnChange = PortComboBoxChange
    end
  end
  object OK: TButton
    Left = 345
    Top = 190
    Width = 75
    Height = 27
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object Cancel: TButton
    Left = 428
    Top = 190
    Width = 75
    Height = 27
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 7
  end
end
