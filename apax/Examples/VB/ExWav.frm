VERSION 5.00
Object = "{797E7185-0DB7-4E3A-939B-234871F7FAC9}#1.11#0"; "apax1.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   Caption         =   "ExWav - Tapi Wav Files and DTMF Digits"
   ClientHeight    =   6180
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5145
   LinkTopic       =   "Form1"
   ScaleHeight     =   6180
   ScaleWidth      =   5145
   StartUpPosition =   3  'Windows Default
   Begin VB.DriveListBox Drive1 
      Height          =   315
      Left            =   360
      TabIndex        =   20
      Top             =   1800
      Width           =   2295
   End
   Begin VB.Frame Frame1 
      Caption         =   " Tapi Connection "
      Height          =   2175
      Left            =   120
      TabIndex        =   14
      Top             =   120
      Width           =   4935
      Begin APAX1.Apax Apax1 
         Height          =   300
         Left            =   3840
         TabIndex        =   19
         Top             =   120
         Width           =   1095
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
         Version         =   "1.11"
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
         Caption         =   "Apax v1.11"
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
         ShowConnectButtons=   0   'False
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
         FTPAccount      =   ""
         FTPConnectTimeout=   0
         FTPFileType     =   1
         FTPPassword     =   ""
         FTPRestartAt    =   0
         FTPServerAddress=   ""
         FTPTransferTimeout=   1092
         FTPUserName     =   ""
      End
      Begin VB.CommandButton cmdHangup 
         Caption         =   "Hangup"
         Enabled         =   0   'False
         Height          =   375
         Left            =   3240
         TabIndex        =   18
         Top             =   1320
         Width           =   1215
      End
      Begin VB.CommandButton cmdAnswer 
         Caption         =   "Answer"
         Enabled         =   0   'False
         Height          =   375
         Left            =   3240
         TabIndex        =   17
         Top             =   720
         Width           =   1215
      End
      Begin VB.DirListBox dirExampleWav 
         Height          =   1215
         Left            =   240
         TabIndex        =   15
         Top             =   480
         Width           =   2295
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "First Select Example Wav directory"
         Height          =   195
         Left            =   240
         TabIndex        =   16
         Top             =   240
         Width           =   2460
      End
   End
   Begin VB.Frame fraDTMF 
      Caption         =   " DTMF "
      Enabled         =   0   'False
      Height          =   1575
      Left            =   120
      TabIndex        =   8
      Top             =   4440
      Width           =   4935
      Begin VB.TextBox txtDigitsReceived 
         Height          =   375
         Left            =   1680
         TabIndex        =   13
         Top             =   840
         Width           =   1935
      End
      Begin VB.CommandButton cmdSendTone 
         Caption         =   "Send"
         Height          =   375
         Left            =   3840
         TabIndex        =   11
         Top             =   360
         Width           =   855
      End
      Begin VB.TextBox txtDigitsToSend 
         Height          =   375
         Left            =   1680
         TabIndex        =   10
         Text            =   "0123456789#*"
         Top             =   360
         Width           =   1935
      End
      Begin VB.Label Label4 
         AutoSize        =   -1  'True
         Caption         =   "Digits Received"
         Height          =   195
         Left            =   360
         TabIndex        =   12
         Top             =   960
         Width           =   1125
      End
      Begin VB.Label Label3 
         AutoSize        =   -1  'True
         Caption         =   "Digits to Send"
         Height          =   195
         Left            =   360
         TabIndex        =   9
         Top             =   450
         Width           =   990
      End
   End
   Begin VB.Frame fraWavFile 
      Caption         =   " Wav File "
      Enabled         =   0   'False
      Height          =   1935
      Left            =   120
      TabIndex        =   0
      Top             =   2400
      Width           =   4935
      Begin VB.CommandButton cmdStop 
         Caption         =   "Stop"
         Height          =   375
         Left            =   3600
         TabIndex        =   7
         Top             =   960
         Width           =   855
      End
      Begin VB.CheckBox chkOverwrite 
         Caption         =   "Overwrite"
         Height          =   255
         Left            =   2040
         TabIndex        =   6
         Top             =   1440
         Value           =   1  'Checked
         Width           =   1215
      End
      Begin VB.CommandButton cmdRecord 
         Caption         =   "Record"
         Height          =   375
         Left            =   2040
         TabIndex        =   5
         Top             =   960
         Width           =   855
      End
      Begin VB.CommandButton cmdPlay 
         Caption         =   "Play"
         Height          =   375
         Left            =   480
         TabIndex        =   4
         Top             =   960
         Width           =   855
      End
      Begin VB.CommandButton cmdSelectWaveFile 
         Caption         =   "..."
         Height          =   375
         Left            =   4320
         TabIndex        =   3
         Top             =   360
         Width           =   375
      End
      Begin VB.TextBox txtWavFile 
         Height          =   375
         Left            =   1080
         TabIndex        =   2
         Top             =   360
         Width           =   3135
      End
      Begin MSComDlg.CommonDialog dlgSelectWavFile 
         Left            =   3000
         Top             =   840
         _ExtentX        =   847
         _ExtentY        =   847
         _Version        =   393216
         CancelError     =   -1  'True
         DialogTitle     =   "Select Wav File"
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         Caption         =   "FileName"
         Height          =   195
         Left            =   240
         TabIndex        =   1
         Top             =   450
         Width           =   660
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim ExampleWavDir As String
Dim HangupPending As Boolean

