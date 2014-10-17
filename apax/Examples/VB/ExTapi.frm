VERSION 5.00
Object = "{797E7185-0DB7-4E3A-939B-234871F7FAC9}#1.0#0"; "apax1.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   Caption         =   "Apax VB Example"
   ClientHeight    =   6225
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9195
   LinkTopic       =   "Form1"
   ScaleHeight     =   6225
   ScaleWidth      =   9195
   StartUpPosition =   3  'Windows Default
   Begin MSComDlg.CommonDialog dlgWavFiles 
      Left            =   4320
      Top             =   5520
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      Filter          =   "Wave  (*.wav)|*.wav"
   End
   Begin VB.ListBox lstTapiStatus 
      Height          =   5715
      ItemData        =   "ExTapi.frx":0000
      Left            =   5040
      List            =   "ExTapi.frx":0002
      TabIndex        =   25
      Top             =   360
      Width           =   3975
   End
   Begin VB.Frame Frame3 
      Caption         =   " Wav Files "
      Height          =   2055
      Left            =   120
      TabIndex        =   17
      Top             =   4080
      Width           =   4815
      Begin VB.CheckBox chkOverwrite 
         Caption         =   "Overwrite"
         Height          =   495
         Left            =   3000
         TabIndex        =   24
         Top             =   960
         Width           =   1215
      End
      Begin VB.CommandButton cmdStop 
         Caption         =   "Stop"
         Height          =   425
         Left            =   1680
         TabIndex        =   23
         Top             =   1440
         Width           =   1140
      End
      Begin VB.CommandButton cmdRecord 
         Caption         =   "Record..."
         Height          =   425
         Left            =   1680
         TabIndex        =   22
         Top             =   960
         Width           =   1140
      End
      Begin VB.CommandButton cmdDTMF 
         Caption         =   "DTMF..."
         Height          =   425
         Left            =   360
         TabIndex        =   21
         Top             =   1440
         Width           =   1140
      End
      Begin VB.CommandButton cmdPlay 
         Caption         =   "Play..."
         Height          =   425
         Left            =   360
         TabIndex        =   20
         Top             =   960
         Width           =   1140
      End
      Begin VB.TextBox txtWavDirectory 
         Height          =   375
         Left            =   1560
         TabIndex        =   19
         Text            =   "\apax\examples"
         Top             =   360
         Width           =   2895
      End
      Begin VB.Label Label7 
         AutoSize        =   -1  'True
         Caption         =   "Wav Directory"
         Height          =   195
         Left            =   360
         TabIndex        =   18
         Top             =   420
         Width           =   1020
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   " Tapi device properties "
      Height          =   2295
      Left            =   120
      TabIndex        =   7
      Top             =   1680
      Width           =   4815
      Begin VB.TextBox txtSilenceThreshold 
         Height          =   285
         Left            =   4080
         TabIndex        =   32
         Text            =   "0"
         Top             =   1080
         Width           =   495
      End
      Begin VB.TextBox txtTrimSeconds 
         Height          =   285
         Left            =   4080
         TabIndex        =   31
         Text            =   "0"
         Top             =   720
         Width           =   495
      End
      Begin VB.TextBox txtMaxMessageLength 
         Height          =   285
         Left            =   4080
         TabIndex        =   30
         Text            =   "0"
         Top             =   360
         Width           =   495
      End
      Begin VB.TextBox txtRetryWait 
         Height          =   285
         Left            =   1560
         TabIndex        =   29
         Text            =   "0"
         Top             =   1080
         Width           =   495
      End
      Begin VB.TextBox txtMaxAttempts 
         Height          =   285
         Left            =   1560
         TabIndex        =   28
         Text            =   "0"
         Top             =   720
         Width           =   495
      End
      Begin VB.TextBox txtAnswerOnRing 
         Height          =   285
         Left            =   1560
         TabIndex        =   27
         Text            =   "0"
         Top             =   360
         Width           =   495
      End
      Begin VB.CheckBox chkUseSoundCard 
         Alignment       =   1  'Right Justify
         Caption         =   "UseSoundCard"
         Height          =   495
         Left            =   2280
         TabIndex        =   16
         Top             =   1440
         Width           =   1455
      End
      Begin VB.CheckBox chkInterruptWave 
         Alignment       =   1  'Right Justify
         Caption         =   "InterruptWave"
         Height          =   400
         Left            =   600
         TabIndex        =   15
         Top             =   1800
         Width           =   1455
      End
      Begin VB.CheckBox chkEnableVoice 
         Alignment       =   1  'Right Justify
         Caption         =   "EnableVoice"
         Height          =   495
         Left            =   600
         TabIndex        =   14
         Top             =   1440
         Width           =   1455
      End
      Begin VB.Label Label6 
         AutoSize        =   -1  'True
         Caption         =   "SilenceThreshold"
         Height          =   195
         Left            =   2400
         TabIndex        =   13
         Top             =   1080
         Width           =   1230
      End
      Begin VB.Label Label5 
         AutoSize        =   -1  'True
         Caption         =   "TrimSeconds"
         Height          =   195
         Left            =   2400
         TabIndex        =   12
         Top             =   720
         Width           =   930
      End
      Begin VB.Label Label4 
         AutoSize        =   -1  'True
         Caption         =   "MaxMessageLength"
         Height          =   195
         Left            =   2400
         TabIndex        =   11
         Top             =   360
         Width           =   1440
      End
      Begin VB.Label Label3 
         AutoSize        =   -1  'True
         Caption         =   "RetryWait"
         Height          =   195
         Left            =   360
         TabIndex        =   10
         Top             =   1080
         Width           =   705
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         Caption         =   "MaxAttempts"
         Height          =   195
         Left            =   360
         TabIndex        =   9
         Top             =   720
         Width           =   915
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "AnswerOnRing"
         Height          =   195
         Left            =   360
         TabIndex        =   8
         Top             =   360
         Width           =   1065
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   " Tapi device connection "
      Height          =   1455
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4815
      Begin Apax1.Apax Apax1 
         Height          =   615
         Left            =   4080
         TabIndex        =   33
         Top             =   240
         Visible         =   0   'False
         Width           =   615
         Baud            =   19200
         ComNumber       =   0
         DeviceType      =   1
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
         ShowStatusBar   =   0   'False
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
      Begin VB.CheckBox chkTapiStatusDisplay 
         Caption         =   "Show status dialog"
         Height          =   495
         Left            =   2880
         TabIndex        =   6
         Top             =   840
         Width           =   1695
      End
      Begin VB.CommandButton cmdCancel 
         Caption         =   "Cancel"
         Height          =   425
         Left            =   2760
         TabIndex        =   5
         Top             =   360
         Width           =   1140
      End
      Begin VB.CommandButton cmdDial 
         Caption         =   "Dial..."
         Height          =   425
         Left            =   1560
         TabIndex        =   4
         Top             =   360
         Width           =   1140
      End
      Begin VB.CommandButton cmdAnswer 
         Caption         =   "Answer"
         Height          =   425
         Left            =   360
         TabIndex        =   3
         Top             =   360
         Width           =   1140
      End
      Begin VB.CommandButton cmdConfig 
         Caption         =   "Config..."
         Height          =   425
         Left            =   1560
         TabIndex        =   2
         Top             =   840
         Width           =   1140
      End
      Begin VB.CommandButton cmdSelect 
         Caption         =   "Select..."
         Height          =   425
         Left            =   360
         TabIndex        =   1
         Top             =   840
         Width           =   1140
      End
   End
   Begin VB.Label Label8 
      AutoSize        =   -1  'True
      Caption         =   "Tapi status"
      Height          =   195
      Left            =   5160
      TabIndex        =   26
      Top             =   120
      Width           =   780
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Add(ByVal S As String)
  lstTapiStatus.AddItem (S)
  If lstTapiStatus.ListCount > 10 Then
    lstTapiStatus.ListIndex = lstTapiStatus.ListCount - 1
  End If
