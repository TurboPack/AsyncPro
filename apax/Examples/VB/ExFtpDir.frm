VERSION 5.00
Object = "{797E7185-0DB7-4E3A-939B-234871F7FAC9}#1.11#0"; "Apax1.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   6855
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9060
   LinkTopic       =   "Form1"
   ScaleHeight     =   6855
   ScaleWidth      =   9060
   StartUpPosition =   3  'Windows Default
   Begin APAX1.Apax Apax1 
      Height          =   375
      Left            =   0
      TabIndex        =   9
      Top             =   6240
      Width           =   1575
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
         Size            =   7.5
         Charset         =   128
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
      Caption         =   "APAX 1.11"
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
      FTPConnectTimeout=   1
      FTPFileType     =   1
      FTPPassword     =   ""
      FTPRestartAt    =   0
      FTPServerAddress=   ""
      FTPTransferTimeout=   1092
      FTPUserName     =   ""
   End
   Begin VB.CommandButton btnUpload 
      Caption         =   "Upload..."
      Enabled         =   0   'False
      Height          =   495
      Left            =   5880
      TabIndex        =   14
      Top             =   1440
      Width           =   1215
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   7560
      Top             =   240
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      CancelError     =   -1  'True
   End
   Begin VB.ListBox List2 
      Height          =   4350
      ItemData        =   "ExFtpDir.frx":0000
      Left            =   5520
      List            =   "ExFtpDir.frx":0002
      TabIndex        =   12
      Top             =   2280
      Width           =   3255
   End
   Begin VB.CommandButton btnLogout 
      Caption         =   "Logout"
      Height          =   495
      Left            =   5880
      TabIndex        =   11
      Top             =   720
      Width           =   1215
   End
   Begin VB.CommandButton btnLogin 
      Caption         =   "Login"
      Height          =   495
      Left            =   5880
      TabIndex        =   10
      Top             =   120
      Width           =   1215
   End
   Begin VB.ListBox List1 
      Height          =   4740
      ItemData        =   "ExFtpDir.frx":0004
      Left            =   1600
      List            =   "ExFtpDir.frx":0006
      TabIndex        =   7
      Top             =   1920
      Width           =   3600
   End
   Begin VB.TextBox txtPassword 
      Height          =   300
      IMEMode         =   3  'DISABLE
      Left            =   1600
      PasswordChar    =   "*"
      TabIndex        =   5
      Top             =   1080
      Width           =   3600
   End
   Begin VB.TextBox txtUsername 
      Height          =   300
      Left            =   1600
      TabIndex        =   4
      Text            =   "ANONYMOUS"
      Top             =   600
      Width           =   3600
   End
   Begin VB.TextBox txtServerAddress 
      Height          =   300
      Left            =   1600
      TabIndex        =   3
      Text            =   "FTP.TURBOPOWER.COM"
      Top             =   120
      Width           =   3600
   End
   Begin VB.Label Label6 
      Caption         =   "FTP status:"
      Height          =   255
      Left            =   5520
      TabIndex        =   13
      Top             =   2040
      Width           =   1695
   End
   Begin VB.Label Label5 
      Alignment       =   2  'Center
      Caption         =   "(Double-click an item to select)"
      Height          =   255
      Left            =   1600
      TabIndex        =   8
      Top             =   1680
      Width           =   3615
   End
   Begin VB.Label Label4 
      Caption         =   "Current Directory:"
      Height          =   255
      Left            =   240
      TabIndex        =   6
      Top             =   1920
      Width           =   1335
   End
   Begin VB.Label Label3 
      Caption         =   "Password:"
      Height          =   300
      Left            =   240
      TabIndex        =   2
      Top             =   1130
      Width           =   1215
   End
   Begin VB.Label Label2 
      Caption         =   "User name:"
      Height          =   300
      Left            =   240
      TabIndex        =   1
      Top             =   650
      Width           =   1215
   End
   Begin VB.Label Label1 
      Caption         =   "FTP Server URL:"
      Height          =   300
      Left            =   240
      TabIndex        =   0
      Top             =   200
      Width           =   1575
   End
   Begin VB.Menu mnuPopup 
      Caption         =   "Popup"
      Visible         =   0   'False
      Begin VB.Menu mnuOpenRetrieve 
         Caption         =   "Open/Retrieve"
      End
      Begin VB.Menu mnuUploadStore 
         Caption         =   "Upload/Store"
      End
      Begin VB.Menu mnuSeparator 
         Caption         =   "-"
      End
      Begin VB.Menu mnuStatus 
         Caption         =   "Status"
      End
      Begin VB.Menu mnuDelete 
         Caption         =   "Delete"
      End
      Begin VB.Menu mnuHelp 
         Caption         =   "Help..."
      End
      Begin VB.Menu mnuMakeDir 
         Caption         =   "Make dir..."
      End
      Begin VB.Menu mnuRename 
         Caption         =   "Rename..."
      End
      Begin VB.Menu mnuSendFTPCommand 
         Caption         =   "Send FTP command..."
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim SelectedItem As String
Private Sub ParseDirList(ByVal DirList As String)
  ' takes the dir list returned by ListDir and parses it for display in List
  Dim S As String
  If Len(DirList) > 0 Then
    List1.Clear
    ' FTP doesn't give us . or .., we'll add them ourselves
    List1.AddItem (".")
    List1.AddItem ("..")
    Dim I As Integer
    ' also, the dir list is a single <CR><LF> delimited string, we'll walk the
    ' string to break it up into separate lines
    For I = 1 To Len(DirList)
      If Mid(DirList, I, 1) = Chr(13) Then
        List1.AddItem (S)
        S = ""
      ElseIf Mid(DirList, I, 1) <> Chr(10) Then
        S = S & Mid(DirList, I, 1)
      End If
    Next I
  End If
