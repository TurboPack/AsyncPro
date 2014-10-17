object StandardDisplay: TStandardDisplay
  Left = 363
  Top = 182
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Protocol Status'
  ClientHeight = 319
  ClientWidth = 468
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object psPanel1: TPanel
    Left = 8
    Top = 8
    Width = 217
    Height = 113
    TabOrder = 0
    object psLabel1: TLabel
      Left = 8
      Top = 8
      Width = 48
      Height = 15
      Caption = 'Protocol:'
    end
    object psLabel2: TLabel
      Left = 8
      Top = 24
      Width = 68
      Height = 15
      Caption = 'Block check:'
    end
    object psLabel3: TLabel
      Left = 8
      Top = 40
      Width = 58
      Height = 15
      Caption = 'File name:'
    end
    object psLabel4: TLabel
      Left = 8
      Top = 57
      Width = 48
      Height = 15
      Caption = 'File size:'
    end
    object psLabel5: TLabel
      Left = 8
      Top = 73
      Width = 58
      Height = 15
      Caption = 'Block size:'
    end
    object psLabel6: TLabel
      Left = 8
      Top = 89
      Width = 69
      Height = 15
      Caption = 'Total Blocks:'
    end
    object psProtocol: TLabel
      Left = 148
      Top = 8
      Width = 61
      Height = 15
      Alignment = taRightJustify
      Caption = 'NoProtocol'
      ShowAccelChar = False
    end
    object psBlockCheck: TLabel
      Left = 128
      Top = 24
      Width = 81
      Height = 15
      Alignment = taRightJustify
      Caption = 'NoBlockCheck'
      ShowAccelChar = False
    end
    object psFileName: TLabel
      Left = 159
      Top = 40
      Width = 50
      Height = 15
      Alignment = taRightJustify
      Caption = 'NoName'
      ShowAccelChar = False
    end
    object psFileSize: TLabel
      Left = 116
      Top = 57
      Width = 93
      Height = 15
      Alignment = taRightJustify
      Caption = '999,999,999,999'
      ShowAccelChar = False
    end
    object psBlockSize: TLabel
      Left = 181
      Top = 73
      Width = 28
      Height = 15
      Alignment = taRightJustify
      Caption = '1024'
      ShowAccelChar = False
    end
    object psTotalBlocks: TLabel
      Left = 116
      Top = 89
      Width = 93
      Height = 15
      Alignment = taRightJustify
      Caption = '999,999,999,999'
      ShowAccelChar = False
    end
  end
  object psPanel2: TPanel
    Left = 240
    Top = 8
    Width = 217
    Height = 113
    TabOrder = 1
    object psBlocksRemaining: TLabel
      Left = 115
      Top = 56
      Width = 93
      Height = 15
      Alignment = taRightJustify
      Caption = '999,999,999,999'
      ShowAccelChar = False
      Transparent = True
    end
    object psBlocksTransferred: TLabel
      Left = 115
      Top = 40
      Width = 93
      Height = 15
      Alignment = taRightJustify
      Caption = '999,999,999,999'
      ShowAccelChar = False
      Transparent = True
    end
    object psBytesRemaining: TLabel
      Left = 115
      Top = 24
      Width = 93
      Height = 15
      Alignment = taRightJustify
      Caption = '999,999,999,999'
      ShowAccelChar = False
      Transparent = True
    end
    object psBytesTransferred: TLabel
      Left = 115
      Top = 8
      Width = 93
      Height = 15
      Alignment = taRightJustify
      Caption = '999,999,999,999'
      ShowAccelChar = False
      Transparent = True
    end
    object psBlockErrors: TLabel
      Left = 163
      Top = 72
      Width = 45
      Height = 15
      Alignment = taRightJustify
      Caption = '999,999'
      ShowAccelChar = False
    end
    object psTotalErrors: TLabel
      Left = 163
      Top = 88
      Width = 45
      Height = 15
      Alignment = taRightJustify
      Caption = '999,999'
      ShowAccelChar = False
    end
    object psLabel13: TLabel
      Left = 8
      Top = 8
      Width = 96
      Height = 15
      Caption = 'Bytes transferred:'
    end
    object psLabel14: TLabel
      Left = 8
      Top = 24
      Width = 92
      Height = 15
      Caption = 'Bytes remaining:'
    end
    object psLabel15: TLabel
      Left = 8
      Top = 40
      Width = 103
      Height = 15
      Caption = 'Blocks transferred:'
    end
    object psLabel16: TLabel
      Left = 8
      Top = 56
      Width = 99
      Height = 15
      Caption = 'Blocks remaining:'
    end
    object psLabel17: TLabel
      Left = 8
      Top = 72
      Width = 69
      Height = 15
      Caption = 'Block errors:'
    end
    object psLabel18: TLabel
      Left = 8
      Top = 88
      Width = 65
      Height = 15
      Caption = 'Total errors:'
    end
  end
  object psPanel3: TPanel
    Left = 8
    Top = 128
    Width = 217
    Height = 65
    TabOrder = 2
    object psLabel7: TLabel
      Left = 8
      Top = 8
      Width = 86
      Height = 15
      Caption = 'Estimated time:'
    end
    object psLabel8: TLabel
      Left = 8
      Top = 25
      Width = 76
      Height = 15
      Caption = 'Elapsed time:'
    end
    object psLabel9: TLabel
      Left = 8
      Top = 41
      Width = 91
      Height = 15
      Caption = 'Remaining time:'
    end
    object psEstimatedTime: TLabel
      Left = 163
      Top = 8
      Width = 45
      Height = 15
      Alignment = taRightJustify
      Caption = '9999:99'
      ShowAccelChar = False
    end
    object psElapsedTime: TLabel
      Left = 163
      Top = 25
      Width = 45
      Height = 15
      Alignment = taRightJustify
      Caption = '9999:99'
      ShowAccelChar = False
    end
    object psRemainingTime: TLabel
      Left = 163
      Top = 41
      Width = 45
      Height = 15
      Alignment = taRightJustify
      Caption = '9999:99'
      ShowAccelChar = False
    end
  end
  object psPanel4: TPanel
    Left = 240
    Top = 128
    Width = 217
    Height = 65
    TabOrder = 3
    object psLabel10: TLabel
      Left = 8
      Top = 8
      Width = 66
      Height = 15
      Caption = 'Throughput:'
    end
    object psLabel11: TLabel
      Left = 8
      Top = 25
      Width = 54
      Height = 15
      Caption = 'Efficiency:'
    end
    object psLabel12: TLabel
      Left = 8
      Top = 41
      Width = 91
      Height = 15
      Caption = 'Kermit windows:'
    end
    object psThroughput: TLabel
      Left = 145
      Top = 8
      Width = 63
      Height = 15
      Alignment = taRightJustify
      Caption = '99999 CPS'
      ShowAccelChar = False
    end
    object psEfficiency: TLabel
      Left = 173
      Top = 25
      Width = 35
      Height = 15
      Alignment = taRightJustify
      Caption = '100 %'
      ShowAccelChar = False
    end
    object psKermitWindows: TLabel
      Left = 177
      Top = 41
      Width = 31
      Height = 15
      Alignment = taRightJustify
      Caption = '99/99'
      ShowAccelChar = False
    end
  end
  object psPanel5: TPanel
    Left = 8
    Top = 200
    Width = 449
    Height = 33
    TabOrder = 4
    object psLabel22: TLabel
      Left = 8
      Top = 9
      Width = 38
      Height = 15
      Caption = 'Status:'
    end
    object psStatusMsg: TLabel
      Left = 56
      Top = 9
      Width = 17
      Height = 15
      Caption = 'OK'
      ShowAccelChar = False
    end
  end
  object psCancel: TButton
    Left = 189
    Top = 285
    Width = 89
    Height = 27
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = CancelClick
  end
  object psPanel6: TPanel
    Left = 8
    Top = 240
    Width = 449
    Height = 33
    TabOrder = 6
    object psLabel19: TLabel
      Left = 8
      Top = 9
      Width = 54
      Height = 15
      Caption = 'Progress:'
    end
  end
end
