VERSION 5.00
Object = "{797E7185-0DB7-4E3A-939B-234871F7FAC9}#1.0#0"; "apax1.ocx"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   7800
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10335
   LinkTopic       =   "Form1"
   ScaleHeight     =   7800
   ScaleWidth      =   10335
   StartUpPosition =   3  'Windows Default
   Begin Apax1.Apax Apax1 
      Height          =   3255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   6375
      Baud            =   19200
      ComNumber       =   0
      DeviceType      =   0
      DataBits        =   8
      DTR             =   -1  'True
      HWFlowUseDTR    =   0   'False
      HWFlowUseRTS    =   0   'False
      HWFlowRequireDSR=   0   'False
      HWFlowRequireCTS=   0   'False
      LogAllHex       =   0   'False
      Logging         =   0
      LogHex          =   -1  'True
      LogName         =   "APRO.LOG"
      LogSize         =   10000
      Parity          =   0
      PromptForPort   =   -1  'True
      RS485Mode       =   0   'False
      RTS             =   -1  'True
      StopBits        =   1
      SWFlowOptions   =   0
      XOffChar        =   19
      XOnChar         =   17
      WinsockMode     =   0
      WinsockAddress  =   ""
      WinsockPort     =   "telnet"
      WsTelnet        =   -1  'True
      AnswerOnRing    =   2
      EnableVoice     =   0   'False
      MaxAttempts     =   3
      InterruptWave   =   -1  'True
      MaxMessageLength=   60
      SelectedDevice  =   ""
      SilenceThreshold=   50
      TapiNumber      =   ""
      TapiRetryWait   =   60
      TrimSeconds     =   2
      UseSoundCard    =   0   'False
      CaptureFile     =   "APROTERM.CAP"
      CaptureMode     =   0
      Color           =   8388608
      Columns         =   80
      Emulation       =   0
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Terminal"
         Size            =   9
         Charset         =   255
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Rows            =   24
      ScrollbackEnabled=   0   'False
      ScrollbackRows  =   200
      TerminalActive  =   -1  'True
      TerminalBlinkTime=   500
      TerminalHalfDuplex=   0   'False
      TerminalLazyByteDelay=   200
      TerminalLazyTimeDelay=   100
      TerminalUseLazyDisplay=   -1  'True
      TerminalWantAllKeys=   -1  'True
      Version         =   "1.00"
      Object.Visible         =   -1  'True
      DataTriggerString=   ""
      ProtocolStatusDisplay=   -1  'True
      Protocol        =   8
      AbortNoCarrier  =   0   'False
      AsciiCharDelay  =   0
      AsciiCRTranslation=   0
      AsciiEOFTimeout =   364
      AsciiEOLChar    =   13
      AsciiLFTranslation=   0
      AsciiLineDelay  =   0
      AsciiSuppressCtrlZ=   0   'False
      BlockCheckMethod=   1
      FinishWait      =   364
      HandshakeRetry  =   10
      HandshakeWait   =   1092
      HonorDirectory  =   0   'False
      IncludeDirectory=   0   'False
      KermitCtlPrefix =   35
      KermitHighbitPrefix=   89
      KermitMaxLen    =   80
      KermitMaxWindows=   0
      KermitPadCharacter=   0
      KermitPadCount  =   0
      KermitRepeatPrefix=   126
      KermitSWCTurnDelay=   0
      KermitTerminator=   13
      KermitTimeoutSecs=   5
      ReceiveDirectory=   ""
      ReceiveFileName =   ""
      RTSLowForWrite  =   0   'False
      SendFileName    =   "*.*"
      StatusInterval  =   10
      TransmitTimeout =   1092
      UpcaseFileNames =   -1  'True
      WriteFailAction =   2
      XYmodemBlockWait=   91
      Zmodem8K        =   0   'False
      ZmodemFileOptions=   5
      ZmodemFinishRetry=   0
      ZmodemOptionOverride=   0   'False
      ZmodemRecover   =   0   'False
      ZmodemSkipNoFile=   0   'False
      Caption         =   "Apax v1.00"
      CaptionAlignment=   2
      CaptionWidth    =   100
      LightWidth      =   40
      LightsLitColor  =   255
      LightsNotLitColor=   8421376
      ShowLightCaptions=   -1  'True
      ShowLights      =   -1  'True
      ShowStatusBar   =   -1  'True
      ShowToolBar     =   0   'False
      ShowDeviceSelButton=   -1  'True
      ShowConnectButtons=   -1  'True
      ShowProtocolButtons=   -1  'True
      ShowTerminalButtons=   -1  'True
      DoubleBuffered  =   0   'False
      Enabled         =   -1  'True
      Cursor          =   0
      TapiStatusDisplay=   -1  'True
      CommPort        =   0
      DTREnable       =   -1  'True
      Handshaking     =   0
      InBufferSize    =   1024
      OutBufferSize   =   512
      RTSEnable       =   -1  'True
      Settings        =   "19200,N,8,1"
      InputMode       =   0
      InputLen        =   0
      MSCommCompatible=   -1  'True
      RTThreshold     =   0
      SThreshold      =   0
   End
   Begin VB.Frame Frame4 
      Height          =   7695
      Left            =   6600
      TabIndex        =   12
      Top             =   0
      Width           =   3615
      Begin VB.CommandButton cmdSet 
         Caption         =   "Set"
         Height          =   375
         Left            =   1320
         TabIndex        =   30
         Top             =   6480
         Width           =   855
      End
      Begin VB.Frame Frame8 
         Caption         =   " Input Settings "
         Height          =   2535
         Left            =   240
         TabIndex        =   23
         Top             =   3720
         Width           =   3135
         Begin VB.ComboBox cboInputMode 
            Height          =   315
            ItemData        =   "ExMsComm.frx":0000
            Left            =   1440
            List            =   "ExMsComm.frx":000A
            Style           =   2  'Dropdown List
            TabIndex        =   33
            Top             =   480
            Width           =   1335
         End
         Begin VB.TextBox txtRTThreshold 
            Height          =   285
            Left            =   1440
            TabIndex        =   29
            Top             =   2040
            Width           =   735
         End
         Begin VB.TextBox txtInBufferSize 
            Height          =   285
            Left            =   1440
            TabIndex        =   27
            Top             =   1560
            Width           =   735
         End
         Begin VB.TextBox txtInputLen 
            Height          =   285
            Left            =   1440
            TabIndex        =   25
            Top             =   1080
            Width           =   735
         End
         Begin VB.Label Label9 
            AutoSize        =   -1  'True
            Caption         =   "Mode"
            Height          =   195
            Left            =   360
            TabIndex        =   34
            Top             =   480
            Width           =   405
         End
         Begin VB.Label Label7 
            AutoSize        =   -1  'True
            Caption         =   "RTThreshold"
            Height          =   195
            Left            =   360
            TabIndex        =   28
            Top             =   2040
            Width           =   930
         End
         Begin VB.Label Label6 
            AutoSize        =   -1  'True
            Caption         =   "InBufferSize"
            Height          =   195
            Left            =   360
            TabIndex        =   26
            Top             =   1560
            Width           =   855
         End
         Begin VB.Label Label5 
            AutoSize        =   -1  'True
            Caption         =   "InputLen"
            Height          =   195
            Left            =   360
            TabIndex        =   24
            Top             =   1080
            Width           =   630
         End
      End
      Begin VB.Frame Frame7 
         Caption         =   " Output Settings "
         Height          =   1335
         Left            =   240
         TabIndex        =   18
         Top             =   2280
         Width           =   3135
         Begin VB.TextBox txtSThreshold 
            Height          =   285
            Left            =   1560
            TabIndex        =   22
            Top             =   840
            Width           =   735
         End
         Begin VB.TextBox txtOutBufferSize 
            Height          =   285
            Left            =   1560
            TabIndex        =   20
            Top             =   360
            Width           =   735
         End
         Begin VB.Label Label4 
            AutoSize        =   -1  'True
            Caption         =   "SThreshold"
            Height          =   195
            Left            =   360
            TabIndex        =   21
            Top             =   840
            Width           =   810
         End
         Begin VB.Label Label3 
            AutoSize        =   -1  'True
            Caption         =   "OutBufferSize"
            Height          =   195
            Left            =   360
            TabIndex        =   19
            Top             =   360
            Width           =   975
         End
      End
      Begin VB.Frame Frame5 
         Caption         =   " Serial Comm Port Settings "
         Height          =   1935
         Left            =   240
         TabIndex        =   13
         Top             =   240
         Width           =   3135
         Begin VB.ComboBox cboHandshaking 
            Height          =   315
            ItemData        =   "ExMsComm.frx":001C
            Left            =   1440
            List            =   "ExMsComm.frx":002C
            Style           =   2  'Dropdown List
            TabIndex        =   31
            Top             =   1440
            Width           =   1455
         End
         Begin VB.CheckBox chkRTSEnable 
            Alignment       =   1  'Right Justify
            Caption         =   "RTSEnable"
            Height          =   375
            Left            =   1680
            TabIndex        =   17
            Top             =   840
            Width           =   1215
         End
         Begin VB.CheckBox chkDTREnable 
            Alignment       =   1  'Right Justify
            Caption         =   "DTREnable"
            Height          =   375
            Left            =   360
            TabIndex        =   16
            Top             =   840
            Width           =   1215
         End
         Begin VB.TextBox txtSettings 
            Height          =   285
            Left            =   1440
            TabIndex        =   15
            Top             =   360
            Width           =   1455
         End
         Begin VB.Label Label8 
            AutoSize        =   -1  'True
            Caption         =   "Handshaking"
            Height          =   195
            Left            =   360
            TabIndex        =   32
            Top             =   1440
            Width           =   945
         End
         Begin VB.Label Label2 
            AutoSize        =   -1  'True
            Caption         =   "Settings"
            Height          =   195
            Left            =   360
            TabIndex        =   14
            Top             =   360
            Width           =   570
         End
      End
   End
   Begin VB.Frame Frame3 
      Caption         =   " Comm Port "
      Height          =   855
      Left            =   120
      TabIndex        =   5
      Top             =   6840
      Width           =   6375
      Begin VB.CommandButton cmdClose 
         Caption         =   "Close"
         Height          =   375
         Left            =   3000
         TabIndex        =   9
         Top             =   240
         Width           =   855
      End
      Begin VB.CommandButton cmdOpen 
         Caption         =   "Open"
         Height          =   375
         Left            =   1920
         TabIndex        =   8
         Top             =   240
         Width           =   855
      End
      Begin VB.TextBox txtCommPort 
         Height          =   285
         Left            =   1080
         TabIndex        =   7
         Top             =   360
         Width           =   615
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "CommPort"
         Height          =   195
         Left            =   240
         TabIndex        =   6
         Top             =   360
         Width           =   720
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   " OnComm "
      Height          =   2175
      Left            =   120
      TabIndex        =   4
      Top             =   4560
      Width           =   6375
      Begin VB.ListBox lstInput 
         Height          =   1620
         ItemData        =   "ExMsComm.frx":0050
         Left            =   1680
         List            =   "ExMsComm.frx":0052
         TabIndex        =   11
         Top             =   360
         Width           =   4575
      End
      Begin VB.ListBox lstOnComm 
         Height          =   1620
         ItemData        =   "ExMsComm.frx":0054
         Left            =   120
         List            =   "ExMsComm.frx":0056
         TabIndex        =   10
         Top             =   360
         Width           =   1455
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   " Output "
      Height          =   960
      Left            =   120
      TabIndex        =   1
      Top             =   3480
      Width           =   6375
      Begin VB.TextBox txtOutput 
         Height          =   285
         Left            =   1320
         TabIndex        =   3
         Top             =   360
         Width           =   4815
      End
      Begin VB.CommandButton cmdOutput 
         Caption         =   "Output"
         Height          =   375
         Left            =   360
         TabIndex        =   2
         Top             =   360
         Width           =   855
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub InputData()
  Dim i, S, Data
  S = ""
  If Apax1.InBufferCount > 0 Then
    Data = Apax1.Input
    If IsArray(Data) Then
      For i = LBound(Data) To UBound(Data)
        S = S & " &H" & Hex(Data(i))
      Next
      lstInput.AddItem (S)
    End If
  End If
