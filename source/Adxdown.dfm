object DownloadDialog: TDownloadDialog
  Left = 311
  Top = 225
  ActiveControl = Directory
  BorderStyle = bsDialog
  Caption = 'Protocol Download'
  ClientHeight = 233
  ClientWidth = 425
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
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 305
    Height = 73
    TabOrder = 0
    object DestDirLabel: TLabel
      Left = 8
      Top = 11
      Width = 45
      Height = 13
      Caption = 'Directory:'
    end
    object FileNameLabel: TLabel
      Left = 8
      Top = 44
      Width = 48
      Height = 13
      Caption = 'File name:'
      Enabled = False
    end
    object Directory: TEdit
      Left = 88
      Top = 8
      Width = 209
      Height = 21
      MaxLength = 80
      TabOrder = 0
    end
    object FileName: TEdit
      Left = 88
      Top = 40
      Width = 209
      Height = 21
      Enabled = False
      MaxLength = 80
      TabOrder = 1
    end
  end
  object Protocols: TRadioGroup
    Left = 8
    Top = 96
    Width = 305
    Height = 129
    Caption = '&Protocols:'
    Columns = 2
    ItemIndex = 6
    Items.Strings = (
      'Xmodem'
      'XmodemCRC'
      'Xmodem1K'
      'Xmodem1K-G'
      'Ymodem'
      'Ymodem-G'
      'Zmodem'
      'Kermit'
      'ASCII'
      'B+')
    TabOrder = 1
    OnClick = ProtocolsClick
  end
  object OK: TButton
    Left = 328
    Top = 8
    Width = 89
    Height = 27
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = OKClick
  end
  object Cancel: TButton
    Left = 328
    Top = 40
    Width = 89
    Height = 27
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = CancelClick
  end
end
