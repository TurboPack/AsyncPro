object RasStatusDisplay: TRasStatusDisplay
  Left = 666
  Top = 241
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'RasStatusDisplay'
  ClientHeight = 79
  ClientWidth = 250
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
  object CancelBtn: TButton
    Left = 87
    Top = 45
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 0
    OnClick = CancelBtnClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 250
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
  end
end
