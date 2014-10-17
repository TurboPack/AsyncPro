VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{797E7185-0DB7-4E3A-939B-234871F7FAC9}#1.0#0"; "apax1.ocx"
Begin VB.Form Form1 
   Caption         =   "ExCliSrv - Winsock Client/Server"
   ClientHeight    =   6435
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7185
   LinkTopic       =   "Form1"
   ScaleHeight     =   6435
   ScaleWidth      =   7185
   StartUpPosition =   3  'Windows Default
   Begin Apax1.Apax Apax1 
      Height          =   4815
      Left            =   120
      TabIndex        =   5
      Top             =   1560
      Width           =   6975
      Baud            =   19200
      ComNumber       =   0
      DeviceType      =   2
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
      ProtocolStatusDisplay=   0   'False
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
      ShowToolBar     =   -1  'True
      ShowDeviceSelButton=   0   'False
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
   Begin MSComDlg.CommonDialog OpenDialog1 
      Left            =   5520
      Top             =   360
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Frame Frame1 
      Height          =   1335
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   6975
      Begin VB.TextBox txtPort 
         Height          =   285
         Left            =   1200
         TabIndex        =   4
         Top             =   840
         Width           =   1335
      End
      Begin VB.TextBox txtAddress 
         Height          =   285
         Left            =   1200
         TabIndex        =   1
         Top             =   360
         Width           =   3975
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         Caption         =   "Port"
         Height          =   195
         Left            =   480
         TabIndex        =   3
         Top             =   840
         Width           =   285
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "Address"
         Height          =   195
         Left            =   480
         TabIndex        =   2
         Top             =   360
         Width           =   570
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Apax1_OnListenButtonClick(Default As Boolean)
  Default = True
  Caption = "Listening for connection on port: " + Apax1.WinsockPort
End Sub

Private Sub Apax1_OnProtocolAccept(Accept As Boolean, FName As String)
  Apax1.TerminalWriteString ("receiving " + FName)
  Accept = True
End Sub

Private Sub Apax1_OnProtocolFinish(ByVal ErrorCode As Long)
  If ErrorCode = 0 Then
    Apax1.TerminalWriteStringCRLF (" - Ok")
  Else
    Apax1.TerminalWriteStringCRLF (" - Error " + CInt(ErrorCode))
  End If
  Apax1.TerminalActive = True
End Sub

Private Sub Apax1_OnReceiveButtonClick(Default As Boolean)
  Default = True
  Apax1.TerminalActive = False  ' disable terminal from displaying file data
End Sub

Private Sub Apax1_OnSendButtonClick(Default As Boolean)
  Default = False        ' override button's default functionality
  OpenDialog1.ShowOpen
  Apax1.SendFileName = OpenDialog1.FileName
  Apax1.TerminalWriteString ("sending " + Apax1.SendFileName)
  Apax1.TerminalActive = False  ' disable terminal from displaying file data
  Apax1.StartTransmit
End Sub

Private Sub Apax1_OnWinsockAccept(ByVal Addr As String, Accept As Boolean)
  Caption = "Connected - " + Addr
  Apax1.ShowProtocolButtons = True
  Apax1.TerminalSetFocus
  Accept = True
End Sub

Private Sub Apax1_OnWinsockConnect()
  Caption = "Connected - " + Apax1.WinsockAddress
  Apax1.ShowProtocolButtons = True
  Apax1.TerminalSetFocus
End Sub

Private Sub Apax1_OnWinsockDisconnect()
  Apax1.ShowProtocolButtons = False
  Caption = "ExCliSrv - Winsock Client/Server"
End Sub

Private Sub Apax1_OnWinsockError(ByVal ErrCode As Long)
  Caption = ErrCode
End Sub

Private Sub Apax1_OnWinsockGetAddress(Address As String, Port As String)
  Address = txtAddress.Text
  Port = txtPort.Text
End Sub

Private Sub Form_Activate()
  txtAddress.Text = Apax1.WinsockAddress
  txtPort.Text = Apax1.WinsockPort
End Sub

