object frmStateEdit: TfrmStateEdit
  Left = 367
  Top = 82
  Width = 562
  Height = 259
  Caption = 'State editor'
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox2: TGroupBox
    Left = 10
    Top = 12
    Width = 535
    Height = 186
    Caption = ' Conditions '
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object btnAdd: TButton
      Left = 288
      Top = 152
      Width = 75
      Height = 25
      Caption = 'Add'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnAddClick
    end
    object btnEdit: TButton
      Left = 368
      Top = 152
      Width = 75
      Height = 25
      Caption = 'Edit'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnEditClick
    end
    object btnDelete: TButton
      Left = 448
      Top = 152
      Width = 75
      Height = 25
      Caption = 'Delete'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnDeleteClick
    end
  end
  object btnOK: TButton
    Left = 384
    Top = 202
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 468
    Top = 202
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
