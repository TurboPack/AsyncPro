object DialDialog: TDialDialog
  Left = 285
  Top = 138
  ActiveControl = Number
  BorderStyle = bsDialog
  Caption = 'Dial'
  ClientHeight = 105
  ClientWidth = 358
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
    Width = 337
    Height = 57
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 20
      Width = 55
      Height = 13
      Caption = 'Dial whom?'
    end
    object Number: TEdit
      Left = 104
      Top = 16
      Width = 217
      Height = 21
      TabOrder = 0
    end
  end
  object Dial: TButton
    Left = 160
    Top = 72
    Width = 89
    Height = 27
    Caption = 'Dial'
    Default = True
    TabOrder = 1
    OnClick = DialClick
  end
  object Cancel: TButton
    Left = 256
    Top = 72
    Width = 89
    Height = 27
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = CancelClick
  end
end
