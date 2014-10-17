Option Strict Off
Option Explicit On
Friend Class Form1
    Inherits System.Windows.Forms.Form
    Dim IsInitializing As Boolean
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
	Public WithEvents dlgWavFiles As AxMSComDlg.AxCommonDialog
	Public WithEvents lstTapiStatus As System.Windows.Forms.ListBox
	Public WithEvents chkOverwrite As System.Windows.Forms.CheckBox
	Public WithEvents cmdStop As System.Windows.Forms.Button
	Public WithEvents cmdRecord As System.Windows.Forms.Button
	Public WithEvents cmdDTMF As System.Windows.Forms.Button
	Public WithEvents cmdPlay As System.Windows.Forms.Button
	Public WithEvents txtWavDirectory As System.Windows.Forms.TextBox
	Public WithEvents Label7 As System.Windows.Forms.Label
	Public WithEvents Frame3 As System.Windows.Forms.GroupBox
	Public WithEvents txtSilenceThreshold As System.Windows.Forms.TextBox
	Public WithEvents txtTrimSeconds As System.Windows.Forms.TextBox
	Public WithEvents txtMaxMessageLength As System.Windows.Forms.TextBox
	Public WithEvents txtRetryWait As System.Windows.Forms.TextBox
	Public WithEvents txtMaxAttempts As System.Windows.Forms.TextBox
	Public WithEvents txtAnswerOnRing As System.Windows.Forms.TextBox
	Public WithEvents chkUseSoundCard As System.Windows.Forms.CheckBox
	Public WithEvents chkInterruptWave As System.Windows.Forms.CheckBox
	Public WithEvents chkEnableVoice As System.Windows.Forms.CheckBox
	Public WithEvents Label6 As System.Windows.Forms.Label
	Public WithEvents Label5 As System.Windows.Forms.Label
	Public WithEvents Label4 As System.Windows.Forms.Label
	Public WithEvents Label3 As System.Windows.Forms.Label
	Public WithEvents Label2 As System.Windows.Forms.Label
	Public WithEvents Label1 As System.Windows.Forms.Label
	Public WithEvents Frame2 As System.Windows.Forms.GroupBox
	Public WithEvents Apax1 As AxAPAX1.AxApax
	Public WithEvents chkTapiStatusDisplay As System.Windows.Forms.CheckBox
	Public WithEvents cmdCancel As System.Windows.Forms.Button
	Public WithEvents cmdDial As System.Windows.Forms.Button
	Public WithEvents cmdAnswer As System.Windows.Forms.Button
	Public WithEvents cmdConfig As System.Windows.Forms.Button
	Public WithEvents cmdSelect As System.Windows.Forms.Button
	Public WithEvents Frame1 As System.Windows.Forms.GroupBox
	Public WithEvents Label8 As System.Windows.Forms.Label
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(Form1))
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.dlgWavFiles = New AxMSComDlg.AxCommonDialog()
        Me.lstTapiStatus = New System.Windows.Forms.ListBox()
        Me.Frame3 = New System.Windows.Forms.GroupBox()
        Me.chkOverwrite = New System.Windows.Forms.CheckBox()
        Me.cmdStop = New System.Windows.Forms.Button()
        Me.cmdRecord = New System.Windows.Forms.Button()
        Me.cmdDTMF = New System.Windows.Forms.Button()
        Me.cmdPlay = New System.Windows.Forms.Button()
        Me.txtWavDirectory = New System.Windows.Forms.TextBox()
        Me.Label7 = New System.Windows.Forms.Label()
        Me.Frame2 = New System.Windows.Forms.GroupBox()
        Me.txtSilenceThreshold = New System.Windows.Forms.TextBox()
        Me.txtTrimSeconds = New System.Windows.Forms.TextBox()
        Me.txtMaxMessageLength = New System.Windows.Forms.TextBox()
        Me.txtRetryWait = New System.Windows.Forms.TextBox()
        Me.txtMaxAttempts = New System.Windows.Forms.TextBox()
        Me.txtAnswerOnRing = New System.Windows.Forms.TextBox()
        Me.chkUseSoundCard = New System.Windows.Forms.CheckBox()
        Me.chkInterruptWave = New System.Windows.Forms.CheckBox()
        Me.chkEnableVoice = New System.Windows.Forms.CheckBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.Frame1 = New System.Windows.Forms.GroupBox()
        Me.Apax1 = New AxAPAX1.AxApax()
        Me.chkTapiStatusDisplay = New System.Windows.Forms.CheckBox()
        Me.cmdCancel = New System.Windows.Forms.Button()
        Me.cmdDial = New System.Windows.Forms.Button()
        Me.cmdAnswer = New System.Windows.Forms.Button()
        Me.cmdConfig = New System.Windows.Forms.Button()
        Me.cmdSelect = New System.Windows.Forms.Button()
        Me.Label8 = New System.Windows.Forms.Label()
        CType(Me.dlgWavFiles, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Frame3.SuspendLayout()
        Me.Frame2.SuspendLayout()
        Me.Frame1.SuspendLayout()
        CType(Me.Apax1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'dlgWavFiles
        '
        Me.dlgWavFiles.Enabled = True
        Me.dlgWavFiles.Location = New System.Drawing.Point(288, 368)
        Me.dlgWavFiles.Name = "dlgWavFiles"
        Me.dlgWavFiles.OcxState = CType(resources.GetObject("dlgWavFiles.OcxState"), System.Windows.Forms.AxHost.State)
        Me.dlgWavFiles.Size = New System.Drawing.Size(32, 32)
        Me.dlgWavFiles.TabIndex = 0
        '
        'lstTapiStatus
        '
        Me.lstTapiStatus.BackColor = System.Drawing.SystemColors.Window
        Me.lstTapiStatus.Cursor = System.Windows.Forms.Cursors.Default
        Me.lstTapiStatus.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lstTapiStatus.ForeColor = System.Drawing.SystemColors.WindowText
        Me.lstTapiStatus.ItemHeight = 14
        Me.lstTapiStatus.Location = New System.Drawing.Point(336, 24)
        Me.lstTapiStatus.Name = "lstTapiStatus"
        Me.lstTapiStatus.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lstTapiStatus.Size = New System.Drawing.Size(265, 382)
        Me.lstTapiStatus.TabIndex = 25
        '
        'Frame3
        '
        Me.Frame3.BackColor = System.Drawing.SystemColors.Control
        Me.Frame3.Controls.AddRange(New System.Windows.Forms.Control() {Me.chkOverwrite, Me.cmdStop, Me.cmdRecord, Me.cmdDTMF, Me.cmdPlay, Me.txtWavDirectory, Me.Label7})
        Me.Frame3.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Frame3.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Frame3.Location = New System.Drawing.Point(8, 272)
        Me.Frame3.Name = "Frame3"
        Me.Frame3.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Frame3.Size = New System.Drawing.Size(321, 137)
        Me.Frame3.TabIndex = 17
        Me.Frame3.TabStop = False
        Me.Frame3.Text = " Wav Files "
        '
        'chkOverwrite
        '
        Me.chkOverwrite.BackColor = System.Drawing.SystemColors.Control
        Me.chkOverwrite.Cursor = System.Windows.Forms.Cursors.Default
        Me.chkOverwrite.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.chkOverwrite.ForeColor = System.Drawing.SystemColors.ControlText
        Me.chkOverwrite.Location = New System.Drawing.Point(200, 64)
        Me.chkOverwrite.Name = "chkOverwrite"
        Me.chkOverwrite.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.chkOverwrite.Size = New System.Drawing.Size(81, 33)
        Me.chkOverwrite.TabIndex = 24
        Me.chkOverwrite.Text = "Overwrite"
        '
        'cmdStop
        '
        Me.cmdStop.BackColor = System.Drawing.SystemColors.Control
        Me.cmdStop.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdStop.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdStop.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdStop.Location = New System.Drawing.Point(112, 96)
        Me.cmdStop.Name = "cmdStop"
        Me.cmdStop.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdStop.Size = New System.Drawing.Size(76, 29)
        Me.cmdStop.TabIndex = 23
        Me.cmdStop.Text = "Stop"
        '
        'cmdRecord
        '
        Me.cmdRecord.BackColor = System.Drawing.SystemColors.Control
        Me.cmdRecord.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdRecord.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdRecord.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdRecord.Location = New System.Drawing.Point(112, 64)
        Me.cmdRecord.Name = "cmdRecord"
        Me.cmdRecord.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdRecord.Size = New System.Drawing.Size(76, 29)
        Me.cmdRecord.TabIndex = 22
        Me.cmdRecord.Text = "Record..."
        '
        'cmdDTMF
        '
        Me.cmdDTMF.BackColor = System.Drawing.SystemColors.Control
        Me.cmdDTMF.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdDTMF.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdDTMF.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdDTMF.Location = New System.Drawing.Point(24, 96)
        Me.cmdDTMF.Name = "cmdDTMF"
        Me.cmdDTMF.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdDTMF.Size = New System.Drawing.Size(76, 29)
        Me.cmdDTMF.TabIndex = 21
        Me.cmdDTMF.Text = "DTMF..."
        '
        'cmdPlay
        '
        Me.cmdPlay.BackColor = System.Drawing.SystemColors.Control
        Me.cmdPlay.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdPlay.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdPlay.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdPlay.Location = New System.Drawing.Point(24, 64)
        Me.cmdPlay.Name = "cmdPlay"
        Me.cmdPlay.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdPlay.Size = New System.Drawing.Size(76, 29)
        Me.cmdPlay.TabIndex = 20
        Me.cmdPlay.Text = "Play..."
        '
        'txtWavDirectory
        '
        Me.txtWavDirectory.AcceptsReturn = True
        Me.txtWavDirectory.AutoSize = False
        Me.txtWavDirectory.BackColor = System.Drawing.SystemColors.Window
        Me.txtWavDirectory.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtWavDirectory.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtWavDirectory.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtWavDirectory.Location = New System.Drawing.Point(104, 24)
        Me.txtWavDirectory.MaxLength = 0
        Me.txtWavDirectory.Name = "txtWavDirectory"
        Me.txtWavDirectory.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtWavDirectory.Size = New System.Drawing.Size(193, 25)
        Me.txtWavDirectory.TabIndex = 19
        Me.txtWavDirectory.Text = "\apax\examples"
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.BackColor = System.Drawing.SystemColors.Control
        Me.Label7.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label7.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label7.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label7.Location = New System.Drawing.Point(24, 28)
        Me.Label7.Name = "Label7"
        Me.Label7.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label7.Size = New System.Drawing.Size(73, 13)
        Me.Label7.TabIndex = 18
        Me.Label7.Text = "Wav Directory"
        '
        'Frame2
        '
        Me.Frame2.BackColor = System.Drawing.SystemColors.Control
        Me.Frame2.Controls.AddRange(New System.Windows.Forms.Control() {Me.txtSilenceThreshold, Me.txtTrimSeconds, Me.txtMaxMessageLength, Me.txtRetryWait, Me.txtMaxAttempts, Me.txtAnswerOnRing, Me.chkUseSoundCard, Me.chkInterruptWave, Me.chkEnableVoice, Me.Label6, Me.Label5, Me.Label4, Me.Label3, Me.Label2, Me.Label1})
        Me.Frame2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Frame2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Frame2.Location = New System.Drawing.Point(8, 112)
        Me.Frame2.Name = "Frame2"
        Me.Frame2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Frame2.Size = New System.Drawing.Size(321, 153)
        Me.Frame2.TabIndex = 7
        Me.Frame2.TabStop = False
        Me.Frame2.Text = " Tapi device properties "
        '
        'txtSilenceThreshold
        '
        Me.txtSilenceThreshold.AcceptsReturn = True
        Me.txtSilenceThreshold.AutoSize = False
        Me.txtSilenceThreshold.BackColor = System.Drawing.SystemColors.Window
        Me.txtSilenceThreshold.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtSilenceThreshold.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtSilenceThreshold.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtSilenceThreshold.Location = New System.Drawing.Point(272, 72)
        Me.txtSilenceThreshold.MaxLength = 0
        Me.txtSilenceThreshold.Name = "txtSilenceThreshold"
        Me.txtSilenceThreshold.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtSilenceThreshold.Size = New System.Drawing.Size(33, 19)
        Me.txtSilenceThreshold.TabIndex = 32
        Me.txtSilenceThreshold.Text = "0"
        '
        'txtTrimSeconds
        '
        Me.txtTrimSeconds.AcceptsReturn = True
        Me.txtTrimSeconds.AutoSize = False
        Me.txtTrimSeconds.BackColor = System.Drawing.SystemColors.Window
        Me.txtTrimSeconds.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtTrimSeconds.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtTrimSeconds.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtTrimSeconds.Location = New System.Drawing.Point(272, 48)
        Me.txtTrimSeconds.MaxLength = 0
        Me.txtTrimSeconds.Name = "txtTrimSeconds"
        Me.txtTrimSeconds.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtTrimSeconds.Size = New System.Drawing.Size(33, 19)
        Me.txtTrimSeconds.TabIndex = 31
        Me.txtTrimSeconds.Text = "0"
        '
        'txtMaxMessageLength
        '
        Me.txtMaxMessageLength.AcceptsReturn = True
        Me.txtMaxMessageLength.AutoSize = False
        Me.txtMaxMessageLength.BackColor = System.Drawing.SystemColors.Window
        Me.txtMaxMessageLength.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtMaxMessageLength.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtMaxMessageLength.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtMaxMessageLength.Location = New System.Drawing.Point(272, 24)
        Me.txtMaxMessageLength.MaxLength = 0
        Me.txtMaxMessageLength.Name = "txtMaxMessageLength"
        Me.txtMaxMessageLength.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtMaxMessageLength.Size = New System.Drawing.Size(33, 19)
        Me.txtMaxMessageLength.TabIndex = 30
        Me.txtMaxMessageLength.Text = "0"
        '
        'txtRetryWait
        '
        Me.txtRetryWait.AcceptsReturn = True
        Me.txtRetryWait.AutoSize = False
        Me.txtRetryWait.BackColor = System.Drawing.SystemColors.Window
        Me.txtRetryWait.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtRetryWait.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtRetryWait.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtRetryWait.Location = New System.Drawing.Point(104, 72)
        Me.txtRetryWait.MaxLength = 0
        Me.txtRetryWait.Name = "txtRetryWait"
        Me.txtRetryWait.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtRetryWait.Size = New System.Drawing.Size(33, 19)
        Me.txtRetryWait.TabIndex = 29
        Me.txtRetryWait.Text = "0"
        '
        'txtMaxAttempts
        '
        Me.txtMaxAttempts.AcceptsReturn = True
        Me.txtMaxAttempts.AutoSize = False
        Me.txtMaxAttempts.BackColor = System.Drawing.SystemColors.Window
        Me.txtMaxAttempts.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtMaxAttempts.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtMaxAttempts.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtMaxAttempts.Location = New System.Drawing.Point(104, 48)
        Me.txtMaxAttempts.MaxLength = 0
        Me.txtMaxAttempts.Name = "txtMaxAttempts"
        Me.txtMaxAttempts.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtMaxAttempts.Size = New System.Drawing.Size(33, 19)
        Me.txtMaxAttempts.TabIndex = 28
        Me.txtMaxAttempts.Text = "0"
        '
        'txtAnswerOnRing
        '
        Me.txtAnswerOnRing.AcceptsReturn = True
        Me.txtAnswerOnRing.AutoSize = False
        Me.txtAnswerOnRing.BackColor = System.Drawing.SystemColors.Window
        Me.txtAnswerOnRing.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtAnswerOnRing.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtAnswerOnRing.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtAnswerOnRing.Location = New System.Drawing.Point(104, 24)
        Me.txtAnswerOnRing.MaxLength = 0
        Me.txtAnswerOnRing.Name = "txtAnswerOnRing"
        Me.txtAnswerOnRing.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtAnswerOnRing.Size = New System.Drawing.Size(33, 19)
        Me.txtAnswerOnRing.TabIndex = 27
        Me.txtAnswerOnRing.Text = "0"
        '
        'chkUseSoundCard
        '
        Me.chkUseSoundCard.BackColor = System.Drawing.SystemColors.Control
        Me.chkUseSoundCard.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.chkUseSoundCard.Cursor = System.Windows.Forms.Cursors.Default
        Me.chkUseSoundCard.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.chkUseSoundCard.ForeColor = System.Drawing.SystemColors.ControlText
        Me.chkUseSoundCard.Location = New System.Drawing.Point(152, 96)
        Me.chkUseSoundCard.Name = "chkUseSoundCard"
        Me.chkUseSoundCard.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.chkUseSoundCard.Size = New System.Drawing.Size(97, 33)
        Me.chkUseSoundCard.TabIndex = 16
        Me.chkUseSoundCard.Text = "UseSoundCard"
        '
        'chkInterruptWave
        '
        Me.chkInterruptWave.BackColor = System.Drawing.SystemColors.Control
        Me.chkInterruptWave.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.chkInterruptWave.Cursor = System.Windows.Forms.Cursors.Default
        Me.chkInterruptWave.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.chkInterruptWave.ForeColor = System.Drawing.SystemColors.ControlText
        Me.chkInterruptWave.Location = New System.Drawing.Point(40, 120)
        Me.chkInterruptWave.Name = "chkInterruptWave"
        Me.chkInterruptWave.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.chkInterruptWave.Size = New System.Drawing.Size(97, 27)
        Me.chkInterruptWave.TabIndex = 15
        Me.chkInterruptWave.Text = "InterruptWave"
        '
        'chkEnableVoice
        '
        Me.chkEnableVoice.BackColor = System.Drawing.SystemColors.Control
        Me.chkEnableVoice.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.chkEnableVoice.Cursor = System.Windows.Forms.Cursors.Default
        Me.chkEnableVoice.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.chkEnableVoice.ForeColor = System.Drawing.SystemColors.ControlText
        Me.chkEnableVoice.Location = New System.Drawing.Point(40, 96)
        Me.chkEnableVoice.Name = "chkEnableVoice"
        Me.chkEnableVoice.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.chkEnableVoice.Size = New System.Drawing.Size(97, 33)
        Me.chkEnableVoice.TabIndex = 14
        Me.chkEnableVoice.Text = "EnableVoice"
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.BackColor = System.Drawing.SystemColors.Control
        Me.Label6.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label6.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label6.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label6.Location = New System.Drawing.Point(160, 72)
        Me.Label6.Name = "Label6"
        Me.Label6.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label6.Size = New System.Drawing.Size(89, 13)
        Me.Label6.TabIndex = 13
        Me.Label6.Text = "SilenceThreshold"
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.BackColor = System.Drawing.SystemColors.Control
        Me.Label5.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label5.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label5.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label5.Location = New System.Drawing.Point(160, 48)
        Me.Label5.Name = "Label5"
        Me.Label5.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label5.Size = New System.Drawing.Size(69, 13)
        Me.Label5.TabIndex = 12
        Me.Label5.Text = "TrimSeconds"
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.BackColor = System.Drawing.SystemColors.Control
        Me.Label4.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label4.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label4.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label4.Location = New System.Drawing.Point(160, 24)
        Me.Label4.Name = "Label4"
        Me.Label4.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label4.Size = New System.Drawing.Size(103, 13)
        Me.Label4.TabIndex = 11
        Me.Label4.Text = "MaxMessageLength"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.BackColor = System.Drawing.SystemColors.Control
        Me.Label3.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label3.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label3.Location = New System.Drawing.Point(24, 72)
        Me.Label3.Name = "Label3"
        Me.Label3.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label3.Size = New System.Drawing.Size(52, 13)
        Me.Label3.TabIndex = 10
        Me.Label3.Text = "RetryWait"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.BackColor = System.Drawing.SystemColors.Control
        Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label2.Location = New System.Drawing.Point(24, 48)
        Me.Label2.Name = "Label2"
        Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label2.Size = New System.Drawing.Size(68, 13)
        Me.Label2.TabIndex = 9
        Me.Label2.Text = "MaxAttempts"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.BackColor = System.Drawing.SystemColors.Control
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(24, 24)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(78, 13)
        Me.Label1.TabIndex = 8
        Me.Label1.Text = "AnswerOnRing"
        '
        'Frame1
        '
        Me.Frame1.BackColor = System.Drawing.SystemColors.Control
        Me.Frame1.Controls.AddRange(New System.Windows.Forms.Control() {Me.Apax1, Me.chkTapiStatusDisplay, Me.cmdCancel, Me.cmdDial, Me.cmdAnswer, Me.cmdConfig, Me.cmdSelect})
        Me.Frame1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Frame1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Frame1.Location = New System.Drawing.Point(8, 8)
        Me.Frame1.Name = "Frame1"
        Me.Frame1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Frame1.Size = New System.Drawing.Size(321, 97)
        Me.Frame1.TabIndex = 0
        Me.Frame1.TabStop = False
        Me.Frame1.Text = " Tapi device connection "
        '
        'Apax1
        '
        Me.Apax1.ContainingControl = Me
        Me.Apax1.Location = New System.Drawing.Point(272, 16)
        Me.Apax1.Name = "Apax1"
        Me.Apax1.OcxState = CType(resources.GetObject("Apax1.OcxState"), System.Windows.Forms.AxHost.State)
        Me.Apax1.Size = New System.Drawing.Size(41, 41)
        Me.Apax1.TabIndex = 33
        Me.Apax1.Visible = False
        '
        'chkTapiStatusDisplay
        '
        Me.chkTapiStatusDisplay.BackColor = System.Drawing.SystemColors.Control
        Me.chkTapiStatusDisplay.Cursor = System.Windows.Forms.Cursors.Default
        Me.chkTapiStatusDisplay.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.chkTapiStatusDisplay.ForeColor = System.Drawing.SystemColors.ControlText
        Me.chkTapiStatusDisplay.Location = New System.Drawing.Point(192, 56)
        Me.chkTapiStatusDisplay.Name = "chkTapiStatusDisplay"
        Me.chkTapiStatusDisplay.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.chkTapiStatusDisplay.Size = New System.Drawing.Size(113, 33)
        Me.chkTapiStatusDisplay.TabIndex = 6
        Me.chkTapiStatusDisplay.Text = "Show status dialog"
        '
        'cmdCancel
        '
        Me.cmdCancel.BackColor = System.Drawing.SystemColors.Control
        Me.cmdCancel.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdCancel.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdCancel.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdCancel.Location = New System.Drawing.Point(184, 24)
        Me.cmdCancel.Name = "cmdCancel"
        Me.cmdCancel.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdCancel.Size = New System.Drawing.Size(76, 29)
        Me.cmdCancel.TabIndex = 5
        Me.cmdCancel.Text = "Cancel"
        '
        'cmdDial
        '
        Me.cmdDial.BackColor = System.Drawing.SystemColors.Control
        Me.cmdDial.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdDial.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdDial.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdDial.Location = New System.Drawing.Point(104, 24)
        Me.cmdDial.Name = "cmdDial"
        Me.cmdDial.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdDial.Size = New System.Drawing.Size(76, 29)
        Me.cmdDial.TabIndex = 4
        Me.cmdDial.Text = "Dial..."
        '
        'cmdAnswer
        '
        Me.cmdAnswer.BackColor = System.Drawing.SystemColors.Control
        Me.cmdAnswer.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdAnswer.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdAnswer.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdAnswer.Location = New System.Drawing.Point(24, 24)
        Me.cmdAnswer.Name = "cmdAnswer"
        Me.cmdAnswer.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdAnswer.Size = New System.Drawing.Size(76, 29)
        Me.cmdAnswer.TabIndex = 3
        Me.cmdAnswer.Text = "Answer"
        '
        'cmdConfig
        '
        Me.cmdConfig.BackColor = System.Drawing.SystemColors.Control
        Me.cmdConfig.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdConfig.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdConfig.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdConfig.Location = New System.Drawing.Point(104, 56)
        Me.cmdConfig.Name = "cmdConfig"
        Me.cmdConfig.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdConfig.Size = New System.Drawing.Size(76, 29)
        Me.cmdConfig.TabIndex = 2
        Me.cmdConfig.Text = "Config..."
        '
        'cmdSelect
        '
        Me.cmdSelect.BackColor = System.Drawing.SystemColors.Control
        Me.cmdSelect.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdSelect.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdSelect.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdSelect.Location = New System.Drawing.Point(24, 56)
        Me.cmdSelect.Name = "cmdSelect"
        Me.cmdSelect.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdSelect.Size = New System.Drawing.Size(76, 29)
        Me.cmdSelect.TabIndex = 1
        Me.cmdSelect.Text = "Select..."
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.BackColor = System.Drawing.SystemColors.Control
        Me.Label8.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label8.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label8.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label8.Location = New System.Drawing.Point(344, 8)
        Me.Label8.Name = "Label8"
        Me.Label8.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label8.Size = New System.Drawing.Size(58, 13)
        Me.Label8.TabIndex = 26
        Me.Label8.Text = "Tapi status"
        '
        'Form1
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(613, 415)
        Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.dlgWavFiles, Me.lstTapiStatus, Me.Frame3, Me.Frame2, Me.Frame1, Me.Label8})
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Location = New System.Drawing.Point(4, 23)
        Me.Name = "Form1"
        Me.Text = "Apax VB Example"
        CType(Me.dlgWavFiles, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Frame3.ResumeLayout(False)
        Me.Frame2.ResumeLayout(False)
        Me.Frame1.ResumeLayout(False)
        CType(Me.Apax1, System.ComponentModel.ISupportInitialize).EndInit()
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
	
	Private Sub Add_Renamed(ByVal S As String)
		lstTapiStatus.Items.Add((S))
		If lstTapiStatus.Items.Count > 10 Then
			lstTapiStatus.SelectedIndex = lstTapiStatus.Items.Count - 1
		End If
	End Sub
	
	Private Function TapiStateStr(ByRef State As APAX1.TxTapiState) As String
        Dim S As String
        Select Case State
            Case Apax1.TapiState.tsIdle : S = "tsIdle"
            Case Apax1.TapiState.tsOffering : S = "tsOffering"
            Case Apax1.TapiState.tsAccepted : S = "tsAccepted"
            Case Apax1.TapiState.tsDialTone : S = "tsDialTone"
            Case Apax1.TapiState.tsDialing : S = "tsDialing"
            Case Apax1.TapiState.tsRingback : S = "tsRingBack"
            Case Apax1.TapiState.tsBusy : S = "tsBusy"
            Case Apax1.TapiState.tsSpecialInfo : S = "tsSpecialInfo"
            Case Apax1.TapiState.tsConnected : S = "tsConnected"
            Case Apax1.TapiState.tsProceeding : S = "tsProceeding"
            Case Apax1.TapiState.tsOnHold : S = "tsOnHold"
            Case Apax1.TapiState.tsConferenced : S = "tsConferenced"
            Case Apax1.TapiState.tsOnHoldPendConf : S = "tsOnHoldPendConf"
            Case Apax1.TapiState.tsOnHoldPendTransfer : S = "tsOnHoldPendTransfer"
            Case Apax1.TapiState.tsDisconnected : S = "tsDisconnected"
            Case Apax1.TapiState.tsUnknown : S = "tsUnknown"
        End Select
        TapiStateStr = "  TapiState: " & S & " (" & CStr(Apax1.TapiState) & ")"
	End Function
	
	Private Sub Apax1_OnTapiCallerID(ByVal ID As String, ByVal IDName As String)
		Add_Renamed(("OnCallerID: ID = " & ID))
		Add_Renamed(("          : IDName = " & IDName))
	End Sub
	
	Private Sub Apax1_OnTapiConnect()
		Add_Renamed(("OnTapiConnect"))
		Add_Renamed((TapiStateStr((Apax1.TapiState))))
		If Apax1.EnableVoice Then
			Apax1.TapiPlayWaveFile((txtWavDirectory.Text & "\greeting.wav"))
		End If
	End Sub
	
	Private Sub Apax1_OnTapiDTMF(ByVal Digit As Byte, ByVal ErrorCode As Integer)
		Add_Renamed(("OnTapiDTMF: " & CStr(Digit - 48)))
		Add_Renamed((TapiStateStr((Apax1.TapiState))))
	End Sub
	
	Private Sub Apax1_OnTapiFail()
		If Apax1.TapiCancelled Then
			Add_Renamed(("OnTapiFail because we cancelled the call"))
		Else
			Add_Renamed(("OnTapiFail due to a real failure"))
        End If
        Frame2.Enabled = True
        Add_Renamed(("  " & TapiStateStr((Apax1.TapiState))))
	End Sub
	
	Private Sub Apax1_OnTapiGetNumber(ByRef PhoneNum As String)
		Dim S As String
		S = InputBox("Enter Phone Number", Text)
		If (S <> "") Then
			PhoneNum = S
			Add_Renamed(("OnTapiGetNumber - " & PhoneNum))
			Add_Renamed((TapiStateStr((Apax1.TapiState))))
		End If
	End Sub
	
    Private Sub Apax1_OnTapiPortClose()
        Frame2.Enabled = True
        Add_Renamed(("OnTapiPortClose"))
        Add_Renamed((TapiStateStr((Apax1.TapiState))))
    End Sub

    Private Sub Apax1_OnTapiPortOpen()
        Add_Renamed(("OnTapiPortOpen"))
        Add_Renamed((TapiStateStr((Apax1.TapiState))))
    End Sub

    Private Sub Apax1_OnTapiStatus(ByVal First As Boolean, ByVal Last As Boolean, ByVal Device As Integer, ByVal Message As Integer, ByVal Param1 As Integer, ByVal Param2 As Integer, ByVal Param3 As Integer)
        Add_Renamed(("OnTapiStatus: " & Apax1.TapiStatusMsg(Message, Param1, Param2) & ", (" & CStr(Message) & "), (" & CStr(Param1) & "), (" & CStr(Param2) & "), (" & CStr(Param3) & ")"))
        Add_Renamed((TapiStateStr((Apax1.TapiState))))
    End Sub

    Private Sub Apax1_OnTapiWaveNotify(ByVal Msg As Apax1.TxWaveMessage)
        Dim S As String
        Select Case Msg
            Case Apax1.WaveState : S = "waPlayOpen"
            Case Apax1.WaveState : S = "waPlayDone"
            Case Apax1.WaveState : S = "waPlayClose"
            Case Apax1.WaveState : S = "waRecordOpen"
            Case Apax1.WaveState : S = "waDataReady"
            Case Apax1.WaveState : S = "waRecordClose"
        End Select
        Add_Renamed(("OnTapiWaveNotify: " & S))
    End Sub

    Private Sub Apax1_OnTapiWaveSilence(ByRef StopRecording As Boolean, ByRef Hangup As Boolean)
        Add_Renamed(("OnTapiWaveSilence"))
    End Sub

    'UPGRADE_WARNING: Event chkEnableVoice.CheckStateChanged may fire when form is intialized. Click for more: 'ms-help://MS.VSCC/commoner/redir/redirect.htm?keyword="vbup2075"'
    Private Sub chkEnableVoice_CheckStateChanged(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles chkEnableVoice.CheckStateChanged
        Apax1.EnableVoice = CBool(chkEnableVoice.CheckState)
    End Sub

    'UPGRADE_WARNING: Event chkInterruptWave.CheckStateChanged may fire when form is intialized. Click for more: 'ms-help://MS.VSCC/commoner/redir/redirect.htm?keyword="vbup2075"'
    Private Sub chkInterruptWave_CheckStateChanged(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles chkInterruptWave.CheckStateChanged
        Apax1.InterruptWave = CBool(chkInterruptWave.CheckState)
    End Sub

    'UPGRADE_WARNING: Event chkTapiStatusDisplay.CheckStateChanged may fire when form is intialized. Click for more: 'ms-help://MS.VSCC/commoner/redir/redirect.htm?keyword="vbup2075"'
    Private Sub chkTapiStatusDisplay_CheckStateChanged(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles chkTapiStatusDisplay.CheckStateChanged
        Apax1.TapiStatusDisplay = CBool(chkTapiStatusDisplay.CheckState)
    End Sub

    'UPGRADE_WARNING: Event chkUseSoundCard.CheckStateChanged may fire when form is intialized. Click for more: 'ms-help://MS.VSCC/commoner/redir/redirect.htm?keyword="vbup2075"'
    Private Sub chkUseSoundCard_CheckStateChanged(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles chkUseSoundCard.CheckStateChanged
        Apax1.UseSoundCard = CBool(chkUseSoundCard.CheckState)
    End Sub

    Private Sub cmdAnswer_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdAnswer.Click
        Load_Text_Values()
        Frame2.Enabled = False
        Add_Renamed(("Answer button clicked (" & Apax1.SelectedDevice & ")"))
        Add_Renamed((TapiStateStr((Apax1.TapiState))))
        Apax1.TapiAnswer()
    End Sub

    Private Sub Load_Text_Values()
        Apax1.AnswerOnRing = Val(txtAnswerOnRing.Text)
        Apax1.MaxAttempts = Val(txtMaxAttempts.Text)
        Apax1.MaxMessageLength = Val(txtMaxMessageLength.Text)
        Apax1.TapiRetryWait = Val(txtRetryWait.Text)
        Apax1.SilenceThreshold = Val(txtSilenceThreshold.Text)
        Apax1.TrimSeconds = Val(txtTrimSeconds.Text)
    End Sub

    Private Sub cmdConfig_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdConfig.Click
        Load_Text_Values()
        Frame2.Enabled = False
        Apax1.TapiShowConfigDialog((True))
        Add_Renamed(("Config button click (" & Apax1.SelectedDevice & ")"))
        Add_Renamed((TapiStateStr((Apax1.TapiState))))
    End Sub

    Private Sub cmdDial_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdDial.Click
        Load_Text_Values()
        Frame2.Enabled = False
        Add_Renamed(("Dial button click (" & Apax1.SelectedDevice & ")"))
        Add_Renamed((TapiStateStr((Apax1.TapiState))))
        Apax1.TapiDial()
    End Sub

    Private Sub cmdDTMF_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdDTMF.Click
        Dim S As String
        S = InputBox("Enter digits to send", Text)
        If (S <> "") Then
            Add_Renamed(("SendTone(" & S & ")"))
            Apax1.TapiSendTone((S))
        End If
    End Sub

    Private Sub cmdCancel_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdCancel.Click
        Add_Renamed(("Cancel button click"))
        Add_Renamed((TapiStateStr((Apax1.TapiState))))
        Apax1.Close()
    End Sub

    Private Sub cmdPlay_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdPlay.Click
        dlgWavFiles.DialogTitle = "Select Wav File"
        dlgWavFiles.InitDir = txtWavDirectory.Text
        dlgWavFiles.ShowOpen()
        Add_Renamed(("Playing wave file (" & dlgWavFiles.FileName & ")"))
        Apax1.TapiPlayWaveFile((dlgWavFiles.FileName))
    End Sub

    Private Sub cmdRecord_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdRecord.Click
        Dim Overwrite As Object
        dlgWavFiles.DialogTitle = "Record Wav File"
        dlgWavFiles.InitDir = txtWavDirectory.Text
        dlgWavFiles.ShowSave()
        Add_Renamed(("Recording wave file (" & dlgWavFiles.FileName & ")"))
        'UPGRADE_WARNING: Couldn't resolve default property of object Overwrite. Click for more: 'ms-help://MS.VSCC/commoner/redir/redirect.htm?keyword="vbup1037"'
        Apax1.TapiRecordWaveFile(dlgWavFiles.FileName, Overwrite = chkOverwrite.CheckState)
    End Sub

    Private Sub cmdSelect_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdSelect.Click
        Apax1.TapiSelectDevice()
        Add_Renamed(("SelectedDevice = " & Apax1.SelectedDevice))
    End Sub

    Private Sub cmdStop_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdStop.Click
        Apax1.TapiStopWaveFile()
        Add_Renamed(("Stopping wav file"))
    End Sub

    'UPGRADE_WARNING: Form event Form1.Activate has a new behavior. Click for more: 'ms-help://MS.VSCC/commoner/redir/redirect.htm?keyword="vbup2065"'
    Private Sub Form1_Activated(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Activated
        Dim Test As Short
        txtAnswerOnRing.Text = CStr(Apax1.AnswerOnRing)
        txtMaxAttempts.Text = CStr(Apax1.MaxAttempts)
        txtRetryWait.Text = CStr(Apax1.TapiRetryWait)
        txtMaxMessageLength.Text = CStr(Apax1.MaxMessageLength)
        txtTrimSeconds.Text = CStr(Apax1.TrimSeconds)
        txtSilenceThreshold.Text = CStr(Apax1.SilenceThreshold)
        chkEnableVoice.CheckState = System.Math.Abs(CInt(Apax1.EnableVoice))
        chkInterruptWave.CheckState = System.Math.Abs(CInt(Apax1.InterruptWave))
        chkUseSoundCard.CheckState = System.Math.Abs(CInt(Apax1.UseSoundCard))
        chkTapiStatusDisplay.CheckState = System.Math.Abs(CInt(Apax1.TapiStatusDisplay))
    End Sub

    Private Sub lstTapiStatus_DoubleClick(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles lstTapiStatus.DoubleClick
        lstTapiStatus.Items.Clear()
    End Sub

End Class