VERSION 5.00
Object = "{797E7185-0DB7-4E3A-939B-234871F7FAC9}#1.1#0"; "Apax1.ocx"
Begin VB.Form Form1 
   Caption         =   "ExWsScan"
   ClientHeight    =   3660
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4320
   LinkTopic       =   "Form1"
   ScaleHeight     =   3660
   ScaleWidth      =   4320
   StartUpPosition =   3  'Windows Default
   Begin APAX1.Apax Apax1 
      Height          =   375
      Left            =   2520
      TabIndex        =   11
      Top             =   0
      Visible         =   0   'False
      Width           =   1575
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
      Version         =   "1.01"
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
      Caption         =   "Apax v1.01"
      CaptionAlignment=   2
      CaptionWidth    =   100
      LightWidth      =   40
      LightsLitColor  =   255
      LightsNotLitColor=   8421376
      ShowLightCaptions=   0   'False
      ShowLights      =   0   'False
      ShowStatusBar   =   -1  'True
      ShowToolBar     =   0   'False
      ShowDeviceSelButton=   0   'False
      ShowConnectButtons=   0   'False
      ShowProtocolButtons=   0   'False
      ShowTerminalButtons=   0   'False
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
      FTPAccount      =   ""
      FTPConnectTimeout=   0
      FTPFileType     =   1
      FTPPassword     =   ""
      FTPRestartAt    =   0
      FTPServerAddress=   ""
      FTPTransferTimeout=   1092
      FTPUserName     =   ""
   End
   Begin VB.ListBox lbxPortsFound 
      Height          =   2010
      ItemData        =   "ExWsScan.frx":0000
      Left            =   2160
      List            =   "ExWsScan.frx":0002
      TabIndex        =   8
      Top             =   1320
      Width           =   1815
   End
   Begin VB.Frame Frame1 
      Caption         =   " Ports to Scan "
      Height          =   2295
      Left            =   240
      TabIndex        =   2
      Top             =   1080
      Width           =   1575
      Begin VB.CommandButton cmdCancel 
         Caption         =   "Cancel"
         Height          =   400
         Left            =   240
         TabIndex        =   10
         Top             =   1680
         Width           =   1095
      End
      Begin VB.CommandButton cmdScan 
         Caption         =   "Scan"
         Height          =   400
         Left            =   240
         TabIndex        =   7
         Top             =   1200
         Width           =   1095
      End
      Begin VB.TextBox tbxToPort 
         Height          =   325
         Left            =   840
         TabIndex        =   6
         Text            =   "1024"
         Top             =   720
         Width           =   495
      End
      Begin VB.TextBox tbxFromPort 
         Height          =   325
         Left            =   840
         TabIndex        =   5
         Text            =   "1"
         Top             =   360
         Width           =   495
      End
      Begin VB.Label Label3 
         AutoSize        =   -1  'True
         Caption         =   "To"
         Height          =   195
         Left            =   240
         TabIndex        =   4
         Top             =   840
         Width           =   195
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         Caption         =   "From"
         Height          =   195
         Left            =   240
         TabIndex        =   3
         Top             =   480
         Width           =   345
      End
   End
   Begin VB.TextBox tbxAddress 
      Height          =   325
      Left            =   960
      TabIndex        =   1
      Top             =   480
      Width           =   3015
   End
   Begin VB.Label Label4 
      AutoSize        =   -1  'True
      Caption         =   "Ports Found"
      Height          =   195
      Left            =   2160
      TabIndex        =   9
      Top             =   1080
      Width           =   855
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Address"
      Height          =   195
      Left            =   240
      TabIndex        =   0
      Top             =   480
      Width           =   570
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim FromPort As Integer
Dim ToPort As Integer
Dim CurrentPort As Integer
Dim Cancelled As Boolean

Private Sub Apax1_OnWinsockConnect()
  lbxPortsFound.AddItem (Apax1.WinsockPort)
  Apax1.Close
End Sub

Private Sub Apax1_OnWinsockDisconnect()
  If (CurrentPort < ToPort) And Not Cancelled Then
    ScanPort (CurrentPort + 1)
  Else
    Caption = "Done"
  End If
End Sub

Private Sub Apax1_OnWinsockError(ByVal ErrCode As Long)
  Apax1.Close
End Sub

Private Sub cmdCancel_Click()
  Cancelled = True
End Sub

Private Sub cmdScan_Click()
  FromPort = CInt(tbxFromPort.Text)
  ToPort = CInt(tbxToPort.Text)
  Apax1.WinsockAddress = tbxAddress.Text
  Cancelled = False
  ScanPort (FromPort)
End Sub

Private Sub ScanPort(ByVal Port As Integer)
  CurrentPort = Port
  Apax1.WinsockPort = CStr(CurrentPort)
  Caption = "Scanning Port " + Apax1.WinsockPort
  Apax1.WinsockConnect
End Sub

