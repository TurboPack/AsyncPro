object PacketEditor: TPacketEditor
  Left = 265
  Top = 179
  ClientHeight = 334
  ClientWidth = 406
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 2
    Top = 91
    Width = 401
    Height = 84
    Caption = ' Packet End condition '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 119
      Top = 21
      Width = 112
      Height = 13
      Caption = 'characters are received'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object ChkCharCount: TCheckBox
      Left = 12
      Top = 20
      Width = 49
      Height = 17
      Caption = 'After'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object ChkEndString: TCheckBox
      Left = 12
      Top = 53
      Width = 185
      Height = 17
      Caption = 'When this string is received:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object EdtEndString: TEdit
      Left = 210
      Top = 50
      Width = 120
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object EdtCharCount: TEdit
      Left = 63
      Top = 17
      Width = 45
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 2
    Top = 4
    Width = 401
    Height = 84
    Caption = ' Packet Start condition '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object rbAnyChar: TRadioButton
      Left = 12
      Top = 20
      Width = 217
      Height = 17
      Caption = 'When any character is received'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object rbString: TRadioButton
      Left = 12
      Top = 54
      Width = 177
      Height = 17
      Caption = 'When this string is received:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object EdtStartString: TEdit
      Left = 210
      Top = 52
      Width = 120
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object GroupBox3: TGroupBox
    Left = 2
    Top = 179
    Width = 313
    Height = 149
    Caption = ' Additional properties '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object Label5: TLabel
      Left = 12
      Top = 118
      Width = 41
      Height = 13
      Caption = 'Timeout:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 139
      Top = 118
      Width = 40
      Height = 13
      Caption = '(In ticks)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object ChkIgnoreCase: TCheckBox
      Left = 12
      Top = 67
      Width = 189
      Height = 17
      Caption = 'Ignore case on strings'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object ChkAutoEnable: TCheckBox
      Left = 12
      Top = 43
      Width = 261
      Height = 17
      Caption = 'Packet is automatically re-enabled  (AutoEnable)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object ChkIncludeStrings: TCheckBox
      Left = 12
      Top = 91
      Width = 193
      Height = 17
      Caption = 'Include start/end string(s) in packet'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object ChkEnabled: TCheckBox
      Left = 12
      Top = 20
      Width = 277
      Height = 17
      Caption = 'Packet is initially enabled'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object EdtTimeout: TEdit
      Left = 64
      Top = 114
      Width = 56
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
  end
  object BitBtn1: TBitBtn
    Left = 322
    Top = 186
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    DoubleBuffered = True
    ModalResult = 1
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 3
  end
  object BitBtn2: TBitBtn
    Left = 322
    Top = 217
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    DoubleBuffered = True
    ModalResult = 2
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 4
  end
end