End Sub

Private Function TapiStateStr(State As TxTapiState) As String
  Dim S As String
  Select Case State
    Case tsIdle:               S = "tsIdle"
    Case tsOffering:           S = "tsOffering"
    Case tsAccepted:           S = "tsAccepted"
    Case tsDialTone:           S = "tsDialTone"
    Case tsDialing:            S = "tsDialing"
    Case tsRingback:           S = "tsRingBack"
    Case tsBusy:               S = "tsBusy"
    Case tsSpecialInfo:        S = "tsSpecialInfo"
    Case tsConnected:          S = "tsConnected"
    Case tsProceeding:         S = "tsProceeding"
    Case tsOnHold:             S = "tsOnHold"
    Case tsConferenced:        S = "tsConferenced"
    Case tsOnHoldPendConf:     S = "tsOnHoldPendConf"
    Case tsOnHoldPendTransfer: S = "tsOnHoldPendTransfer"
    Case tsDisconnected:       S = "tsDisconnected"
    Case tsUnknown:            S = "tsUnknown"
  End Select
  TapiStateStr = "  TapiState: " & S & " (" & CStr(Apax1.TapiState) & ")"
End Function

Private Sub Apax1_OnTapiCallerID(ByVal ID As String, ByVal IDName As String)
  Add ("OnCallerID: ID = " & ID)
  Add ("          : IDName = " & IDName)
