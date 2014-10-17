VERSION 5.00
Object = "{797E7185-0DB7-4E3A-939B-234871F7FAC9}#1.0#0"; "apax1.ocx"
Begin VB.Form Form1 
   Caption         =   "ExComm - Serial Comm Port Communications"
   ClientHeight    =   7575
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7695
   LinkTopic       =   "Form1"
   ScaleHeight     =   7575
   ScaleWidth      =   7695
   StartUpPosition =   3  'Windows Default
   Begin Apax1.Apax Apax1 
      Height          =   3495
      Left            =   120
      TabIndex        =   12
      Top             =   120
      Width           =   7455
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
      ShowToolBar     =   0   'False
      ShowDeviceSelButton=   -1  'True
      ShowConnectButtons=   -1  'True
      ShowProtocolButtons=   -1  'True
      ShowTerminalButtons=   -1  'True
      DoubleBuffered  =   0   'False
      Enabled         =   -1  'True
      Cursor          =   0
      TapiStatusDisplay=   0   'False
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
   Begin VB.ListBox lstReceived 
      Height          =   1815
      ItemData        =   "ExComm.frx":0000
      Left            =   120
      List            =   "ExComm.frx":0002
      TabIndex        =   10
      Top             =   5640
      Width           =   7455
   End
   Begin VB.Frame Frame2 
      Height          =   1575
      Left            =   2640
      TabIndex        =   5
      Top             =   3720
      Width           =   4935
      Begin VB.TextBox txtPut 
         Height          =   285
         Left            =   240
         TabIndex        =   9
         Text            =   "1234567890123456789012345678901234567890"
         Top             =   360
         Width           =   4335
      End
      Begin VB.CommandButton cmdPutData 
         Caption         =   "PutData"
         Height          =   375
         Left            =   3240
         TabIndex        =   8
         Top             =   960
         Width           =   1335
      End
      Begin VB.CommandButton cmdPutStringCRLF 
         Caption         =   "PutStringCRLF"
         Height          =   375
         Left            =   1800
         TabIndex        =   7
         Top             =   960
         Width           =   1335
      End
      Begin VB.CommandButton cmdPutString 
         Caption         =   "PutString"
         Height          =   375
         Left            =   360
         TabIndex        =   6
         Top             =   960
         Width           =   1335
      End
   End
   Begin VB.Frame Frame1 
      Height          =   1575
      Left            =   120
      TabIndex        =   0
      Top             =   3720
      Width           =   2415
      Begin VB.CommandButton cmdClose 
         Caption         =   "Close"
         Height          =   375
         Left            =   1320
         TabIndex        =   4
         Top             =   960
         Width           =   975
      End
      Begin VB.CommandButton cmdOpen 
         Caption         =   "Open"
         Height          =   375
         Left            =   240
         TabIndex        =   3
         Top             =   960
         Width           =   975
      End
      Begin VB.TextBox txtComNumber 
         Height          =   285
         Left            =   1440
         TabIndex        =   1
         Text            =   "0"
         Top             =   360
         Width           =   615
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "ComNumber"
         Height          =   195
         Left            =   360
         TabIndex        =   2
         Top             =   360
         Width           =   870
      End
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      Caption         =   "OnRXD event data"
      Height          =   195
      Left            =   120
      TabIndex        =   11
      Top             =   5400
      Width           =   1365
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim DataBuffer() As Byte

Private Sub Apax1_OnRXD(ByVal Data As Variant)
  Dim i, S
  If IsArray(Data) Then
    For i = LBound(Data) To UBound(Data)
      S = S & " &H" & Hex(Data(i))
    Next
    lstReceived.AddItem (S)
  End If
End Sub

Private Sub cmdClose_Click()
  Apax1.Close
End Sub

Private Sub cmdOpen_Click()
  Apax1.ComNumber = CInt(txtComNumber.Text)
  Apax1.PortOpen
  txtComNumber.Text = CStr(Apax1.ComNumber)
End Sub

Private Sub cmdPutData_Click()
  Dim i, Count, S()
  Count = Len(txtPut.Text)
  ReDim S(Count)
  For i = 1 To Count
    S(i - 1) = GetChar(txtPut.Text, i)
  Next
  Apax1.PutData (S)
End Sub

Private Sub cmdPutString_Click()
  Apax1.PutString (txtPut.Text)
End Sub

Private Sub cmdPutStringCRLF_Click()
  Apax1.PutStringCRLF (txtPut.Text)
End Sub

Private Function GetChar(ByVal Str As String, ByVal Index As Integer) As Byte
  GetChar = Asc(Mid(Str, Index, 1))
End Function
  