Private Sub Apax1_OnTapiWaveNotify(ByVal Msg As Apax1.TxWaveMessage)
  If (Msg = waPlayDone) And HangupPending Then
    Apax1.Close
    HangupPending = False
  End If
End Sub

Private Sub cmdAnswer_Click()
  ' select the TAPI device and wait for calls
  Apax1.TapiSelectDevice
  Apax1.EnableVoice = True
  Apax1.TapiAnswer
End Sub

Private Sub cmdHangup_Click()
  ' hangup
  Apax1.Close
End Sub

Private Sub cmdPlay_Click()
  ' play a wave file, OnTapiWaveNotify will fire with Msg=waPlayDone when it's done playing
  If txtWavFile.Text <> "" Then
    Apax1.TapiPlayWaveFile (txtWavFile.Text)
  End If
End Sub

Private Sub cmdRecord_Click()
  If txtWavFile.Text <> "" Then
    Apax1.TapiRecordWaveFile txtWavFile.Text, Overwrite:=CBool(chkOverwrite.Value)
  End If
End Sub

Private Sub cmdSelectWaveFile_Click()
  dlgSelectWavFile.ShowOpen
  txtWavFile.Text = dlgSelectWavFile.FileName
End Sub

Private Sub cmdSendTone_Click()
  Apax1.TapiSendTone (txtDigitsToSend.Text)
End Sub

Private Sub cmdStop_Click()
  Apax1.TapiStopWaveFile
End Sub

Private Sub Apax1_OnTapiConnect()
  ' we're connected, play the greeting
  ExampleWavDir = dirExampleWav.List(dirExampleWav.ListIndex)
  Apax1.TapiPlayWaveFile (ExampleWavDir & "\greeting.wav")
  ' and enable the controls that require a connection
  fraWavFile.Enabled = True
  fraDTMF.Enabled = True
  HangupPending = False
End Sub

Private Sub Apax1_OnTapiDTMF(ByVal Digit As Byte, ByVal ErrorCode As Long)
  Select Case Digit
    Case 35:  '#
      Apax1.TapiPlayWaveFile (ExampleWavDir & "\Beep.wav")
    Case 42:  '*
      HangupPending = True
      Apax1.TapiPlayWaveFile (ExampleWavDir & "\Goodbye.wav")
    Case 48:  '0
      HangupPending = True
      Apax1.TapiPlayWaveFile (ExampleWavDir & "\Choice0.wav")
    Case 49:  '1
      Apax1.TapiPlayWaveFile (ExampleWavDir & "\Choice1.wav")
    Case 50:  '2
      Apax1.TapiPlayWaveFile (ExampleWavDir & "\Choice2.wav")
    Case 51:  '3
      Apax1.TapiPlayWaveFile (ExampleWavDir & "\Choice3.wav")
    Case 52:  '4
      Apax1.TapiPlayWaveFile (ExampleWavDir & "\Choice4.wav")
    Case 53:  '5
      Apax1.TapiPlayWaveFile (ExampleWavDir & "\Choice5.wav")
    Case 54:  '6
      Apax1.TapiPlayWaveFile (ExampleWavDir & "\Choice6.wav")
    Case 55:  '7
      Apax1.TapiPlayWaveFile (ExampleWavDir & "\Choice7.wav")
    Case 56:  '8
      Apax1.TapiPlayWaveFile (ExampleWavDir & "\Choice8.wav")
    Case 57:  '9
      Apax1.TapiPlayWaveFile (ExampleWavDir & "\Choice9.wav")
  End Select
  txtDigitsReceived.Text = txtDigitsReceived.Text & Str(Digit - 48)
End Sub

Private Sub Apax1_OnTapiPortClose()
  ' the connection has gone away, disable the controls that require a connection
  fraWavFile.Enabled = False
  fraDTMF.Enabled = False
End Sub

Private Sub dirExampleWav_Click()
  ' only enable the Answer button if we've selected the dir with the waves
  Dim PathName As String
  PathName = dirExampleWav.List(dirExampleWav.ListIndex) & "\greeting.wav"
  cmdAnswer.Enabled = (Dir$(PathName) <> "")
End Sub

Private Sub Drive1_Change()
  ' sync the DirListBox with the new drive
  dirExampleWav.Path = Drive1.Drive
End Sub

Private Sub Form_Load()
  ' force the DirListBox.Click event to check for the wave file
  dirExampleWav_Click
End Sub