End Sub

Private Sub Apax1_OnTapiConnect()
  Add ("OnTapiConnect")
  Add (TapiStateStr(Apax1.TapiState))
  If Apax1.EnableVoice Then
    Apax1.TapiPlayWaveFile (txtWavDirectory.Text & "\greeting.wav")
  End If
End Sub

Private Sub Apax1_OnTapiDTMF(ByVal Digit As Byte, ByVal ErrorCode As Long)
  Add ("OnTapiDTMF: " & CStr(Digit - 48))
  Add (TapiStateStr(Apax1.TapiState))
End Sub

Private Sub Apax1_OnTapiFail()
  If Apax1.TapiCancelled Then
    Add ("OnTapiFail because we cancelled the call")
  Else
    Add ("OnTapiFail due to a real failure")
  End If
  Add ("  " & TapiStateStr(Apax1.TapiState))
End Sub

Private Sub Apax1_OnTapiGetNumber(PhoneNum As String)
  Dim S As String
  S = InputBox("Enter Phone Number", Caption)
  If (S <> "") Then
    PhoneNum = S
    Add ("OnTapiGetNumber - " & PhoneNum)
    Add (TapiStateStr(Apax1.TapiState))
  End If
End Sub

Private Sub Apax1_OnTapiPortClose()
  Add ("OnTapiPortClose")
  Add (TapiStateStr(Apax1.TapiState))
End Sub

Private Sub Apax1_OnTapiPortOpen()
  Add ("OnTapiPortOpen")
  Add (TapiStateStr(Apax1.TapiState))
End Sub

Private Sub Apax1_OnTapiStatus(ByVal First As Boolean, ByVal Last As Boolean, ByVal Device As Long, ByVal Message As Long, ByVal Param1 As Long, ByVal Param2 As Long, ByVal Param3 As Long)
  Add ("OnTapiStatus: " & Apax1.TapiStatusMsg(Message, Param1, Param2) & _
    ", (" & CStr(Message) & "), (" & CStr(Param1) & "), (" & CStr(Param2) & _
    "), (" & CStr(Param3) & ")")
  Add (TapiStateStr(Apax1.TapiState))
End Sub

Private Sub Apax1_OnTapiWaveNotify(ByVal Msg As Apax1.TxWaveMessage)
  Dim S As String
  Select Case Msg
    Case waPlayOpen: S = "waPlayOpen"
    Case waPlayDone: S = "waPlayDone"
    Case waPlayClose: S = "waPlayClose"
    Case waRecordOpen: S = "waRecordOpen"
    Case waDataReady: S = "waDataReady"
    Case waRecordClose: S = "waRecordClose"
  End Select
  Add ("OnTapiWaveNotify: " & S)
End Sub

Private Sub Apax1_OnTapiWaveSilence(StopRecording As Boolean, Hangup As Boolean)
  Add ("OnTapiWaveSilence")
End Sub

Private Sub chkEnableVoice_Click()
  Apax1.EnableVoice = CBool(chkEnableVoice.Value)
End Sub

Private Sub chkInterruptWave_Click()
  Apax1.InterruptWave = CBool(chkInterruptWave.Value)
End Sub

Private Sub chkTapiStatusDisplay_Click()
  Apax1.TapiStatusDisplay = CBool(chkTapiStatusDisplay.Value)
