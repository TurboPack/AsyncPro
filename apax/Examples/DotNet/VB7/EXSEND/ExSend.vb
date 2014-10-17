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
	Public WithEvents OpenDialog1 As AxMSComDlg.AxCommonDialog
	Public WithEvents btnCancel As System.Windows.Forms.Button
	Public WithEvents btnSend As System.Windows.Forms.Button
	Public WithEvents cbxProtocol As System.Windows.Forms.ComboBox
	Public WithEvents btnHangup As System.Windows.Forms.Button
	Public WithEvents btnDial As System.Windows.Forms.Button
	Public WithEvents tbPhoneNumber As System.Windows.Forms.TextBox
	Public WithEvents Label2 As System.Windows.Forms.Label
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
		Me.OpenDialog1 = New AxMSComDlg.AxCommonDialog
		Me.Frame1 = New System.Windows.Forms.GroupBox
		Me.btnCancel = New System.Windows.Forms.Button
		Me.btnSend = New System.Windows.Forms.Button
		Me.cbxProtocol = New System.Windows.Forms.ComboBox
		Me.btnHangup = New System.Windows.Forms.Button
		Me.btnDial = New System.Windows.Forms.Button
		Me.tbPhoneNumber = New System.Windows.Forms.TextBox
		Me.Label2 = New System.Windows.Forms.Label
		CType(Me.Apax1, System.ComponentModel.ISupportInitialize).BeginInit()
		CType(Me.OpenDialog1, System.ComponentModel.ISupportInitialize).BeginInit()
		Me.Text = "ExSend - File Transfer Sender"
		Me.ClientSize = New System.Drawing.Size(421, 352)
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
		Me.Apax1.Size = New System.Drawing.Size(417, 233)
		Me.Apax1.Location = New System.Drawing.Point(0, 0)
		Me.Apax1.TabIndex = 8
		Me.Apax1.Visible = -1
		Me.Apax1.Name = "Apax1"
		OpenDialog1.OcxState = CType(resources.GetObject("OpenDialog1.OcxState"), System.Windows.Forms.AxHost.State)
		Me.OpenDialog1.Location = New System.Drawing.Point(32, 296)
		Me.OpenDialog1.Name = "OpenDialog1"
		Me.Frame1.Size = New System.Drawing.Size(417, 105)
		Me.Frame1.Location = New System.Drawing.Point(0, 240)
		Me.Frame1.TabIndex = 0
		Me.Frame1.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.Frame1.BackColor = System.Drawing.SystemColors.Control
		Me.Frame1.Enabled = True
		Me.Frame1.ForeColor = System.Drawing.SystemColors.ControlText
		Me.Frame1.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.Frame1.Visible = True
		Me.Frame1.Name = "Frame1"
		Me.btnCancel.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.btnCancel.Text = "Cancel"
		Me.btnCancel.Size = New System.Drawing.Size(73, 25)
		Me.btnCancel.Location = New System.Drawing.Point(336, 64)
		Me.btnCancel.TabIndex = 7
		Me.btnCancel.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.btnCancel.BackColor = System.Drawing.SystemColors.Control
		Me.btnCancel.CausesValidation = True
		Me.btnCancel.Enabled = True
		Me.btnCancel.ForeColor = System.Drawing.SystemColors.ControlText
		Me.btnCancel.Cursor = System.Windows.Forms.Cursors.Default
		Me.btnCancel.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.btnCancel.TabStop = True
		Me.btnCancel.Name = "btnCancel"
		Me.btnSend.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.btnSend.Text = "Send..."
		Me.btnSend.Enabled = False
		Me.btnSend.Size = New System.Drawing.Size(73, 25)
		Me.btnSend.Location = New System.Drawing.Point(256, 64)
		Me.btnSend.TabIndex = 6
		Me.btnSend.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.btnSend.BackColor = System.Drawing.SystemColors.Control
		Me.btnSend.CausesValidation = True
		Me.btnSend.ForeColor = System.Drawing.SystemColors.ControlText
		Me.btnSend.Cursor = System.Windows.Forms.Cursors.Default
		Me.btnSend.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.btnSend.TabStop = True
		Me.btnSend.Name = "btnSend"
		Me.cbxProtocol.Size = New System.Drawing.Size(105, 21)
		Me.cbxProtocol.Location = New System.Drawing.Point(104, 64)
		Me.cbxProtocol.Items.AddRange(New Object(){"No Protocol", "Xmodem", "XmodemCRC ", "Xmodem1K", "Xmodem1KG ", "Ymodem", "YmodemG ", "Zmodem", "Kermit", "Ascii"})
		Me.cbxProtocol.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
		Me.cbxProtocol.TabIndex = 5
		Me.cbxProtocol.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.cbxProtocol.BackColor = System.Drawing.SystemColors.Window
		Me.cbxProtocol.CausesValidation = True
		Me.cbxProtocol.Enabled = True
		Me.cbxProtocol.ForeColor = System.Drawing.SystemColors.WindowText
		Me.cbxProtocol.IntegralHeight = True
		Me.cbxProtocol.Cursor = System.Windows.Forms.Cursors.Default
		Me.cbxProtocol.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.cbxProtocol.Sorted = False
		Me.cbxProtocol.TabStop = True
		Me.cbxProtocol.Visible = True
		Me.cbxProtocol.Name = "cbxProtocol"
		Me.btnHangup.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.btnHangup.Text = "Hangup"
		Me.btnHangup.Size = New System.Drawing.Size(73, 25)
		Me.btnHangup.Location = New System.Drawing.Point(336, 24)
		Me.btnHangup.TabIndex = 4
		Me.btnHangup.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.btnHangup.BackColor = System.Drawing.SystemColors.Control
		Me.btnHangup.CausesValidation = True
		Me.btnHangup.Enabled = True
		Me.btnHangup.ForeColor = System.Drawing.SystemColors.ControlText
		Me.btnHangup.Cursor = System.Windows.Forms.Cursors.Default
		Me.btnHangup.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.btnHangup.TabStop = True
		Me.btnHangup.Name = "btnHangup"
		Me.btnDial.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.btnDial.Text = "Dial"
		Me.btnDial.Size = New System.Drawing.Size(73, 25)
		Me.btnDial.Location = New System.Drawing.Point(256, 24)
		Me.btnDial.TabIndex = 3
		Me.btnDial.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.btnDial.BackColor = System.Drawing.SystemColors.Control
		Me.btnDial.CausesValidation = True
		Me.btnDial.Enabled = True
		Me.btnDial.ForeColor = System.Drawing.SystemColors.ControlText
		Me.btnDial.Cursor = System.Windows.Forms.Cursors.Default
		Me.btnDial.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.btnDial.TabStop = True
		Me.btnDial.Name = "btnDial"
		Me.tbPhoneNumber.AutoSize = False
		Me.tbPhoneNumber.Size = New System.Drawing.Size(137, 21)
		Me.tbPhoneNumber.Location = New System.Drawing.Point(104, 24)
		Me.tbPhoneNumber.TabIndex = 2
		Me.tbPhoneNumber.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.tbPhoneNumber.AcceptsReturn = True
		Me.tbPhoneNumber.TextAlign = System.Windows.Forms.HorizontalAlignment.Left
		Me.tbPhoneNumber.BackColor = System.Drawing.SystemColors.Window
		Me.tbPhoneNumber.CausesValidation = True
		Me.tbPhoneNumber.Enabled = True
		Me.tbPhoneNumber.ForeColor = System.Drawing.SystemColors.WindowText
		Me.tbPhoneNumber.HideSelection = True
		Me.tbPhoneNumber.ReadOnly = False
		Me.tbPhoneNumber.Maxlength = 0
		Me.tbPhoneNumber.Cursor = System.Windows.Forms.Cursors.IBeam
		Me.tbPhoneNumber.MultiLine = False
		Me.tbPhoneNumber.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.tbPhoneNumber.ScrollBars = System.Windows.Forms.ScrollBars.None
		Me.tbPhoneNumber.TabStop = True
		Me.tbPhoneNumber.Visible = True
		Me.tbPhoneNumber.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me.tbPhoneNumber.Name = "tbPhoneNumber"
		Me.Label2.Text = "Phone Number"
		Me.Label2.Size = New System.Drawing.Size(71, 13)
		Me.Label2.Location = New System.Drawing.Point(16, 32)
		Me.Label2.TabIndex = 1
		Me.Label2.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
		Me.Label2.TextAlign = System.Drawing.ContentAlignment.TopLeft
		Me.Label2.BackColor = System.Drawing.SystemColors.Control
		Me.Label2.Enabled = True
		Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
		Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
		Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.Label2.UseMnemonic = True
		Me.Label2.Visible = True
		Me.Label2.AutoSize = True
		Me.Label2.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.Label2.Name = "Label2"
		Me.Controls.Add(Apax1)
		Me.Controls.Add(OpenDialog1)
		Me.Controls.Add(Frame1)
		Me.Frame1.Controls.Add(btnCancel)
		Me.Frame1.Controls.Add(btnSend)
		Me.Frame1.Controls.Add(cbxProtocol)
		Me.Frame1.Controls.Add(btnHangup)
		Me.Frame1.Controls.Add(btnDial)
		Me.Frame1.Controls.Add(tbPhoneNumber)
		Me.Frame1.Controls.Add(Label2)
		CType(Me.OpenDialog1, System.ComponentModel.ISupportInitialize).EndInit()
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
	Private Sub Apax1_OnProtocolFinish(ByVal ErrorCode As Integer)
		If ErrorCode = 0 Then
			Apax1.TerminalWriteStringCRLF((Apax1.SendFileName & " sent."))
		Else
			Apax1.TerminalWriteStringCRLF(CStr(CDbl(Apax1.SendFileName & " protocol error - ") + ErrorCode))
		End If
	End Sub
	
	Private Sub Apax1_OnTapiConnect()
		Text = "Connected"
		btnSend.Enabled = True
		btnCancel.Enabled = True
	End Sub
	
	Private Sub Apax1_OnTapiPortClose()
		Text = "ExSend - File Transfer Sender"
		btnSend.Enabled = False
		btnCancel.Enabled = False
	End Sub
	
	Private Sub btnDial_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnDial.Click
		Apax1.TapiNumber = tbPhoneNumber.Text
		Apax1.TapiDial()
	End Sub
	
	Private Sub btnSend_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnSend.Click
		OpenDialog1.CancelError = True
		On Error GoTo DoCancel
		OpenDialog1.ShowOpen()
		Apax1.SendFileName = OpenDialog1.FileName
		Apax1.Protocol = cbxProtocol.SelectedIndex
		Text = "Sending " & Apax1.SendFileName
		Apax1.StartTransmit()
		Exit Sub
DoCancel: 
		Exit Sub
	End Sub
	
	Private Sub btnHangup_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnHangup.Click
		Apax1.Close()
	End Sub
	
	Private Sub btnCancel_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles btnCancel.Click
		Apax1.CancelProtocol()
	End Sub
	
	'UPGRADE_WARNING: Form event Form1.Activate has a new behavior. Click for more: 'ms-help://MS.VSCC/commoner/redir/redirect.htm?keyword="vbup2065"'
	Private Sub Form1_Activated(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Activated
		cbxProtocol.SelectedIndex = Apax1.Protocol
		tbPhoneNumber.Text = Apax1.TapiNumber
	End Sub
End Class