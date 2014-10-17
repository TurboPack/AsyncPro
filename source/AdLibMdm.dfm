object ApdModemSelectionDialog: TApdModemSelectionDialog
  Left = 414
  Top = 109
  Width = 318
  Height = 157
  HorzScrollBar.Range = 291
  VertScrollBar.Range = 121
  ActiveControl = cbxManufacturer
  AutoScroll = False
  Caption = 'Modem selection'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblText: TLabel
    Left = 8
    Top = 4
    Width = 283
    Height = 31
    AutoSize = False
    Caption = 'Please wait, loading modemcap indices'
    WordWrap = True
  end
  object lblManufacturer: TLabel
    Left = 8
    Top = 44
    Width = 66
    Height = 13
    Caption = 'Manufacturer:'
  end
  object lblModemName: TLabel
    Left = 8
    Top = 71
    Width = 67
    Height = 13
    Caption = 'Modem name:'
  end
  object btnOK: TButton
    Left = 68
    Top = 96
    Width = 75
    Height = 25
    Caption = 'OK'
    Enabled = False
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 156
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object cbxManufacturer: TComboBox
    Left = 96
    Top = 40
    Width = 193
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
    OnChange = cbxManufacturerSelect
  end
  object cbxName: TComboBox
    Left = 96
    Top = 67
    Width = 193
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 2
    OnChange = cbxNameChange
  end
end
