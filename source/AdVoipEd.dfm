object VoipAudioVideoEditor: TVoipAudioVideoEditor
  Left = 200
  Top = 138
  Width = 329
  Height = 212
  Caption = 'Voice Over IP Options'
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 158
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 238
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 305
    Height = 137
    Caption = ' Media Terminals '
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 79
      Height = 13
      Caption = 'Audio In Device:'
    end
    object Label2: TLabel
      Left = 8
      Top = 51
      Width = 87
      Height = 13
      Caption = 'Audio Out Device:'
    end
    object Label3: TLabel
      Left = 8
      Top = 78
      Width = 79
      Height = 13
      Caption = 'Video In Device:'
    end
    object cboxAudioIn: TComboBox
      Left = 100
      Top = 20
      Width = 195
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object cboxAudioOut: TComboBox
      Left = 100
      Top = 47
      Width = 195
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
    end
    object cboxVideoIn: TComboBox
      Left = 100
      Top = 74
      Width = 195
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
    end
    object cboxVideoPlayback: TCheckBox
      Left = 8
      Top = 102
      Width = 121
      Height = 17
      Caption = 'Video Playback'
      TabOrder = 3
    end
    object cboxEnablePreview: TCheckBox
      Left = 200
      Top = 102
      Width = 98
      Height = 17
      Caption = 'Enable Preview'
      TabOrder = 4
    end
  end
end
