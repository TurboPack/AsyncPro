object UploadDialog: TUploadDialog
  Left = 311
  Top = 128
  ActiveControl = FileMask
  BorderStyle = bsDialog
  Caption = 'Protocol Upload'
  ClientHeight = 183
  ClientWidth = 377
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
  object Protocols: TRadioGroup
    Left = 8
    Top = 56
    Width = 257
    Height = 121
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
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 257
    Height = 41
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 13
      Width = 53
      Height = 13
      Caption = 'File/Mask: '
    end
    object FileMask: TEdit
      Left = 80
      Top = 9
      Width = 169
      Height = 21
      TabOrder = 0
      Text = '*.*'
    end
  end
  object OK: TButton
    Left = 280
    Top = 8
    Width = 89
    Height = 27
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = OKClick
  end
  object Cancel: TButton
    Left = 280
    Top = 40
    Width = 89
    Height = 27
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = CancelClick
  end
end
