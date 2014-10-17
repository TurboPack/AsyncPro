VERSION 5.00
Object = "{797E7185-0DB7-4E3A-939B-234871F7FAC9}#1.0#0"; "apax1.ocx"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   6960
   ClientLeft      =   165
   ClientTop       =   450
   ClientWidth     =   6615
   LinkTopic       =   "Form1"
   ScaleHeight     =   6960
   ScaleWidth      =   6615
   StartUpPosition =   2  'CenterScreen
   Begin Apax1.Apax Apax1 
      Height          =   3495
      Left            =   240
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
   Begin VB.Frame Frame1 
      Caption         =   " Data Triggers "
      Height          =   3135
      Left            =   120
      TabIndex        =   0
      Top             =   3720
      Width           =   6375
      Begin VB.ListBox lstTriggersAssigned 
         Height          =   2205
         ItemData        =   "ExDataT1.frx":0000
         Left            =   240
         List            =   "ExDataT1.frx":0002
         TabIndex        =   4
         Top             =   600
         Width           =   2775
      End
      Begin VB.ListBox lstTriggersFired 
         Height          =   2205
         ItemData        =   "ExDataT1.frx":0004
         Left            =   3360
         List            =   "ExDataT1.frx":0006
         TabIndex        =   3
         ToolTipText     =   "Double-click to clear list"
         Top             =   600
         Width           =   2775
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         Caption         =   "Triggers Fired"
         Height          =   195
         Left            =   3480
         TabIndex        =   2
         Top             =   360
         Width           =   960
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "Triggers Assigned"
         Height          =   195
         Left            =   360
         TabIndex        =   1
         Top             =   360
         Width           =   1260
      End
   End
   Begin VB.Menu File1 
      Caption         =   "&File"
      Begin VB.Menu Exit1 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu DataTriggers1 
      Caption         =   "Data &Triggers"
      Begin VB.Menu AddTrigger1 
         Caption         =   "&Add Trigger..."
      End
      Begin VB.Menu DisableTrigger1 
         Caption         =   "&Disable Trigger"
      End
      Begin VB.Menu EnableTrigger1 
         Caption         =   "E&nable Trigger"
      End
      Begin VB.Menu RemoveTrigger1 
         Caption         =   "&Remove Trigger"
      End
      Begin VB.Menu mnuSeparator1 
         Caption         =   "-"
      End
      Begin VB.Menu Clear1 
         Caption         =   "&Clear"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub AddTrigger1_Click()
  Dim Index As Integer
  DlgAddTrigger.Show 1
  If DlgAddTrigger.ModalResult Then
    Index = Apax1.AddDataTrigger(DlgAddTrigger.TriggerString, _
                                 DlgAddTrigger.PacketSize, _
                                 DlgAddTrigger.Timeout, _
                                 DlgAddTrigger.IncludeStrings, _
                                 DlgAddTrigger.IgnoreCase)
    If (Index > -1) Then
      lstTriggersAssigned.AddItem (DlgAddTrigger.TriggerString)
    End If
  End If

End Sub

Private Sub Apax1_OnDataTrigger(ByVal Index As Long, ByVal Timeout As Boolean, ByVal Data As Variant, ByVal Size As Long, ReEnable As Boolean)
  lstTriggersFired.AddItem (lstTriggersAssigned.List(Index))
End Sub

Private Sub Apax1_OnPortOpen()
  Apax1.TerminalSetFocus
End Sub

Private Sub Clear1_Click()
  Apax1.RemoveAllDataTriggers
  lstTriggersAssigned.Clear
End Sub

Private Sub DisableTrigger1_Click()
  If (lstTriggersAssigned.ListIndex > -1) Then
    Apax1.DisableDataTrigger (lstTriggersAssigned.ListIndex)
  End If
End Sub

Private Sub EnableTrigger1_Click()
  If (lstTriggersAssigned.ListIndex > -1) Then
    Apax1.EnableDataTrigger (lstTriggersAssigned.ListIndex)
  End If
End Sub

Private Sub Exit1_Click()
  End
End Sub

Private Sub lstTriggersFired_DblClick()
  lstTriggersFired.Clear
End Sub

Private Sub RemoveTrigger1_Click()
  If (lstTriggersAssigned.ListIndex > -1) Then
    Apax1.RemoveDataTrigger (lstTriggersAssigned.ListIndex)
    lstTriggersAssigned.RemoveItem (lstTriggersAssigned.ListIndex)
  End If
End Sub