End Sub

Private Sub Apax1_OnComm()
  Select Case Apax1.CommEvent
    Case comEvSend:
      lstOnComm.AddItem ("comEvSend")
    Case comEvReceive:
      lstOnComm.AddItem ("comEvReceive")
      InputData
    Case comEvCTS:
      lstOnComm.AddItem ("comEvCTS")
    Case comEvDSR:
      lstOnComm.AddItem ("comEvDSR")
    Case comEvCD:
      lstOnComm.AddItem ("comEvCD")
    Case comEvRing:
      lstOnComm.AddItem ("comEvRing")
    Case comEventBreak:
      lstOnComm.AddItem ("comEventBreak")
    Case comEventCTSTO:
      lstOnComm.AddItem ("comEventCTSTO")
    Case comEventDSRTO:
      lstOnComm.AddItem ("comEventDSRTO")
    Case comEventFrame:
      lstOnComm.AddItem ("comEventFrame")
    Case comEventOverrun:
      lstOnComm.AddItem ("comEventOverrun")
    Case comEventCDTO:
      lstOnComm.AddItem ("comEventCDTO")
    Case comEventRxOver:
      lstOnComm.AddItem ("comEventRxOver")
    Case comEventRxParity:
      lstOnComm.AddItem ("comEventRxParity")
    Case comEventTxFull:
      lstOnComm.AddItem ("comEventTxFull")
  End Select