End Sub

Private Sub Apax1_OnFTPError(ByVal ErrorCode As Long, ByVal ErrorText As String)
  ' we received an FTP error response.  We're expecting a 550 error when we
  ' double-click a file in List1
  If ErrorCode = 550 Then
    List2.AddItem ("Selection not a dir, must be a file")
  Else
    List2.AddItem ("FTP Error: " & ErrorText)
  End If
End Sub

Private Sub Apax1_OnFTPLog(ByVal LogCode As Apax1.TxFTPLogCode)
  Dim S As String
  Select Case LogCode
    Case lcClose
      S = "Disconnected"
    Case lcOpen
      S = "Connected to " & Apax1.FTPServerAddress
    Case lcComplete
      S = "Transfer complete. " & Apax1.FTPBytesTransferred & " bytes transferred."
    Case lcLogin
      S = Apax1.FTPUserName & " logged in"
      btnUpload.Enabled = True
    Case lcLogout
      S = Apax1.FTPUserName & " logged out"
      List1.Clear
      btnUpload.Enabled = False
    Case lcReceive
      S = "Downloading " + SelectedItem
    Case lcRename
      S = "Renaming " + SelectedItem
    Case lcRestart
      S = "Attempting re-transfer at " & Apax1.FTPRestartAt & " bytes"
    Case lcStore
      S = "Uploading " + SelectedItem
    Case lcTimeout
      S = "Transfer timed out"
    Case lcUserAbort
      S = "Transfer aborted by user"
    Case lcDelete
      S = "File deleted"
    Case Else
      S = "Unknown LogCode: " & LogCode
  End Select
  List2.AddItem ("FTPLog: " & S)
End Sub

Private Sub Apax1_OnFTPStatus(ByVal StatusCode As Apax1.TxFTPStatusCode, ByVal InfoText As String)
  If StatusCode = scProgress Then
    Dim S As String
    S = "Status: " & Apax1.FTPBytesTransferred & "/"
    ' FTPFileLength is only known if we're transmitting (Store), not when
    ' we are receiving (Retrieve). The only way to get the file length of
    ' a remote file is to get a full dir list or use Status, but the format
    ' of the response is not consistent across FTP servers
    If Apax1.FTPFileLength = 0 Then
      S = S & "???"
    Else
      S = S & Apax1.FTPFileLength
    End If
    List2.List(List2.ListCount - 1) = S
  End If
End Sub

Private Sub btnLogin_Click()
  ' set up the APAX FTP properties and log into the FTP server
  Apax1.FTPServerAddress = txtServerAddress.Text
  Apax1.FTPUserName = txtUsername.Text
  Apax1.FTPPassword = txtPassword.Text
  List2.AddItem ("Logging in")
  If Apax1.FTPLogIn = False Then
    MsgBox "Couldn't log in"
  Else
    Dim S As String
    S = Apax1.FTPListDir("", False)
    Call ParseDirList(S)
  End If
