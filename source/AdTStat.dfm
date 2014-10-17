object ApdStandardTapiDisplay: TApdStandardTapiDisplay
  Left = 294
  Top = 218
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Call Progress'
  ClientHeight = 305
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object dpPanel1: TPanel
    Left = 8
    Top = 8
    Width = 409
    Height = 81
    TabOrder = 0
    object dpLabel1: TLabel
      Left = 8
      Top = 8
      Width = 52
      Height = 13
      Caption = 'Answering:'
      ShowAccelChar = False
    end
    object dpLabel2: TLabel
      Left = 8
      Top = 32
      Width = 30
      Height = 13
      Caption = 'Using:'
      ShowAccelChar = False
    end
    object dpLabel3: TLabel
      Left = 8
      Top = 56
      Width = 39
      Height = 13
      Caption = 'Attempt:'
    end
    object dpLabel4: TLabel
      Left = 80
      Top = 56
      Width = 9
      Height = 13
      Caption = 'of'
    end
    object dpDialing: TLabel
      Left = 80
      Top = 8
      Width = 44
      Height = 13
      Caption = 'dpDialing'
      ShowAccelChar = False
    end
    object dpUsing: TLabel
      Left = 64
      Top = 32
      Width = 39
      Height = 13
      Caption = 'dpUsing'
      ShowAccelChar = False
    end
    object dpAttempt: TLabel
      Left = 64
      Top = 56
      Width = 12
      Height = 13
      Caption = '01'
      ShowAccelChar = False
    end
    object dpTotalAttempts: TLabel
      Left = 96
      Top = 56
      Width = 12
      Height = 13
      Caption = '03'
      ShowAccelChar = False
    end
  end
  object dpCancel: TButton
    Left = 160
    Top = 268
    Width = 89
    Height = 27
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = dpCancelClick
  end
  object stPanel: TPanel
    Left = 8
    Top = 96
    Width = 409
    Height = 161
    TabOrder = 2
    object dpStat1: TLabel
      Left = 8
      Top = 8
      Width = 37
      Height = 13
      Caption = 'dpStat1'
      ShowAccelChar = False
    end
    object dpStat2: TLabel
      Left = 8
      Top = 24
      Width = 37
      Height = 13
      Caption = 'dpStat2'
      ShowAccelChar = False
    end
    object dpStat3: TLabel
      Left = 8
      Top = 40
      Width = 37
      Height = 13
      Caption = 'dpStat3'
      ShowAccelChar = False
    end
    object dpStat4: TLabel
      Left = 8
      Top = 56
      Width = 37
      Height = 13
      Caption = 'dpStat4'
      ShowAccelChar = False
    end
    object dpStat5: TLabel
      Left = 8
      Top = 72
      Width = 37
      Height = 13
      Caption = 'dpStat5'
      ShowAccelChar = False
    end
    object dpStat6: TLabel
      Left = 8
      Top = 88
      Width = 37
      Height = 13
      Caption = 'dpStat6'
      ShowAccelChar = False
    end
    object dpStat7: TLabel
      Left = 8
      Top = 104
      Width = 37
      Height = 13
      Caption = 'dpStat7'
      ShowAccelChar = False
    end
    object dpStat8: TLabel
      Left = 8
      Top = 120
      Width = 37
      Height = 13
      Caption = 'dpStat8'
      ShowAccelChar = False
    end
    object dpStat9: TLabel
      Left = 8
      Top = 136
      Width = 37
      Height = 13
      Caption = 'dpStat9'
      ShowAccelChar = False
    end
  end
end