End Sub

Private Sub cmdClose_Click()
  Apax1.Close
End Sub

Private Sub cmdOpen_Click()
  Apax1.CommPort = CInt(txtCommPort.Text)
  Apax1.PortOpen
  txtCommPort.Text = CStr(Apax1.CommPort)
End Sub

Private Sub cmdOutput_Click()
  Dim i, Count, S()
  Count = Len(txtOutput.Text)
  ReDim S(Count)
  For i = 1 To Count
    S(i - 1) = GetChar(txtOutput.Text, i)
  Next
  Apax1.Output = S
End Sub

Private Function GetChar(ByVal Str As String, ByVal Index As Integer) As Byte
  GetChar = Asc(Mid(Str, Index, 1))
End Function

Private Sub cmdSet_Click()
  Apax1.Settings = txtSettings.Text
  Apax1.DTREnable = CBool(chkDTREnable.Value)
  Apax1.RTSEnable = CBool(chkRTSEnable.Value)
  Apax1.Handshaking = cboHandshaking.ListIndex
  Apax1.OutBufferSize = CInt(txtOutBufferSize.Text)
  Apax1.SThreshold = CInt(txtSThreshold.Text)
  Apax1.InputMode = cboInputMode.ListIndex
  Apax1.InBufferSize = CInt(txtInBufferSize.Text)
  Apax1.RTThreshold = CInt(txtRTThreshold.Text)
End Sub

Private Sub Form_Activate()
  txtCommPort.Text = CStr(Apax1.CommPort)
  txtSettings.Text = Apax1.Settings
  chkDTREnable.Value = Abs(Apax1.DTREnable) ' Boolean -> Value
  chkRTSEnable.Value = Abs(Apax1.RTSEnable) ' Boolean -> Value
  cboHandshaking.ListIndex = Apax1.Handshaking
  txtOutBufferSize.Text = CStr(Apax1.OutBufferSize)
  txtSThreshold.Text = CStr(Apax1.SThreshold)
  cboInputMode.ListIndex = Apax1.InputMode
  txtInBufferSize.Text = CStr(Apax1.InBufferSize)
  txtRTThreshold.Text = CStr(Apax1.RTThreshold)

End Sub

