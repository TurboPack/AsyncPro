object ApdFaxJobInfoDialog: TApdFaxJobInfoDialog
  Left = 280
  Top = 174
  Caption = 'ApdFaxJobInfoDialog'
  ClientHeight = 414
  ClientWidth = 362
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 353
    Height = 145
    Caption = ' Fax Job Information '
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 47
      Height = 13
      Caption = 'FileName:'
    end
    object Label2: TLabel
      Left = 16
      Top = 34
      Width = 74
      Height = 13
      Caption = 'Date submitted:'
    end
    object Label3: TLabel
      Left = 16
      Top = 52
      Width = 33
      Height = 13
      Caption = 'Status:'
    end
    object Label4: TLabel
      Left = 16
      Top = 70
      Width = 37
      Height = 13
      Caption = 'Sender:'
    end
    object Label5: TLabel
      Left = 16
      Top = 88
      Width = 77
      Height = 13
      Caption = 'Number of Jobs:'
    end
    object Label6: TLabel
      Left = 16
      Top = 106
      Width = 83
      Height = 13
      Caption = 'Next Job to send:'
    end
    object lblFileName: TLabel
      Left = 118
      Top = 14
      Width = 54
      Height = 13
      Caption = 'lblFileName'
    end
    object lblDateSubmitted: TLabel
      Left = 118
      Top = 32
      Width = 80
      Height = 13
      Caption = 'lblDateSubmitted'
    end
    object lblStatus: TLabel
      Left = 118
      Top = 51
      Width = 40
      Height = 13
      Caption = 'lblStatus'
    end
    object lblSender: TLabel
      Left = 118
      Top = 69
      Width = 44
      Height = 13
      Caption = 'lblSender'
    end
    object lblNumJobs: TLabel
      Left = 118
      Top = 87
      Width = 54
      Height = 13
      Caption = 'lblNumJobs'
    end
    object lblNextJob: TLabel
      Left = 118
      Top = 106
      Width = 49
      Height = 13
      Caption = 'lblNextJob'
    end
    object Label13: TLabel
      Left = 16
      Top = 124
      Width = 96
      Height = 13
      Caption = 'Next job Date/Time:'
    end
    object lblDateNextSend: TLabel
      Left = 118
      Top = 124
      Width = 80
      Height = 13
      Caption = 'lblDateNextSend'
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 160
    Width = 353
    Height = 225
    Caption = ' Fax Job Receiver Information '
    TabOrder = 1
    object Label7: TLabel
      Left = 16
      Top = 39
      Width = 33
      Height = 13
      Caption = 'Status:'
    end
    object Label9: TLabel
      Left = 16
      Top = 130
      Width = 72
      Height = 13
      Caption = 'Phone number:'
    end
    object Label10: TLabel
      Left = 16
      Top = 153
      Width = 58
      Height = 13
      Caption = 'HeaderLine:'
    end
    object Label11: TLabel
      Left = 16
      Top = 176
      Width = 83
      Height = 13
      Caption = 'HeaderRecipient:'
    end
    object Label12: TLabel
      Left = 16
      Top = 199
      Width = 58
      Height = 13
      Caption = 'HeaderTitle:'
    end
    object Label15: TLabel
      Left = 16
      Top = 62
      Width = 62
      Height = 13
      Caption = 'Attempt num:'
    end
    object Label16: TLabel
      Left = 120
      Top = 62
      Width = 51
      Height = 13
      Caption = 'Last result:'
    end
    object lblJobStatus: TLabel
      Left = 88
      Top = 39
      Width = 57
      Height = 13
      Caption = 'lblJobStatus'
    end
    object lblAttemptNum: TLabel
      Left = 88
      Top = 62
      Width = 6
      Height = 13
      Caption = '0'
    end
    object lblLastResult: TLabel
      Left = 193
      Top = 62
      Width = 60
      Height = 13
      Caption = 'lblLastResult'
    end
    object btnPrev: TSpeedButton
      Left = 302
      Top = 8
      Width = 23
      Height = 22
      Enabled = False
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333FF3333333333333003333333333333F77F33333333333009033
        333333333F7737F333333333009990333333333F773337FFFFFF330099999000
        00003F773333377777770099999999999990773FF33333FFFFF7330099999000
        000033773FF33777777733330099903333333333773FF7F33333333333009033
        33333333337737F3333333333333003333333333333377333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
      OnClick = btnPrevClick
    end
    object btnNext: TSpeedButton
      Left = 327
      Top = 8
      Width = 23
      Height = 22
      Enabled = False
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333FF3333333333333003333
        3333333333773FF3333333333309003333333333337F773FF333333333099900
        33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
        99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
        33333333337F3F77333333333309003333333333337F77333333333333003333
        3333333333773333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
      OnClick = btnNextClick
    end
    object Label14: TLabel
      Left = 16
      Top = 16
      Width = 58
      Height = 13
      Caption = 'Job number:'
    end
    object lblJobNumber: TLabel
      Left = 88
      Top = 16
      Width = 64
      Height = 13
      Caption = 'lblJobNumber'
    end
    object Label8: TLabel
      Left = 16
      Top = 108
      Width = 76
      Height = 13
      Caption = 'Scheduled time:'
    end
    object lblDateSample: TLabel
      Left = 220
      Top = 85
      Width = 68
      Height = 13
      Caption = 'lblDateSample'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblTimeSample: TLabel
      Left = 220
      Top = 108
      Width = 68
      Height = 13
      Caption = 'lblTimeSample'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label17: TLabel
      Left = 16
      Top = 85
      Width = 78
      Height = 13
      Caption = 'Scheduled date:'
    end
    object edtPhoneNum: TEdit
      Left = 120
      Top = 127
      Width = 220
      Height = 21
      TabOrder = 2
      Text = 'edtPhoneNum'
      OnChange = EditBoxChange
    end
    object edtHeaderLine: TEdit
      Left = 120
      Top = 150
      Width = 220
      Height = 21
      TabOrder = 3
      Text = 'edtHeaderLine'
      OnChange = EditBoxChange
    end
    object edtHeaderRecipient: TEdit
      Left = 120
      Top = 172
      Width = 220
      Height = 21
      TabOrder = 4
      Text = 'edtHeaderRecipient'
      OnChange = EditBoxChange
    end
    object edtHeaderTitle: TEdit
      Left = 120
      Top = 195
      Width = 220
      Height = 21
      TabOrder = 5
      Text = 'edtHeaderTitle'
      OnChange = EditBoxChange
    end
    object btnReset: TButton
      Left = 265
      Top = 34
      Width = 75
      Height = 22
      Caption = 'Reset status'
      TabOrder = 6
      OnClick = btnResetClick
    end
    object edtSchedDate: TEdit
      Left = 120
      Top = 81
      Width = 87
      Height = 21
      TabOrder = 0
      Text = 'edtSchedDate'
      OnChange = EditBoxChange
    end
    object edtSchedTime: TEdit
      Left = 120
      Top = 104
      Width = 87
      Height = 21
      TabOrder = 1
      Text = 'edtSchedTime'
      OnChange = EditBoxChange
    end
  end
  object btnOK: TButton
    Left = 112
    Top = 394
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 200
    Top = 394
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object btnApply: TButton
    Left = 288
    Top = 394
    Width = 75
    Height = 25
    Caption = 'Apply'
    TabOrder = 4
    OnClick = btnApplyClick
  end
end
