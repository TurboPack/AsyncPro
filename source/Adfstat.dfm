object StandardFaxDisplay: TStandardFaxDisplay
  Left = 353
  Top = 28
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Fax Status'
  ClientHeight = 295
  ClientWidth = 529
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
  object fsPanel1: TPanel
    Left = 8
    Top = 8
    Width = 249
    Height = 95
    TabOrder = 0
    object fsLabel1: TLabel
      Left = 8
      Top = 8
      Width = 85
      Height = 15
      Caption = 'Phone number:'
    end
    object fsLabel2: TLabel
      Left = 8
      Top = 24
      Width = 76
      Height = 15
      Caption = 'Fax file name:'
    end
    object fsLabel3: TLabel
      Left = 8
      Top = 40
      Width = 89
      Height = 15
      Caption = 'Cover file name:'
    end
    object fsLabel4: TLabel
      Left = 8
      Top = 56
      Width = 67
      Height = 15
      Caption = 'Total pages:'
    end
    object fsPhoneNumber: TLabel
      Left = 187
      Top = 8
      Width = 53
      Height = 15
      Alignment = taRightJustify
      Caption = '555-1212'
    end
    object fsFaxFileName: TLabel
      Left = 195
      Top = 24
      Width = 46
      Height = 15
      Alignment = taRightJustify
      Caption = 'noname'
    end
    object fsCoverFileName: TLabel
      Left = 195
      Top = 40
      Width = 46
      Height = 15
      Alignment = taRightJustify
      Caption = 'noname'
    end
    object fsTotalPages: TLabel
      Left = 227
      Top = 57
      Width = 14
      Height = 15
      Alignment = taRightJustify
      Caption = '99'
    end
    object fsLabel5: TLabel
      Left = 8
      Top = 72
      Width = 69
      Height = 15
      Caption = 'Dial attempt:'
    end
    object fsDialAttempt: TLabel
      Left = 234
      Top = 72
      Width = 7
      Height = 15
      Alignment = taRightJustify
      Caption = '1'
    end
  end
  object fsPanel2: TPanel
    Left = 272
    Top = 8
    Width = 249
    Height = 95
    TabOrder = 1
    object fsLabel13: TLabel
      Left = 8
      Top = 8
      Width = 62
      Height = 15
      Caption = 'Remote ID:'
    end
    object fsLabel14: TLabel
      Left = 8
      Top = 24
      Width = 76
      Height = 15
      Caption = 'Connect BPS:'
    end
    object fsLabel15: TLabel
      Left = 8
      Top = 40
      Width = 63
      Height = 15
      Caption = 'Resolution:'
    end
    object fsLabel16: TLabel
      Left = 8
      Top = 56
      Width = 34
      Height = 15
      Caption = 'Width:'
    end
    object fsLabel17: TLabel
      Left = 8
      Top = 72
      Width = 70
      Height = 15
      Caption = 'Error control:'
    end
    object fsRemoteID: TLabel
      Left = 192
      Top = 8
      Width = 49
      Height = 15
      Alignment = taRightJustify
      Caption = 'remoteid'
    end
    object fsConnectBPS: TLabel
      Left = 213
      Top = 24
      Width = 28
      Height = 15
      Alignment = taRightJustify
      Caption = '9600'
    end
    object fsResolution: TLabel
      Left = 200
      Top = 40
      Width = 41
      Height = 15
      Alignment = taRightJustify
      Caption = 'Normal'
    end
    object fsWidth: TLabel
      Left = 213
      Top = 56
      Width = 28
      Height = 15
      Alignment = taRightJustify
      Caption = '1728'
    end
    object fsErrorControl: TLabel
      Left = 227
      Top = 72
      Width = 13
      Height = 15
      Alignment = taRightJustify
      Caption = 'off'
    end
  end
  object fsPanel3: TPanel
    Left = 8
    Top = 114
    Width = 249
    Height = 47
    TabOrder = 2
    object fsLabel7: TLabel
      Left = 8
      Top = 8
      Width = 75
      Height = 15
      Caption = 'Current page:'
    end
    object fsLabel8: TLabel
      Left = 8
      Top = 24
      Width = 69
      Height = 15
      Caption = 'Page length:'
    end
    object fsCurrentPage: TLabel
      Left = 233
      Top = 8
      Width = 7
      Height = 15
      Alignment = taRightJustify
      Caption = '1'
    end
    object fsPageLength: TLabel
      Left = 212
      Top = 25
      Width = 28
      Height = 15
      Alignment = taRightJustify
      Caption = '9999'
    end
  end
  object fsPanel4: TPanel
    Left = 272
    Top = 114
    Width = 249
    Height = 46
    TabOrder = 3
    object fsLabel10: TLabel
      Left = 8
      Top = 8
      Width = 96
      Height = 15
      Caption = 'Bytes transferred:'
    end
    object fsLabel11: TLabel
      Left = 8
      Top = 24
      Width = 76
      Height = 15
      Caption = 'Elapsed time:'
    end
    object fsBytesTransferred: TLabel
      Left = 213
      Top = 8
      Width = 28
      Height = 15
      Alignment = taRightJustify
      Caption = '9999'
    end
    object fsElapsedTime: TLabel
      Left = 210
      Top = 25
      Width = 31
      Height = 15
      Alignment = taRightJustify
      Caption = '99:99'
    end
  end
  object fsPanel5: TPanel
    Left = 8
    Top = 171
    Width = 513
    Height = 34
    TabOrder = 4
    object fsLabel22: TLabel
      Left = 8
      Top = 8
      Width = 38
      Height = 15
      Caption = 'Status:'
    end
    object fsStatusMsg: TLabel
      Left = 56
      Top = 8
      Width = 17
      Height = 15
      Caption = 'OK'
    end
  end
  object fsPanel6: TPanel
    Left = 8
    Top = 214
    Width = 513
    Height = 36
    TabOrder = 5
    object fsLabel19: TLabel
      Left = 8
      Top = 8
      Width = 85
      Height = 15
      Caption = 'Page progress:'
    end
  end
  object fsCancel: TButton
    Left = 221
    Top = 260
    Width = 89
    Height = 27
    Caption = 'Cancel'
    TabOrder = 6
    OnClick = CancelClick
  end
end