End Sub

Private Sub btnLogout_Click()
  ' terminate the FTP session by logging out
  On Error Resume Next
  Apax1.FTPLogOut
End Sub

Private Sub btnUpload_Click()
  ' select a file and upload it to the FTP server's current directory
  CommonDialog1.FileName = ""
  On Error GoTo ErrHandler
  CommonDialog1.ShowOpen
  If Apax1.FTPStore(CommonDialog1.FileTitle, CommonDialog1.FileName, smReplace) Then
    MsgBox ("Transfer complete")
  Else
    MsgBox ("Couldn't upload " & CommonDialog1.FileTitle)
  End If
ErrHandler:
  ' Open dialog cancelled
  Exit Sub
End Sub

Private Sub List1_DblClick()
  ' try to change the FTP server's directory, if we can't it's because the
  ' item we double-clicked isn't a dir, most likely it's a file so we'll
  ' download it
  If Apax1.FTPChangeDir(List1.Text) Then
    ' this was a directory, list it
    Caption = txtServerAddress.Text & Apax1.FTPCurrentDir
    Dim S As String
    S = Apax1.FTPListDir("", False)
    ParseDirList (S)
  Else
    ' this was not a directory, retrieve it
    CommonDialog1.CancelError = True
    On Error GoTo ErrHandler
    CommonDialog1.FileName = List1.Text
    CommonDialog1.ShowSave
    If Apax1.FTPRetrieve(List1.Text, CommonDialog1.FileName, rmReplace) Then
      MsgBox ("Transfer complete")
    Else
      MsgBox ("Couldn't save " & List1.Text)
    End If
  End If
ErrHandler:
  ' save dialog cancelled
  Exit Sub
End Sub

Private Sub List1_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
  If Button = vbRightButton Then
    Call PopupMenu(mnuPopup)
  End If
End Sub

Private Sub mnuDelete_Click()
  If Apax1.FTPDelete(List1.Text) Then
    Dim S As String
    S = Apax1.FTPListDir("", False)
    ParseDirList (S)
  Else
    MsgBox ("Couldn't delete " & List1.Text)
  End If
End Sub

Private Sub mnuHelp_Click()
  Dim S As String
  S = ""
  S = InputBox("Enter command to get help for (empty string returns a list of supported commands", "Get help", S)
  S = Apax1.FTPHelp(S)
  MsgBox (S)
End Sub

Private Sub mnuMakeDir_Click()
  Dim S As String
  S = InputBox("Enter directory name to create (blank dir cancels)")
  If Len(S) > 0 Then
    If Apax1.FTPMakeDir(S) Then
      MsgBox ("Directory created")
      S = Apax1.FTPListDir("", False)
      ParseDirList (S)
    Else
      MsgBox ("Couldn't make " & S)
    End If
  End If
End Sub

Private Sub mnuOpenRetrieve_Click()
  List1_DblClick
End Sub

Private Sub mnuRename_Click()
  Dim S As String
  S = InputBox("Enter new name", "Rename", List1.Text)
  If Len(S) > 0 Then
    If Apax1.FTPRename(List1.Text, S) Then
      S = Apax1.FTPListDir("", False)
      ParseDirList (S)
    Else
      MsgBox (List1.Text & " couldn't be renamed to " & S)
    End If
  End If
End Sub

Private Sub mnuSendFTPCommand_Click()
  Dim S As String
  S = InputBox("Enter command to send")
  If Len(S) > 0 Then
    MsgBox ("You sent: " & S & Chr(13) & Chr(10) & "Server replied: " & Chr(13) & Chr10) & Apax1.FTPSendFTPCommand(S)
  End If
End Sub

Private Sub mnuStatus_Click()
  Dim S As String
  S = Apax1.FTPStatus(List1.Text)
  If Len(S) > 0 Then
    MsgBox (S)
  Else
    MsgBox ("Couldn't get status for " & List1.Text)
  End If
  
End Sub

Private Sub mnuUploadStore_Click()
  btnUpload_Click
End Sub