End Sub

Private Sub chkUseSoundCard_Click()
  Apax1.UseSoundCard = CBool(chkUseSoundCard.Value)
End Sub

Private Sub cmdAnswer_Click()
  Add ("Answer button clicked (" & Apax1.SelectedDevice & ")")
  Add (TapiStateStr(Apax1.TapiState))
  Apax1.TapiAnswer
End Sub

Private Sub cmdConfig_Click()
  Apax1.TapiShowConfigDialog (True)
  Add ("Config button click (" & Apax1.SelectedDevice & ")")
  Add (TapiStateStr(Apax1.TapiState))
End Sub

Private Sub cmdDial_Click()
  Add ("Dial button click (" & Apax1.SelectedDevice & ")")
  Add (TapiStateStr(Apax1.TapiState))
  Apax1.TapiDial
End Sub

Private Sub cmdDTMF_Click()
  Dim S As String
  S = InputBox("Enter digits to send", Caption)
  If (S <> "") Then
    Add ("SendTone(" & S & ")")
    Apax1.TapiSendTone (S)
  End If
End Sub

Private Sub cmdCancel_Click()
  Add ("Cancel button click")
  Add (TapiStateStr(Apax1.TapiState))
  Apax1.Close
End Sub

Private Sub cmdPlay_Click()
  dlgWavFiles.DialogTitle = "Select Wav File"
  dlgWavFiles.InitDir = txtWavDirectory.Text
  dlgWavFiles.ShowOpen
  Add ("Playing wave file (" & dlgWavFiles.FileName & ")")
  Apax1.TapiPlayWaveFile (dlgWavFiles.FileName)
End Sub

Private Sub cmdRecord_Click()
  dlgWavFiles.DialogTitle = "Record Wav File"
  dlgWavFiles.InitDir = txtWavDirectory.Text
  dlgWavFiles.ShowSave
  Add ("Recording wave file (" & dlgWavFiles.FileName & ")")
  Apax1.TapiRecordWaveFile dlgWavFiles.FileName, Overwrite = chkOverwrite.Value
End Sub

Private Sub cmdSelect_Click()
  Apax1.TapiSelectDevice
  Add ("SelectedDevice = " & Apax1.SelectedDevice)
End Sub

Private Sub cmdStop_Click()
  Apax1.TapiStopWaveFile
  Add ("Stopping wav file")
End Sub

Private Sub Form_Activate()
  Dim Test As Integer
  txtAnswerOnRing.Text = CStr(Apax1.AnswerOnRing)
  txtMaxAttempts.Text = CStr(Apax1.MaxAttempts)
  txtRetryWait.Text = CStr(Apax1.TapiRetryWait)
  txtMaxMessageLength.Text = CStr(Apax1.MaxMessageLength)
  txtTrimSeconds.Text = CStr(Apax1.TrimSeconds)
  txtSilenceThreshold.Text = CStr(Apax1.SilenceThreshold)
  chkEnableVoice.Value = Abs(Apax1.EnableVoice)
  chkInterruptWave.Value = Abs(Apax1.InterruptWave)
  chkUseSoundCard.Value = Abs(Apax1.UseSoundCard)
  chkTapiStatusDisplay.Value = Abs(Apax1.TapiStatusDisplay)
End Sub

Private Sub lstTapiStatus_DblClick()
  lstTapiStatus.Clear
End Sub

Private Sub txtAnswerOnRing_Change()
  Apax1.AnswerOnRing = Val(txtAnswerOnRing.Text)
End Sub

Private Sub txtMaxAttempts_Change()
  Apax1.MaxAttempts = Val(txtMaxAttempts.Text)
End Sub

Private Sub txtMaxMessageLength_Change()
  Apax1.MaxMessageLength = Val(txtMaxMessageLength.Text)
End Sub

Private Sub txtRetryWait_Change()
  Apax1.TapiRetryWait = Val(txtRetryWait.Text)
End Sub

Private Sub txtSilenceThreshold_Change()
  Apax1.SilenceThreshold = Val(txtSilenceThreshold.Text)
End Sub

Private Sub txtTrimSeconds_Change()
  Apax1.TrimSeconds = Val(txtTrimSeconds.Text)
End Sub
