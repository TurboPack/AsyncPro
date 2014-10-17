VERSION 5.00
Object = "{797E7185-0DB7-4E3A-939B-234871F7FAC9}#1.0#0"; "apax1.ocx"
Begin VB.Form Form1 
   Caption         =   "ExRecv - File Transfer Receiver"
   ClientHeight    =   4920
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6420
   LinkTopic       =   "Form1"
   ScaleHeight     =   4920
   ScaleWidth      =   6420
   StartUpPosition =   2  'CenterScreen
   Begin Apax1.Apax Apax1 
      Height          =   3855
      Left            =   120
      TabIndex        =   5
      Top             =   120
      Width           =   6255
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
      Protocol        =   7
      AbortNoCarrier  =   0   'False
      AsciiCharDelay  =   0
      AsciiCRTranslation=   0
      AsciiEOFTimeout =   364
      AsciiEOLChar    =   13
      AsciiLFTranslation=   0
      AsciiLineDelay  =   0
      AsciiSuppressCtrlZ=   0   'False
      BlockCheckMethod=   4
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
      MSCommCompatible=   0   'False
      RTThreshold     =   0
      SThreshold      =   0
   End
   Begin VB.ComboBox cbxProtocol 
      Height          =   315
      ItemData        =   "ExRecv.frx":0000
      Left            =   1200
      List            =   "ExRecv.frx":0022
      Style           =   2  'Dropdown List
      TabIndex        =   4
      TabStop         =   0   'False
      Top             =   4320
      Width           =   2055
   End
   Begin VB.Frame Frame1 
      Height          =   735
      Left            =   120
      TabIndex        =   0
      Top             =   4080
      Width           =   6255
      Begin VB.CommandButton btnCancel 
         Caption         =   "Cancel "
         Height          =   395
         Left            =   3480
         TabIndex        =   2
         TabStop         =   0   'False
         Top             =   240
         Width           =   1215
      End
      Begin VB.CommandButton btnStop 
         Caption         =   "Hangup"
         Height          =   395
         Left            =   4920
         TabIndex        =   1
         TabStop         =   0   'False
         Top             =   240
         Width           =   1215
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "Protocol"
         Height          =   195
         Left            =   240
         TabIndex        =   3
         Top             =   240
         Width           =   585
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim RcvFileName As String

Private Sub Apax1_OnProtocolAccept(Accept As Boolean, FName As String)
  RcvFileName = FName
  Caption = "Receiving " + FName
  Accept = True
End Sub

Private Sub Apax1_OnProtocolFinish(ByVal ErrorCode As Long)
  If ErrorCode = 0 Then
    Apax1.TerminalWriteStringCRLF (RcvFileName + " received.")
  Else
    Apax1.TerminalWriteStringCRLF (RcvFileName + " protocol error - " + ErrorCode)
  End If
  Apax1.StartReceive
End Sub

Private Sub Apax1_OnTapiConnect()
  Apax1.Protocol = cbxProtocol.ListIndex
  Caption = "Connected"
  Apax1.StartReceive
End Sub

Private Sub Apax1_OnTapiPortClose()
  Caption = "ExRecv - File Transfer Receiver - Waiting for Call"
  Apax1.TapiAnswer
End Sub

Private Sub btnCancel_Click()
  Apax1.CancelProtocol
End Sub

Private Sub btnStop_Click()
  Apax1.Close
  Caption = "ExRecv - File Transfer Receiver - Waiting For Call"
End Sub

Private Sub Form_Activate()
  cbxProtocol.ListIndex = Apax1.Protocol
  Apax1.TapiAnswer
  Caption = Caption + " - Waiting For Call"
End Sub

