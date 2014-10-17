object ProtocolOptions: TProtocolOptions
  Left = 331
  Top = 148
  BorderStyle = bsDialog
  Caption = 'Protocol Options'
  ClientHeight = 376
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GeneralOptions: TGroupBox
    Left = 8
    Top = 8
    Width = 217
    Height = 146
    Caption = '&General options'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 115
      Width = 68
      Height = 13
      Caption = 'Name collision'
    end
    object gWriteFail: TComboBox
      Left = 110
      Top = 112
      Width = 99
      Height = 21
      Style = csDropDownList
      DropDownCount = 4
      TabOrder = 4
      Items.Strings = (
        'none'
        'reject '
        'rename '
        'overwrite ')
    end
    object gHonorDirectory: TCheckBox
      Left = 7
      Top = 20
      Width = 193
      Height = 17
      Caption = 'Honor incoming directory'
      TabOrder = 1
    end
    object gIncludeDirectory: TCheckBox
      Left = 7
      Top = 42
      Width = 193
      Height = 17
      Caption = 'Include outgoing directory'
      TabOrder = 0
    end
    object gRTSLowForWrite: TCheckBox
      Left = 7
      Top = 64
      Width = 201
      Height = 17
      Caption = ' Set RTS low for disk writes'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object gAbortNoCarrier: TCheckBox
      Left = 7
      Top = 86
      Width = 193
      Height = 17
      Caption = 'Abort if carrier (DCD) lost'
      TabOrder = 3
    end
  end
  object ZmodemOptions: TGroupBox
    Left = 8
    Top = 168
    Width = 217
    Height = 169
    Caption = '&Zmodem options'
    TabOrder = 1
    object Label2: TLabel
      Left = 9
      Top = 114
      Width = 77
      Height = 13
      Caption = 'File managment:'
    end
    object zOptionOverride: TCheckBox
      Left = 7
      Top = 24
      Width = 153
      Height = 17
      Caption = 'File options override'
      TabOrder = 0
    end
    object zSkipNoFile: TCheckBox
      Left = 7
      Top = 46
      Width = 153
      Height = 17
      Caption = 'Skip new files'
      TabOrder = 1
    end
    object zRecover: TCheckBox
      Left = 7
      Top = 68
      Width = 153
      Height = 17
      Caption = 'Crash recovery'
      TabOrder = 2
    end
    object z8K: TCheckBox
      Left = 7
      Top = 90
      Width = 89
      Height = 17
      Caption = '8K mode'
      TabOrder = 3
    end
    object zFileManagment: TComboBox
      Left = 10
      Top = 131
      Width = 160
      Height = 21
      Style = csDropDownList
      TabOrder = 4
      Items.Strings = (
        'none'
        'newer or longer'
        'CRC different'
        'append'
        'overwrite'
        'newer'
        'different'
        'reject')
    end
  end
  object OK: TButton
    Left = 248
    Top = 344
    Width = 89
    Height = 27
    Caption = 'OK'
    Default = True
    TabOrder = 4
    OnClick = OKClick
  end
  object Cancel: TButton
    Left = 344
    Top = 344
    Width = 89
    Height = 27
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = CancelClick
  end
  object KermitOptions: TGroupBox
    Left = 240
    Top = 8
    Width = 193
    Height = 113
    Caption = '&Kermit  options'
    TabOrder = 2
    object Label3: TLabel
      Left = 8
      Top = 25
      Width = 62
      Height = 13
      Caption = 'Block length:'
    end
    object Label5: TLabel
      Left = 8
      Top = 52
      Width = 47
      Height = 13
      Caption = 'Windows:'
    end
    object Label6: TLabel
      Left = 8
      Top = 79
      Width = 90
      Height = 13
      Caption = 'Timeout (seconds):'
    end
    object kBlockLen: TEdit
      Left = 144
      Top = 20
      Width = 41
      Height = 21
      MaxLength = 4
      TabOrder = 0
    end
    object kWindows: TEdit
      Left = 144
      Top = 48
      Width = 41
      Height = 21
      MaxLength = 2
      TabOrder = 1
    end
    object kTimeout: TEdit
      Left = 144
      Top = 76
      Width = 41
      Height = 21
      MaxLength = 3
      TabOrder = 2
    end
  end
  object AsciiOptions: TGroupBox
    Left = 240
    Top = 136
    Width = 193
    Height = 201
    Caption = '&Ascii options'
    TabOrder = 3
    object Label7: TLabel
      Left = 8
      Top = 20
      Width = 73
      Height = 13
      Caption = 'Inter-char delay'
    end
    object Label8: TLabel
      Left = 8
      Top = 47
      Width = 68
      Height = 13
      Caption = 'Inter-line delay'
    end
    object Label9: TLabel
      Left = 8
      Top = 100
      Width = 69
      Height = 13
      Caption = 'CR translation:'
    end
    object Label10: TLabel
      Left = 8
      Top = 146
      Width = 66
      Height = 13
      Caption = 'LF translation:'
    end
    object Label11: TLabel
      Left = 8
      Top = 75
      Width = 61
      Height = 13
      Caption = 'EOF timeout:'
    end
    object sInterCharDelay: TEdit
      Left = 144
      Top = 15
      Width = 41
      Height = 21
      TabOrder = 0
    end
    object sInterLineDelay: TEdit
      Left = 144
      Top = 43
      Width = 41
      Height = 21
      TabOrder = 1
    end
    object sCRTrans: TComboBox
      Left = 8
      Top = 116
      Width = 153
      Height = 21
      Style = csDropDownList
      TabOrder = 3
      Items.Strings = (
        'none'
        'strip'
        'add CR before LF'
        'add LF after CR')
    end
    object sLFTrans: TComboBox
      Left = 8
      Top = 163
      Width = 153
      Height = 21
      Style = csDropDownList
      TabOrder = 4
      Items.Strings = (
        'none'
        'strip'
        'add CR before LF'
        'add LF after CR')
    end
    object sEOFTimeout: TEdit
      Left = 144
      Top = 71
      Width = 41
      Height = 21
      TabOrder = 2
    end
  end
end
