object AdPEdit: TAdPEdit
  Left = 437
  Top = 305
  BorderStyle = bsDialog
  Caption = 'Select Baud Rate'
  ClientHeight = 85
  ClientWidth = 280
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
  object BaudChoices: TComboBox
    Left = 16
    Top = 16
    Width = 145
    Height = 21
    TabOrder = 0
    Text = 'BaudChoices'
    Items.Strings = (
      '150'
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
  end
  object OK: TButton
    Left = 192
    Top = 16
    Width = 73
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = OKClick
  end
  object Cancel: TButton
    Left = 192
    Top = 48
    Width = 73
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = CancelClick
  end
end
