object ComSelectForm: TComSelectForm
  Left = 336
  Top = 234
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Select Port'
  ClientHeight = 131
  ClientWidth = 220
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 18
    Top = 14
    Width = 176
    Height = 13
    Caption = 'The configured serial port is not valid.'
  end
  object Label2: TLabel
    Left = 18
    Top = 30
    Width = 133
    Height = 13
    Caption = 'Please choose another port.'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 201
    Height = 42
  end
  object OkBtn: TBitBtn
    Left = 8
    Top = 95
    Width = 85
    Height = 27
    Caption = 'OK'
    Default = True
    DoubleBuffered = True
    ModalResult = 1
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 0
  end
  object AbortBtn: TBitBtn
    Left = 124
    Top = 95
    Width = 85
    Height = 27
    Caption = 'Cancel'
    DoubleBuffered = True
    ModalResult = 3
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 1
  end
  object PortsComboBox: TComboBox
    Left = 8
    Top = 64
    Width = 201
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 2
  end
end
