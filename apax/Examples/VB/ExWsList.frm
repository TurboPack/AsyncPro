VERSION 5.00
Object = "{797E7185-0DB7-4E3A-939B-234871F7FAC9}#1.0#0"; "Apax1.ocx"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   4665
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6105
   LinkTopic       =   "Form1"
   ScaleHeight     =   4665
   ScaleWidth      =   6105
   StartUpPosition =   3  'Windows Default
   Begin APAX1.Apax Apax1 
      Height          =   3375
      Left            =   0
      TabIndex        =   0
      Top             =   1200
      Width           =   6015
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
      WinsockAddress  =   "atlantis-bbs.com"
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
      Emulation       =   1
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
      Caption         =   "Apax v1.00 *1*"
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
   Begin VB.CommandButton cmdDisconnect 
      Caption         =   "Disconnect"
      Height          =   255
      Left            =   2040
      TabIndex        =   4
      Top             =   120
      Width           =   1455
   End
   Begin VB.CommandButton cmdConnect 
      Caption         =   "Connect"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   1455
   End
   Begin VB.ComboBox cbDest 
      Height          =   315
      ItemData        =   "ExWsList.frx":0000
      Left            =   1200
      List            =   "ExWsList.frx":0685
      TabIndex        =   1
      Text            =   "A Clockwork Online (clockwork.com)"
      Top             =   720
      Width           =   4935
   End
   Begin VB.Label Label1 
      Caption         =   "Destination"
      Height          =   255
      Left            =   0
      TabIndex        =   2
      Top             =   720
      Width           =   1095
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

' ComboBox list under cbDest is just for telnet examples and TurboPower
' Software Company does not claim responsibility for those sites working
' or the content of those sites.  Please change or update the list
' accordingly. When this was written, there was a Telnet list guide:
' http://www.thedirectory.org/telnet/brieflst.htm

Private Sub Apax1_OnWinsockConnect()
  Caption = "Connected"
  Apax1.TerminalSetFocus
End Sub

Private Sub cmdConnect_Click()
Dim StartAt As Integer  'Starts destination address
Dim StopAt As Integer   'End of destination address
Dim I As Integer        'Position of string
Dim Temp As String      'Temporary string

  StartAt = InStr(1, cbDest.Text, "(") + 1
  StopAt = InStr(StartAt, cbDest.Text, ")") - 1
  If (StartAt > 0) And (StopAt > 0) And (StopAt > StartAt) Then
    I = StopAt - StartAt
    Temp = Right$(cbDest.Text, I + 1)
    Temp = Left$(Temp, I)
    Apax1.WinsockAddress = Temp
  Else
    Apax1.WinsockAddress = cbDest.Text
  End If
  Apax1.WinsockConnect

End Sub

Private Sub cmdDisconnect_Click()
  Apax1.Close
End Sub
