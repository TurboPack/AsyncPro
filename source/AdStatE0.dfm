object frmConditionEdit: TfrmConditionEdit
  Left = 150
  Top = 123
  Width = 283
  Height = 430
  Caption = 'Condition editor'
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 110
    Top = 368
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 192
    Top = 368
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 268
    Width = 257
    Height = 94
    Caption = ' Connectoid properties '
    TabOrder = 2
    object Label6: TLabel
      Left = 8
      Top = 20
      Width = 39
      Height = 13
      Caption = 'Caption:'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 8
      Top = 43
      Width = 27
      Height = 13
      Caption = 'Color:'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 8
      Top = 67
      Width = 31
      Height = 13
      Caption = 'Width:'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object edtCaption: TEdit
      Left = 88
      Top = 16
      Width = 161
      Height = 21
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'edtCaption'
    end
    object cbxColor: TComboBox
      Left = 88
      Top = 40
      Width = 145
      Height = 19
      Style = csOwnerDrawFixed
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 1
      OnDrawItem = cbxColorDrawItem
    end
    object edtWidth: TEdit
      Left = 88
      Top = 64
      Width = 45
      Height = 21
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = 'edtWidth'
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 4
    Width = 257
    Height = 256
    Caption = ' Data properties '
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 53
      Height = 13
      Caption = 'Start string:'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 43
      Width = 47
      Height = 13
      Caption = 'End string'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 89
      Width = 58
      Height = 13
      Caption = 'Packet size:'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 8
      Top = 113
      Width = 41
      Height = 13
      Caption = 'Timeout:'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 8
      Top = 159
      Width = 51
      Height = 13
      Caption = 'Next state:'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 8
      Top = 136
      Width = 52
      Height = 13
      Caption = 'Error code:'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 8
      Top = 231
      Width = 77
      Height = 13
      Caption = 'Activate Output:'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object edtStartString: TEdit
      Left = 88
      Top = 16
      Width = 161
      Height = 21
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'edtStartString'
    end
    object edtEndString: TEdit
      Left = 88
      Top = 39
      Width = 161
      Height = 21
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'edtEndString'
    end
    object edtPacketSize: TEdit
      Left = 88
      Top = 85
      Width = 45
      Height = 21
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = 'edtPacketSize'
    end
    object edtTimeout: TEdit
      Left = 88
      Top = 109
      Width = 45
      Height = 21
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Text = 'edtTimeout'
    end
    object cbxNextState: TComboBox
      Left = 88
      Top = 155
      Width = 145
      Height = 21
      Style = csDropDownList
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 6
      OnDrawItem = cbxColorDrawItem
    end
    object chkIgnoreCase: TCheckBox
      Left = 6
      Top = 64
      Width = 95
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Ignore case:'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object edtErrorCode: TEdit
      Left = 88
      Top = 132
      Width = 121
      Height = 21
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Text = 'edtErrorCode'
    end
    object DefaultNext: TCheckBox
      Left = 6
      Top = 182
      Width = 95
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Default Next:'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object DefaultError: TCheckBox
      Left = 6
      Top = 206
      Width = 95
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Default Error:'
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
    object edtOutputOnActivate: TEdit
      Left = 88
      Top = 228
      Width = 162
      Height = 21
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
    end
  end
end
