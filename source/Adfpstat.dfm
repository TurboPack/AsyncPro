object StandardFaxPrinterStatusDisplay: TStandardFaxPrinterStatusDisplay
  Left = 482
  Top = 197
  ActiveControl = fpsAbortButton
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Print Status'
  ClientHeight = 225
  ClientWidth = 267
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
  object fpsAbortButton: TBitBtn
    Left = 96
    Top = 194
    Width = 75
    Height = 27
    Caption = 'Abort'
    DoubleBuffered = True
    ModalResult = 3
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 0
    OnClick = fpsAbortButtonClick
  end
  object fpsFaxInfoGroup: TGroupBox
    Left = 4
    Top = 4
    Width = 259
    Height = 133
    Caption = 'Fax Information'
    TabOrder = 1
    object fpsLabel1: TLabel
      Left = 12
      Top = 19
      Width = 42
      Height = 13
      Caption = 'Filename'
    end
    object fpsLabel2: TLabel
      Left = 12
      Top = 37
      Width = 57
      Height = 13
      Caption = 'Total Pages'
    end
    object fpsLabel3: TLabel
      Left = 12
      Top = 55
      Width = 50
      Height = 13
      Caption = 'Resolution'
    end
    object fpsLabel4: TLabel
      Left = 12
      Top = 72
      Width = 28
      Height = 13
      Caption = 'Width'
    end
    object fpsFileName: TLabel
      Left = 212
      Top = 19
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'noname'
      ShowAccelChar = False
    end
    object fpsTotalPages: TLabel
      Left = 232
      Top = 37
      Width = 18
      Height = 13
      Alignment = taRightJustify
      Caption = '999'
      ShowAccelChar = False
    end
    object fpsResolution: TLabel
      Left = 217
      Top = 55
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = 'Normal'
      ShowAccelChar = False
    end
    object fpsWidth: TLabel
      Left = 226
      Top = 72
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Caption = '1728'
      ShowAccelChar = False
    end
    object fpsLabel5: TLabel
      Left = 12
      Top = 90
      Width = 83
      Height = 13
      Caption = 'First Page to Print'
    end
    object fpsLabel6: TLabel
      Left = 12
      Top = 108
      Width = 84
      Height = 13
      Caption = 'Last Page to Print'
    end
    object fpsFirstPage: TLabel
      Left = 232
      Top = 90
      Width = 18
      Height = 13
      Alignment = taRightJustify
      Caption = '999'
      ShowAccelChar = False
    end
    object fpsLastPage: TLabel
      Left = 232
      Top = 108
      Width = 18
      Height = 13
      Alignment = taRightJustify
      Caption = '999'
      ShowAccelChar = False
    end
  end
  object fpsStatusGroup: TGroupBox
    Left = 4
    Top = 144
    Width = 259
    Height = 41
    Caption = 'Status'
    TabOrder = 2
    object fpsStatusLine: TLabel
      Left = 2
      Top = 15
      Width = 255
      Height = 24
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = 'Idle'
      ShowAccelChar = False
    end
  end
end
