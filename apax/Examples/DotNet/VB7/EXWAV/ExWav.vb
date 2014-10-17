Option Strict Off
Option Explicit On
Friend Class Form1
	Inherits System.Windows.Forms.Form
#Region "Windows Form Designer generated code "
	Public Sub New()
		MyBase.New()
		If m_vb6FormDefInstance Is Nothing Then
			If m_InitializingDefInstance Then
				m_vb6FormDefInstance = Me
			Else
				Try 
					'For the start-up form, the first instance created is the default instance.
					If System.Reflection.Assembly.GetExecutingAssembly.EntryPoint.DeclaringType Is Me.GetType Then
						m_vb6FormDefInstance = Me
					End If
				Catch
				End Try
			End If
		End If
		'This call is required by the Windows Form Designer.
		InitializeComponent()
	End Sub
	'Form overrides dispose to clean up the component list.
	Protected Overloads Overrides Sub Dispose(ByVal Disposing As Boolean)
		If Disposing Then
			If Not components Is Nothing Then
				components.Dispose()
			End If
		End If
		MyBase.Dispose(Disposing)
	End Sub
	'Required by the Windows Form Designer
	Private components As System.ComponentModel.IContainer
	Public ToolTip1 As System.Windows.Forms.ToolTip
	Public WithEvents Apax1 As AxAPAX1.AxApax
	Public WithEvents cmdHangup As System.Windows.Forms.Button
	Public WithEvents cmdAnswer As System.Windows.Forms.Button
	Public WithEvents dirExampleWav As Microsoft.VisualBasic.Compatibility.VB6.DirListBox
	Public WithEvents Label1 As System.Windows.Forms.Label
	Public WithEvents Frame1 As System.Windows.Forms.GroupBox
	Public WithEvents txtDigitsReceived As System.Windows.Forms.TextBox
	Public WithEvents cmdSendTone As System.Windows.Forms.Button
	Public WithEvents txtDigitsToSend As System.Windows.Forms.TextBox
	Public WithEvents Label4 As System.Windows.Forms.Label
	Public WithEvents Label3 As System.Windows.Forms.Label
	Public WithEvents fraDTMF As System.Windows.Forms.GroupBox
	Public WithEvents cmdStop As System.Windows.Forms.Button
	Public WithEvents chkOverwrite As System.Windows.Forms.CheckBox
	Public WithEvents cmdRecord As System.Windows.Forms.Button
	Public WithEvents cmdPlay As System.Windows.Forms.Button
	Public WithEvents cmdSelectWaveFile As System.Windows.Forms.Button
	Public WithEvents txtWavFile As System.Windows.Forms.TextBox
	Public WithEvents dlgSelectWavFile As AxMSComDlg.AxCommonDialog
	Public WithEvents Label2 As System.Windows.Forms.Label
	Public WithEvents fraWavFile As System.Windows.Forms.GroupBox
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(Form1))
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.Frame1 = New System.Windows.Forms.GroupBox()
        Me.Apax1 = New AxAPAX1.AxApax()
        Me.cmdHangup = New System.Windows.Forms.Button()
        Me.cmdAnswer = New System.Windows.Forms.Button()
        Me.dirExampleWav = New Microsoft.VisualBasic.Compatibility.VB6.DirListBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.fraDTMF = New System.Windows.Forms.GroupBox()
        Me.txtDigitsReceived = New System.Windows.Forms.TextBox()
        Me.cmdSendTone = New System.Windows.Forms.Button()
        Me.txtDigitsToSend = New System.Windows.Forms.TextBox()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.fraWavFile = New System.Windows.Forms.GroupBox()
        Me.cmdStop = New System.Windows.Forms.Button()
        Me.chkOverwrite = New System.Windows.Forms.CheckBox()
        Me.cmdRecord = New System.Windows.Forms.Button()
        Me.cmdPlay = New System.Windows.Forms.Button()
        Me.cmdSelectWaveFile = New System.Windows.Forms.Button()
        Me.txtWavFile = New System.Windows.Forms.TextBox()
        Me.dlgSelectWavFile = New AxMSComDlg.AxCommonDialog()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.Frame1.SuspendLayout()
        CType(Me.Apax1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.fraDTMF.SuspendLayout()
        Me.fraWavFile.SuspendLayout()
        CType(Me.dlgSelectWavFile, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'Frame1
        '
        Me.Frame1.BackColor = System.Drawing.SystemColors.Control
        Me.Frame1.Controls.AddRange(New System.Windows.Forms.Control() {Me.Apax1, Me.cmdHangup, Me.cmdAnswer, Me.dirExampleWav, Me.Label1})
        Me.Frame1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Frame1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Frame1.Location = New System.Drawing.Point(8, 8)
        Me.Frame1.Name = "Frame1"
        Me.Frame1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Frame1.Size = New System.Drawing.Size(329, 145)
        Me.Frame1.TabIndex = 14
        Me.Frame1.TabStop = False
        Me.Frame1.Text = " Tapi Connection "
        '
        'Apax1
        '
        Me.Apax1.ContainingControl = Me
        Me.Apax1.Location = New System.Drawing.Point(176, 56)
        Me.Apax1.Name = "Apax1"
        Me.Apax1.OcxState = CType(resources.GetObject("Apax1.OcxState"), System.Windows.Forms.AxHost.State)
        Me.Apax1.Size = New System.Drawing.Size(65, 49)
        Me.Apax1.TabIndex = 19
        Me.Apax1.Visible = False
        '
        'cmdHangup
        '
        Me.cmdHangup.BackColor = System.Drawing.SystemColors.Control
        Me.cmdHangup.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdHangup.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdHangup.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdHangup.Location = New System.Drawing.Point(216, 88)
        Me.cmdHangup.Name = "cmdHangup"
        Me.cmdHangup.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdHangup.Size = New System.Drawing.Size(81, 25)
        Me.cmdHangup.TabIndex = 18
        Me.cmdHangup.Text = "Hangup"
        '
        'cmdAnswer
        '
        Me.cmdAnswer.BackColor = System.Drawing.SystemColors.Control
        Me.cmdAnswer.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdAnswer.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdAnswer.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdAnswer.Location = New System.Drawing.Point(216, 48)
        Me.cmdAnswer.Name = "cmdAnswer"
        Me.cmdAnswer.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdAnswer.Size = New System.Drawing.Size(81, 25)
        Me.cmdAnswer.TabIndex = 17
        Me.cmdAnswer.Text = "Answer"
        '
        'dirExampleWav
        '
        Me.dirExampleWav.BackColor = System.Drawing.SystemColors.Window
        Me.dirExampleWav.Cursor = System.Windows.Forms.Cursors.Default
        Me.dirExampleWav.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.dirExampleWav.ForeColor = System.Drawing.SystemColors.WindowText
        Me.dirExampleWav.IntegralHeight = False
        Me.dirExampleWav.Location = New System.Drawing.Point(16, 40)
        Me.dirExampleWav.Name = "dirExampleWav"
        Me.dirExampleWav.Size = New System.Drawing.Size(153, 96)
        Me.dirExampleWav.TabIndex = 15
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.BackColor = System.Drawing.SystemColors.Control
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(16, 24)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(175, 13)
        Me.Label1.TabIndex = 16
        Me.Label1.Text = "First Select Example Wav directory"
        '
        'fraDTMF
        '
        Me.fraDTMF.BackColor = System.Drawing.SystemColors.Control
        Me.fraDTMF.Controls.AddRange(New System.Windows.Forms.Control() {Me.txtDigitsReceived, Me.cmdSendTone, Me.txtDigitsToSend, Me.Label4, Me.Label3})
        Me.fraDTMF.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.fraDTMF.ForeColor = System.Drawing.SystemColors.ControlText
        Me.fraDTMF.Location = New System.Drawing.Point(8, 296)
        Me.fraDTMF.Name = "fraDTMF"
        Me.fraDTMF.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.fraDTMF.Size = New System.Drawing.Size(329, 105)
        Me.fraDTMF.TabIndex = 8
        Me.fraDTMF.TabStop = False
        Me.fraDTMF.Text = " DTMF "
        '
        'txtDigitsReceived
        '
        Me.txtDigitsReceived.AcceptsReturn = True
        Me.txtDigitsReceived.AutoSize = False
        Me.txtDigitsReceived.BackColor = System.Drawing.SystemColors.Window
        Me.txtDigitsReceived.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDigitsReceived.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDigitsReceived.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDigitsReceived.Location = New System.Drawing.Point(112, 56)
        Me.txtDigitsReceived.MaxLength = 0
        Me.txtDigitsReceived.Name = "txtDigitsReceived"
        Me.txtDigitsReceived.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDigitsReceived.Size = New System.Drawing.Size(129, 25)
        Me.txtDigitsReceived.TabIndex = 13
        Me.txtDigitsReceived.Text = ""
        '
        'cmdSendTone
        '
        Me.cmdSendTone.BackColor = System.Drawing.SystemColors.Control
        Me.cmdSendTone.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdSendTone.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdSendTone.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdSendTone.Location = New System.Drawing.Point(256, 24)
        Me.cmdSendTone.Name = "cmdSendTone"
        Me.cmdSendTone.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdSendTone.Size = New System.Drawing.Size(57, 25)
        Me.cmdSendTone.TabIndex = 11
        Me.cmdSendTone.Text = "Send"
        '
        'txtDigitsToSend
        '
        Me.txtDigitsToSend.AcceptsReturn = True
        Me.txtDigitsToSend.AutoSize = False
        Me.txtDigitsToSend.BackColor = System.Drawing.SystemColors.Window
        Me.txtDigitsToSend.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDigitsToSend.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDigitsToSend.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDigitsToSend.Location = New System.Drawing.Point(112, 24)
        Me.txtDigitsToSend.MaxLength = 0
        Me.txtDigitsToSend.Name = "txtDigitsToSend"
        Me.txtDigitsToSend.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDigitsToSend.Size = New System.Drawing.Size(129, 25)
        Me.txtDigitsToSend.TabIndex = 10
        Me.txtDigitsToSend.Text = "0123456789#*"
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.BackColor = System.Drawing.SystemColors.Control
        Me.Label4.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label4.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label4.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label4.Location = New System.Drawing.Point(24, 64)
        Me.Label4.Name = "Label4"
        Me.Label4.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label4.Size = New System.Drawing.Size(80, 13)
        Me.Label4.TabIndex = 12
        Me.Label4.Text = "Digits Received"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.BackColor = System.Drawing.SystemColors.Control
        Me.Label3.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label3.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label3.Location = New System.Drawing.Point(24, 30)
        Me.Label3.Name = "Label3"
        Me.Label3.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label3.Size = New System.Drawing.Size(72, 13)
        Me.Label3.TabIndex = 9
        Me.Label3.Text = "Digits to Send"
        '
        'fraWavFile
        '
        Me.fraWavFile.BackColor = System.Drawing.SystemColors.Control
        Me.fraWavFile.Controls.AddRange(New System.Windows.Forms.Control() {Me.cmdStop, Me.chkOverwrite, Me.cmdRecord, Me.cmdPlay, Me.cmdSelectWaveFile, Me.txtWavFile, Me.dlgSelectWavFile, Me.Label2})
        Me.fraWavFile.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.fraWavFile.ForeColor = System.Drawing.SystemColors.ControlText
        Me.fraWavFile.Location = New System.Drawing.Point(8, 160)
        Me.fraWavFile.Name = "fraWavFile"
        Me.fraWavFile.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.fraWavFile.Size = New System.Drawing.Size(329, 129)
        Me.fraWavFile.TabIndex = 0
        Me.fraWavFile.TabStop = False
        Me.fraWavFile.Text = " Wav File "
        '
        'cmdStop
        '
        Me.cmdStop.BackColor = System.Drawing.SystemColors.Control
        Me.cmdStop.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdStop.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdStop.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdStop.Location = New System.Drawing.Point(240, 64)
        Me.cmdStop.Name = "cmdStop"
        Me.cmdStop.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdStop.Size = New System.Drawing.Size(57, 25)
        Me.cmdStop.TabIndex = 7
        Me.cmdStop.Text = "Stop"
        '
        'chkOverwrite
        '
        Me.chkOverwrite.BackColor = System.Drawing.SystemColors.Control
        Me.chkOverwrite.Checked = True
        Me.chkOverwrite.CheckState = System.Windows.Forms.CheckState.Checked
        Me.chkOverwrite.Cursor = System.Windows.Forms.Cursors.Default
        Me.chkOverwrite.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.chkOverwrite.ForeColor = System.Drawing.SystemColors.ControlText
        Me.chkOverwrite.Location = New System.Drawing.Point(136, 96)
        Me.chkOverwrite.Name = "chkOverwrite"
        Me.chkOverwrite.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.chkOverwrite.Size = New System.Drawing.Size(81, 17)
        Me.chkOverwrite.TabIndex = 6
        Me.chkOverwrite.Text = "Overwrite"
        '
        'cmdRecord
        '
        Me.cmdRecord.BackColor = System.Drawing.SystemColors.Control
        Me.cmdRecord.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdRecord.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdRecord.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdRecord.Location = New System.Drawing.Point(136, 64)
        Me.cmdRecord.Name = "cmdRecord"
        Me.cmdRecord.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdRecord.Size = New System.Drawing.Size(57, 25)
        Me.cmdRecord.TabIndex = 5
        Me.cmdRecord.Text = "Record"
        '
        'cmdPlay
        '
        Me.cmdPlay.BackColor = System.Drawing.SystemColors.Control
        Me.cmdPlay.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdPlay.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdPlay.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdPlay.Location = New System.Drawing.Point(32, 64)
        Me.cmdPlay.Name = "cmdPlay"
        Me.cmdPlay.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdPlay.Size = New System.Drawing.Size(57, 25)
        Me.cmdPlay.TabIndex = 4
        Me.cmdPlay.Text = "Play"
        '
        'cmdSelectWaveFile
        '
        Me.cmdSelectWaveFile.BackColor = System.Drawing.SystemColors.Control
        Me.cmdSelectWaveFile.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdSelectWaveFile.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdSelectWaveFile.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdSelectWaveFile.Location = New System.Drawing.Point(288, 24)
        Me.cmdSelectWaveFile.Name = "cmdSelectWaveFile"
        Me.cmdSelectWaveFile.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdSelectWaveFile.Size = New System.Drawing.Size(25, 25)
        Me.cmdSelectWaveFile.TabIndex = 3
        Me.cmdSelectWaveFile.Text = "..."
        '
        'txtWavFile
        '
        Me.txtWavFile.AcceptsReturn = True
        Me.txtWavFile.AutoSize = False
        Me.txtWavFile.BackColor = System.Drawing.SystemColors.Window
        Me.txtWavFile.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtWavFile.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtWavFile.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtWavFile.Location = New System.Drawing.Point(72, 24)
        Me.txtWavFile.MaxLength = 0
        Me.txtWavFile.Name = "txtWavFile"
        Me.txtWavFile.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtWavFile.Size = New System.Drawing.Size(209, 25)
        Me.txtWavFile.TabIndex = 2
        Me.txtWavFile.Text = ""
        '
        'dlgSelectWavFile
        '
        Me.dlgSelectWavFile.ContainingControl = Me
        Me.dlgSelectWavFile.Enabled = True
        Me.dlgSelectWavFile.Location = New System.Drawing.Point(200, 56)
        Me.dlgSelectWavFile.Name = "dlgSelectWavFile"
        Me.dlgSelectWavFile.OcxState = CType(resources.GetObject("dlgSelectWavFile.OcxState"), System.Windows.Forms.AxHost.State)
        Me.dlgSelectWavFile.Size = New System.Drawing.Size(32, 32)
        Me.dlgSelectWavFile.TabIndex = 8
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.BackColor = System.Drawing.SystemColors.Control
        Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label2.Location = New System.Drawing.Point(16, 30)
        Me.Label2.Name = "Label2"
        Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label2.Size = New System.Drawing.Size(51, 13)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "FileName"
        '
        'Form1
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(343, 412)
        Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.Frame1, Me.fraDTMF, Me.fraWavFile})
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Location = New System.Drawing.Point(4, 23)
        Me.Name = "Form1"
        Me.Text = "ExWav - Tapi Wav Files and DTMF Digits"
        Me.Frame1.ResumeLayout(False)
        CType(Me.Apax1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.fraDTMF.ResumeLayout(False)
        Me.fraWavFile.ResumeLayout(False)
        CType(Me.dlgSelectWavFile, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
#End Region 
#Region "Upgrade Support "
	Private Shared m_vb6FormDefInstance As Form1
	Private Shared m_InitializingDefInstance As Boolean
	Public Shared Property DefInstance() As Form1
		Get
			If m_vb6FormDefInstance Is Nothing OrElse m_vb6FormDefInstance.IsDisposed Then
				m_InitializingDefInstance = True
				m_vb6FormDefInstance = New Form1()
				m_InitializingDefInstance = False
			End If
			DefInstance = m_vb6FormDefInstance
		End Get
		Set
			m_vb6FormDefInstance = Value
		End Set
	End Property
#End Region 
	Dim ExampleWavDir As String
	Dim HangupPending As Boolean
	
    Private Sub Apax1_OnTapiWaveNotify(ByVal Msg As Apax1.TxWaveMessage)
        If HangupPending And (Msg = Apax1.WaveState) Then
            Apax1.Close()
            HangupPending = False
        End If
    End Sub

    Private Sub cmdAnswer_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdAnswer.Click
        Apax1.TapiSelectDevice()
        Apax1.EnableVoice = True
        Apax1.TapiAnswer()
    End Sub

    Private Sub cmdHangup_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdHangup.Click
        Apax1.Close()
    End Sub

    Private Sub cmdPlay_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdPlay.Click
        If txtWavFile.Text <> "" Then
            Apax1.TapiPlayWaveFile((txtWavFile.Text))
        End If
    End Sub

    Private Sub cmdRecord_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdRecord.Click
        If txtWavFile.Text <> "" Then
            Apax1.TapiRecordWaveFile(txtWavFile.Text, Overwrite:=CBool(chkOverwrite.CheckState))
        End If
    End Sub

    Private Sub cmdSelectWaveFile_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdSelectWaveFile.Click
        dlgSelectWavFile.ShowOpen()
        txtWavFile.Text = dlgSelectWavFile.FileName
    End Sub

    Private Sub cmdSendTone_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdSendTone.Click
        Apax1.TapiSendTone((txtDigitsToSend.Text))
    End Sub

    Private Sub cmdStop_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdStop.Click
        Apax1.TapiStopWaveFile()
    End Sub

    Private Sub Apax1_OnTapiConnect()
        ExampleWavDir = dirExampleWav.DirList(dirExampleWav.DirListIndex)
        Apax1.TapiPlayWaveFile((ExampleWavDir & "\greeting.wav"))
        fraWavFile.Enabled = True
        fraDTMF.Enabled = True
        HangupPending = False
    End Sub

    Private Sub Apax1_OnTapiDTMF(ByVal Digit As Byte, ByVal ErrorCode As Integer)
        Select Case Digit
            Case 35 '#
                Apax1.TapiPlayWaveFile((ExampleWavDir & "\Beep.wav"))
            Case 42 '*
                HangupPending = True
                Apax1.TapiPlayWaveFile((ExampleWavDir & "\Goodbye.wav"))
            Case 48 '0
                HangupPending = True
                Apax1.TapiPlayWaveFile((ExampleWavDir & "\Choice0.wav"))
            Case 49 '1
                Apax1.TapiPlayWaveFile((ExampleWavDir & "\Choice1.wav"))
            Case 50 '2
                Apax1.TapiPlayWaveFile(("E:\turbopower\apax\Examples" & "\Choice2.wav"))
            Case 51 '3
                Apax1.TapiPlayWaveFile((ExampleWavDir & "\Choice3.wav"))
            Case 52 '4
                Apax1.TapiPlayWaveFile((ExampleWavDir & "\Choice4.wav"))
            Case 53 '5
                Apax1.TapiPlayWaveFile((ExampleWavDir & "\Choice5.wav"))
            Case 54 '6
                Apax1.TapiPlayWaveFile((ExampleWavDir & "\Choice6.wav"))
            Case 55 '7
                Apax1.TapiPlayWaveFile((ExampleWavDir & "\Choice7.wav"))
            Case 56 '8
                Apax1.TapiPlayWaveFile((ExampleWavDir & "\Choice8.wav"))
            Case 57 '9
                Apax1.TapiPlayWaveFile((ExampleWavDir & "\Choice9.wav"))
        End Select
        txtDigitsReceived.Text = txtDigitsReceived.Text & Str(Digit - 48)
    End Sub

    Private Sub Apax1_OnTapiPortClose()
        fraWavFile.Enabled = False
        fraDTMF.Enabled = False
    End Sub

    Private Sub Apax1_OnTapiPortOpen(ByVal sender As Object, ByVal e As System.EventArgs) Handles Apax1.OnTapiPortOpen
        Text = "OnTapiPortOpen fired"
    End Sub
End Class