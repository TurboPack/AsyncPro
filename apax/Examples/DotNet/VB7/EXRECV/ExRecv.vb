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
	Public WithEvents cbxProtocol As System.Windows.Forms.ComboBox
	Public WithEvents btnCancel As System.Windows.Forms.Button
	Public WithEvents btnStop As System.Windows.Forms.Button
	Public WithEvents Label1 As System.Windows.Forms.Label
	Public WithEvents Frame1 As System.Windows.Forms.GroupBox
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
		Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(Form1))
		Me.components = New System.ComponentModel.Container()
		Me.ToolTip1 = New System.Windows.Forms.ToolTip(components)
		Me.ToolTip1.Active = True
		Me.Apax1 = New AxAPAX1.AxApax
		Me.cbxProtocol = New System.Windows.Forms.ComboBox
		Me.Frame1 = New System.Windows.Forms.GroupBox
		Me.btnCancel = New System.Windows.Forms.Button
		Me.btnStop = New System.Windows.Forms.Button
		Me.Label1 = New System.Windows.Forms.Label
		CType(Me.Apax1, System.ComponentModel.ISupportInitialize).BeginInit()
		Me.Text = "ExRecv - File Transfer Receiver"
		Me.ClientSize = New System.Drawing.Size(428, 328)
		Me.Location = New System.Drawing.Point(4, 23)
		Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
		Me.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
		Me.BackColor = System.Drawing.SystemColors.Control
		Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Sizable
		Me.ControlBox = True
		Me.Enabled = True
		Me.KeyPreview = False
		Me.MaximizeBox = True
		Me.MinimizeBox = True
		Me.Cursor = System.Windows.Forms.Cursors.Default
		Me.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.ShowInTaskbar = True
		Me.HelpButton = False
		Me.WindowState = System.Windows.Forms.FormWindowState.Normal
		Me.Name = "Form1"
		Apax1.OcxState = CType(resources.GetObject("Apax1.OcxState"), System.Windows.Forms.AxHost.State)
		Me.Apax1.Size = New System.Drawing.Size(417, 257)
		Me.Apax1.Location = New System.Drawing.Point(8, 8)
		Me.Apax1.TabIndex = 5
		Me.Apax1.Visible = -1
		Me.Apax1.Name = "Apax1"
		Me.cbxProtocol.Size = New System.Drawing.Size(137, 21)
		Me.cbxProtocol.Location = New System.Drawing.Point(80, 288)
		Me.cbxProtocol.Items.AddRange(New Object(){"No Protocol", "Xmodem", "XmodemCRC ", "Xmodem1K", "Xmodem1KG ", "Ymodem", "YmodemG ", "Zmodem", "Kermit", "Ascii"})
		Me.cbxProtocol.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
		Me.cbxProtocol.TabIndex = 4
		Me.cbxProtocol.TabStop = False
		Me.cbxProtocol.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.cbxProtocol.BackColor = System.Drawing.SystemColors.Window
		Me.cbxProtocol.CausesValidation = True
		Me.cbxProtocol.Enabled = True
		Me.cbxProtocol.ForeColor = System.Drawing.SystemColors.WindowText
		Me.cbxProtocol.IntegralHeight = True
		Me.cbxProtocol.Cursor = System.Windows.Forms.Cursors.Default
		Me.cbxProtocol.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.cbxProtocol.Sorted = False
		Me.cbxProtocol.Visible = True
		Me.cbxProtocol.Name = "cbxProtocol"
		Me.Frame1.Size = New System.Drawing.Size(417, 49)
		Me.Frame1.Location = New System.Drawing.Point(8, 272)
		Me.Frame1.TabIndex = 0
		Me.Frame1.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.Frame1.BackColor = System.Drawing.SystemColors.Control
		Me.Frame1.Enabled = True
		Me.Frame1.ForeColor = System.Drawing.SystemColors.ControlText
		Me.Frame1.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.Frame1.Visible = True
		Me.Frame1.Name = "Frame1"
		Me.btnCancel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.btnCancel.Text = "Cancel "
		Me.btnCancel.Size = New System.Drawing.Size(81, 27)
		Me.btnCancel.Location = New System.Drawing.Point(232, 16)
		Me.btnCancel.TabIndex = 2
		Me.btnCancel.TabStop = False
		Me.btnCancel.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.btnCancel.BackColor = System.Drawing.SystemColors.Control
		Me.btnCancel.CausesValidation = True
		Me.btnCancel.Enabled = True
		Me.btnCancel.ForeColor = System.Drawing.SystemColors.ControlText
		Me.btnCancel.Cursor = System.Windows.Forms.Cursors.Default
		Me.btnCancel.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.btnCancel.Name = "btnCancel"
		Me.btnStop.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.btnStop.Text = "Hangup"
		Me.btnStop.Size = New System.Drawing.Size(81, 27)
		Me.btnStop.Location = New System.Drawing.Point(328, 16)
		Me.btnStop.TabIndex = 1
		Me.btnStop.TabStop = False
		Me.btnStop.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.btnStop.BackColor = System.Drawing.SystemColors.Control
		Me.btnStop.CausesValidation = True
		Me.btnStop.Enabled = True
		Me.btnStop.ForeColor = System.Drawing.SystemColors.ControlText
		Me.btnStop.Cursor = System.Windows.Forms.Cursors.Default
		Me.btnStop.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.btnStop.Name = "btnStop"
		Me.Label1.Text = "Protocol"
		Me.Label1.Size = New System.Drawing.Size(39, 13)
		Me.Label1.Location = New System.Drawing.Point(16, 16)
		Me.Label1.TabIndex = 3
		Me.Label1.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.Label1.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me.Label1.BackColor = System.Drawing.SystemColors.Control
		Me.Label1.Enabled = True
		Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
		Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
		Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.Label1.UseMnemonic = True
		Me.Label1.Visible = True
		Me.Label1.AutoSize = True
		Me.Label1.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.Label1.Name = "Label1"
		Me.Controls.Add(Apax1)
		Me.Controls.Add(cbxProtocol)
		Me.Controls.Add(Frame1)
		Me.Frame1.Controls.Add(btnCancel)
		Me.Frame1.Controls.Add(btnStop)
		Me.Frame1.Controls.Add(Label1)
		CType(Me.Apax1, System.ComponentModel.ISupportInitialize).EndInit()
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
	Dim RcvFileName As String
	
	Private Sub Apax1_OnProtocolAccept(ByRef Accept As Boolean, ByRef FName As String)
		RcvFileName = FName
		Text = "Receiving " & FName
		Accept = True
	End Sub
	
	Private Sub Apax1_OnProtocolFinish(ByVal ErrorCode As Integer)
		If ErrorCode = 0 Then
			Apax1.TerminalWriteStringCRLF((RcvFileName & " received."))
		Else
			Apax1.TerminalWriteStringCRLF(CStr(CDbl(RcvFileName & " protocol error - ") + ErrorCode))
		End If
		Apax1.StartReceive()
	End Sub
	
	Private Sub Apax1_OnTapiConnect()
		Apax1.Protocol = cbxProtocol.SelectedIndex
		Text = "Connected"
		Apax1.StartReceive()
	End Sub
	
	Private Sub Apax1_OnTapiPortClose()
		Text = "ExRecv - File Transfer Receiver - Waiting for Call"
		Apax1.TapiAnswer()
	End Sub
	
	Private Sub btnCancel_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnCancel.Click
		Apax1.CancelProtocol()
	End Sub
	
	Private Sub btnStop_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnStop.Click
		Apax1.Close()
		Text = "ExRecv - File Transfer Receiver - Waiting For Call"
	End Sub
	
	'UPGRADE_WARNING: Form event Form1.Activate has a new behavior. Click for more: 'ms-help://MS.VSCC/commoner/redir/redirect.htm?keyword="vbup2065"'
	Private Sub Form1_Activated(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Activated
		cbxProtocol.SelectedIndex = Apax1.Protocol
		Apax1.TapiAnswer()
		Text = Text & " - Waiting For Call"
	End Sub
End Class