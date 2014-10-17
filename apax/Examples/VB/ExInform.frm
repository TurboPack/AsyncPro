VERSION 5.00
Object = "{797E7185-0DB7-4E3A-939B-234871F7FAC9}#1.0#0"; "Apax1.ocx"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   5295
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4890
   LinkTopic       =   "Form1"
   ScaleHeight     =   5295
   ScaleWidth      =   4890
   StartUpPosition =   3  'Windows Default
   Begin APAX1.Apax Apax1 
      Height          =   135
      Left            =   120
      TabIndex        =   19
      Top             =   120
      Visible         =   0   'False
      Width           =   135
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
      Caption         =   "APAX v1.00"
      CaptionAlignment=   2
      CaptionWidth    =   100
      LightWidth      =   40
      LightsLitColor  =   255
      LightsNotLitColor=   8421376
      ShowLightCaptions=   -1  'True
      ShowLights      =   -1  'True
      ShowStatusBar   =   -1  'True
      ShowToolBar     =   -1  'True
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
   Begin VB.ComboBox Combo2 
      Height          =   315
      Left            =   2400
      TabIndex        =   16
      Top             =   4920
      Width           =   2415
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      Left            =   0
      TabIndex        =   15
      Top             =   4920
      Width           =   2415
   End
   Begin VB.Label Label9 
      Caption         =   "Serial Port Information"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   1
      Left            =   840
      TabIndex        =   20
      Top             =   4080
      Width           =   3135
   End
   Begin VB.Label Label10 
      Caption         =   "Serial ports available"
      Height          =   255
      Left            =   2520
      TabIndex        =   18
      Top             =   4560
      Width           =   2175
   End
   Begin VB.Label Label8 
      Caption         =   "Serial ports installed"
      Height          =   255
      Left            =   120
      TabIndex        =   17
      Top             =   4560
      Width           =   2055
   End
   Begin VB.Label lblMaxSockets 
      Caption         =   "lblMaxSockets"
      Height          =   255
      Left            =   2520
      TabIndex        =   14
      Top             =   3600
      Width           =   2175
   End
   Begin VB.Label lblSystemStatus 
      Caption         =   "lblSystemStatus"
      Height          =   255
      Left            =   2520
      TabIndex        =   13
      Top             =   3120
      Width           =   2175
   End
   Begin VB.Label lblDescription 
      Caption         =   "lblDescription"
      Height          =   255
      Left            =   2520
      TabIndex        =   12
      Top             =   2640
      Width           =   2175
   End
   Begin VB.Label Label7 
      Caption         =   "Max Sockets"
      Height          =   255
      Left            =   120
      TabIndex        =   11
      Top             =   3600
      Width           =   2055
   End
   Begin VB.Label Label6 
      Caption         =   "System Status"
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   3120
      Width           =   2055
   End
   Begin VB.Label Label5 
      Caption         =   "Description"
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   2640
      Width           =   2055
   End
   Begin VB.Label Label9 
      Caption         =   "Winsock Information"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   0
      Left            =   1080
      TabIndex        =   8
      Top             =   120
      Width           =   3135
   End
   Begin VB.Label lblHighVersion 
      Caption         =   "lblHighVersion"
      Height          =   255
      Left            =   2520
      TabIndex        =   7
      Top             =   2160
      Width           =   2175
   End
   Begin VB.Label lblVersion 
      Caption         =   "lblVersion"
      Height          =   255
      Left            =   2520
      TabIndex        =   6
      Top             =   1680
      Width           =   2175
   End
   Begin VB.Label lblLocalAddress 
      Caption         =   "lblLocalAddress"
      Height          =   255
      Left            =   2520
      TabIndex        =   5
      Top             =   1200
      Width           =   2175
   End
   Begin VB.Label lblLocalHost 
      Caption         =   "lblLocalHost"
      Height          =   255
      Left            =   2520
      TabIndex        =   4
      Top             =   720
      Width           =   2175
   End
   Begin VB.Label Label4 
      Caption         =   "High Version"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   2160
      Width           =   2055
   End
   Begin VB.Label Label3 
      Caption         =   "Version"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   1680
      Width           =   2055
   End
   Begin VB.Label Label2 
      Caption         =   "Local Address"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   1200
      Width           =   2055
   End
   Begin VB.Label Label1 
      Caption         =   "Local Host"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   720
      Width           =   2055
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Apax1_OnWinsockGetAddress(Address As String, Port As String)
  lblLocalAddress.Caption = LocalAddress
End Sub

Private Sub Form_Load()

  ' Display the local host and local address
  lblLocalHost.Caption = Apax1.WsLocalHostName
  lblLocalAddress.Caption = Apax1.WsLocalAddress
      
  ' Get the Winsock version number and translate it into a readable string
  lblVersion.Caption = Apax1.WsLocalVersion

  ' Do the same for the HighVersion property
  lblHighVersion.Caption = Apax1.WsLocalHighVersion

  ' Get a description from the Winsock DLL
  lblDescription.Caption = Apax1.WsLocalDescription

  ' Display the system status
  lblSystemStatus.Caption = Apax1.WsLocalSystemStatus

  ' Display the maximum number of suckets supported
  lblMaxSockets.Caption = Apax1.WsLocalMaxSockets
  
  ' List devices in Combo1
  ' List devices available in Combo2
  For i = 1 To 50
    If (Apax1.IsPortAvail(i) = True) Then
      Combo2.AddItem ("COM " & i)
    End If
    If Apax1.IsPortInstalled(i) = True Then
      Combo1.AddItem ("COM " & i)
    End If
  Next i
  
End Sub
