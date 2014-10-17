object ApdModemConfigDialog: TApdModemConfigDialog
  Left = 264
  Top = 124
  Width = 475
  Height = 354
  ActiveControl = btnOK
  Caption = 'Modem Configuration'
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 274
    Top = 295
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 362
    Top = 295
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 467
    Height = 290
    ActivePage = TabSheet3
    Align = alTop
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = ' &General'
      object lblModemName: TLabel
        Left = 24
        Top = 3
        Width = 70
        Height = 13
        Caption = 'Modem name: '
      end
      object lblModemModel: TLabel
        Left = 24
        Top = 28
        Width = 69
        Height = 13
        Caption = 'Modem model:'
      end
      object lblModemManufacturer: TLabel
        Left = 24
        Top = 53
        Width = 66
        Height = 13
        Caption = 'Manufacturer:'
      end
      object lblAttachedTo: TLabel
        Left = 24
        Top = 79
        Width = 58
        Height = 13
        Caption = 'Attached to:'
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 112
        Width = 393
        Height = 89
        Caption = ' Speaker control '
        TabOrder = 0
        object Label1: TLabel
          Left = 13
          Top = 45
          Width = 80
          Height = 13
          Caption = 'Speaker volume:'
        end
        object Label2: TLabel
          Left = 125
          Top = 69
          Width = 20
          Height = 13
          Caption = 'Low'
        end
        object Label3: TLabel
          Left = 260
          Top = 69
          Width = 22
          Height = 13
          Caption = 'High'
        end
        object tbSpeakerVolume: TTrackBar
          Left = 125
          Top = 45
          Width = 161
          Height = 25
          Max = 2
          Orientation = trHorizontal
          PageSize = 1
          Frequency = 1
          Position = 0
          SelEnd = 0
          SelStart = 0
          TabOrder = 1
          TickMarks = tmBottomRight
          TickStyle = tsAuto
        end
        object rbSpeakerConnect: TRadioButton
          Left = 134
          Top = 16
          Width = 123
          Height = 17
          Caption = 'On until connect'
          TabOrder = 0
        end
        object rbSpeakerOn: TRadioButton
          Left = 272
          Top = 16
          Width = 113
          Height = 17
          Caption = 'Always on'
          TabOrder = 2
        end
        object rbSpeakerOff: TRadioButton
          Left = 16
          Top = 16
          Width = 105
          Height = 17
          Caption = 'Off'
          TabOrder = 3
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = ' &Connection'
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 403
        Height = 89
        Caption = ' Connection preferences '
        TabOrder = 0
        object rgpDataBits: TRadioGroup
          Left = 8
          Top = 16
          Width = 103
          Height = 65
          Caption = ' Data bits '
          Columns = 2
          ItemIndex = 3
          Items.Strings = (
            '5'
            '6'
            '7'
            '8')
          TabOrder = 0
        end
        object rgpParity: TRadioGroup
          Left = 112
          Top = 16
          Width = 201
          Height = 65
          Caption = ' Parity '
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            'None'
            'Odd'
            'Even'
            'Mark'
            'Space')
          TabOrder = 1
        end
        object rgpStopBits: TRadioGroup
          Left = 315
          Top = 16
          Width = 79
          Height = 66
          Caption = ' Stop bits '
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            '1'
            '2')
          TabOrder = 2
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 104
        Width = 403
        Height = 97
        Caption = ' Call preference '
        TabOrder = 1
        object Label5: TLabel
          Left = 277
          Top = 45
          Width = 40
          Height = 13
          Caption = '&seconds'
          FocusControl = edtCallSetupFailTimer
          Transparent = True
        end
        object Label7: TLabel
          Left = 192
          Top = 71
          Width = 36
          Height = 13
          Caption = '&minutes'
          Transparent = True
        end
        object cbxEnableCallFailTimer: TCheckBox
          Left = 16
          Top = 40
          Width = 313
          Height = 25
          Caption = '&Cancel call if negotiation fails within '
          TabOrder = 0
        end
        object cbxNotBlindDial: TCheckBox
          Left = 16
          Top = 15
          Width = 121
          Height = 25
          Caption = '&Wait for dial tone'
          TabOrder = 2
        end
        object cbxEnableIdleTimeout: TCheckBox
          Left = 16
          Top = 66
          Width = 225
          Height = 25
          Caption = '&Disconnect if idle for'
          TabOrder = 4
        end
        object edtCallSetupFailTimer: TEdit
          Left = 240
          Top = 41
          Width = 33
          Height = 21
          TabOrder = 1
          Text = '60'
        end
        object edtInactivityTimer: TEdit
          Left = 152
          Top = 67
          Width = 33
          Height = 21
          TabOrder = 3
          Text = '60'
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = ' &Advanced'
      object Label4: TLabel
        Left = 8
        Top = 128
        Width = 193
        Height = 49
        AutoSize = False
        Caption = 
          'Enter any additional modem commands required for this configurat' +
          'ion. '
        WordWrap = True
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 8
        Width = 185
        Height = 80
        Caption = '&Flow control '
        TabOrder = 4
        object rbFlowNone: TRadioButton
          Left = 16
          Top = 16
          Width = 113
          Height = 17
          Caption = 'None'
          TabOrder = 0
        end
        object rbFlowHard: TRadioButton
          Left = 16
          Top = 35
          Width = 153
          Height = 17
          Caption = 'Hardware (RTS/CTS)'
          TabOrder = 1
        end
        object rbFlowSoft: TRadioButton
          Left = 16
          Top = 54
          Width = 153
          Height = 17
          Caption = 'Software (XON/XOFF)'
          TabOrder = 2
        end
      end
      object rgpErrorCorrection: TGroupBox
        Left = 208
        Top = 8
        Width = 193
        Height = 80
        Caption = '&Error correction '
        TabOrder = 0
        object cbxCellular: TCheckBox
          Left = 16
          Top = 54
          Width = 169
          Height = 17
          Caption = 'Use cellular correction'
          TabOrder = 2
        end
        object cbxUseErrorCorrection: TCheckBox
          Left = 16
          Top = 16
          Width = 100
          Height = 17
          Caption = 'Use if possible'
          TabOrder = 0
        end
        object cbxRequireCorrection: TCheckBox
          Left = 16
          Top = 35
          Width = 145
          Height = 17
          Caption = 'Require to connect'
          TabOrder = 1
        end
      end
      object cbxDataCompress: TCheckBox
        Left = 8
        Top = 104
        Width = 177
        Height = 17
        Caption = '&Enable data compression'
        TabOrder = 1
      end
      object GroupBox5: TGroupBox
        Left = 208
        Top = 95
        Width = 193
        Height = 80
        Caption = '&Modulation '
        TabOrder = 2
        object rbModCCITT: TRadioButton
          Left = 17
          Top = 16
          Width = 113
          Height = 17
          Caption = 'CCITT (normal)'
          TabOrder = 0
        end
        object rbModCCITTV23: TRadioButton
          Left = 16
          Top = 35
          Width = 113
          Height = 17
          Caption = 'CCITT V23'
          TabOrder = 1
        end
        object rbModBell: TRadioButton
          Left = 16
          Top = 54
          Width = 113
          Height = 17
          Caption = 'Bell'
          TabOrder = 2
        end
      end
      object edtExtraSettings: TEdit
        Left = 8
        Top = 184
        Width = 393
        Height = 21
        TabOrder = 3
      end
    end
  end
end
