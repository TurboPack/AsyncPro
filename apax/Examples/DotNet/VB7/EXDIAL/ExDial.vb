Option Strict Off
Option Explicit On
Friend Class ExDial
    Inherits System.Windows.Forms.Form
#Region "Header Information"
    '/**********************************************************\
    '|*                    ExDial - APAX                       *|
    '|*      Copyright (c) TurboPower Software 2002            *|
    '|*                 All rights reserved.                   *|
    '|**********************************************************|

    '|**********************Description*************************|
    '|* An example of how to dial with a modem using TAPI or   *|
    '|* DirectToCom.                                           *|
    '\**********************************************************/ 
#End Region
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
    Public WithEvents cmdCancel As System.Windows.Forms.Button
    Public WithEvents edtPhoneNumber As System.Windows.Forms.TextBox
    Public WithEvents cmdTapi As System.Windows.Forms.Button
    Public WithEvents cmdDirect As System.Windows.Forms.Button
    Public WithEvents Label1 As System.Windows.Forms.Label
    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(ExDial))
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.Apax1 = New AxAPAX1.AxApax()
        Me.cmdCancel = New System.Windows.Forms.Button()
        Me.edtPhoneNumber = New System.Windows.Forms.TextBox()
        Me.cmdTapi = New System.Windows.Forms.Button()
        Me.cmdDirect = New System.Windows.Forms.Button()
        Me.Label1 = New System.Windows.Forms.Label()
        CType(Me.Apax1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'Apax1
        '
        Me.Apax1.Location = New System.Drawing.Point(0, 88)
        Me.Apax1.Name = "Apax1"
        Me.Apax1.OcxState = CType(resources.GetObject("Apax1.OcxState"), System.Windows.Forms.AxHost.State)
        Me.Apax1.Size = New System.Drawing.Size(337, 217)
        Me.Apax1.TabIndex = 0
        '
        'cmdCancel
        '
        Me.cmdCancel.BackColor = System.Drawing.SystemColors.Control
        Me.cmdCancel.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdCancel.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdCancel.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdCancel.Location = New System.Drawing.Point(240, 8)
        Me.cmdCancel.Name = "cmdCancel"
        Me.cmdCancel.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdCancel.Size = New System.Drawing.Size(89, 25)
        Me.cmdCancel.TabIndex = 5
        Me.cmdCancel.Text = "Cancel"
        '
        'edtPhoneNumber
        '
        Me.edtPhoneNumber.AcceptsReturn = True
        Me.edtPhoneNumber.AutoSize = False
        Me.edtPhoneNumber.BackColor = System.Drawing.SystemColors.Window
        Me.edtPhoneNumber.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.edtPhoneNumber.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.edtPhoneNumber.ForeColor = System.Drawing.SystemColors.WindowText
        Me.edtPhoneNumber.Location = New System.Drawing.Point(168, 56)
        Me.edtPhoneNumber.MaxLength = 0
        Me.edtPhoneNumber.Name = "edtPhoneNumber"
        Me.edtPhoneNumber.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.edtPhoneNumber.Size = New System.Drawing.Size(161, 19)
        Me.edtPhoneNumber.TabIndex = 3
        Me.edtPhoneNumber.Text = ""
        '
        'cmdTapi
        '
        Me.cmdTapi.BackColor = System.Drawing.SystemColors.Control
        Me.cmdTapi.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdTapi.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdTapi.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdTapi.Location = New System.Drawing.Point(128, 8)
        Me.cmdTapi.Name = "cmdTapi"
        Me.cmdTapi.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdTapi.Size = New System.Drawing.Size(89, 25)
        Me.cmdTapi.TabIndex = 2
        Me.cmdTapi.Text = "Tapi Dial"
        '
        'cmdDirect
        '
        Me.cmdDirect.BackColor = System.Drawing.SystemColors.Control
        Me.cmdDirect.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdDirect.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdDirect.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdDirect.Location = New System.Drawing.Point(8, 8)
        Me.cmdDirect.Name = "cmdDirect"
        Me.cmdDirect.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdDirect.Size = New System.Drawing.Size(97, 25)
        Me.cmdDirect.TabIndex = 1
        Me.cmdDirect.Text = "Dial Direct"
        '
        'Label1
        '
        Me.Label1.BackColor = System.Drawing.SystemColors.Control
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(16, 56)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(104, 16)
        Me.Label1.TabIndex = 4
        Me.Label1.Text = "Phone Number"
        '
        'ExDial
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(348, 309)
        Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.Apax1, Me.cmdCancel, Me.edtPhoneNumber, Me.cmdTapi, Me.cmdDirect, Me.Label1})
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Location = New System.Drawing.Point(4, 23)
        Me.Name = "ExDial"
        Me.Text = "ExDial"
        CType(Me.Apax1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
#End Region
#Region "Upgrade Support "
    Private Shared m_vb6FormDefInstance As ExDial
    Private Shared m_InitializingDefInstance As Boolean
    Public Shared Property DefInstance() As ExDial
        Get
            If m_vb6FormDefInstance Is Nothing OrElse m_vb6FormDefInstance.IsDisposed Then
                m_InitializingDefInstance = True
                m_vb6FormDefInstance = New ExDial()
                m_InitializingDefInstance = False
            End If
            DefInstance = m_vb6FormDefInstance
        End Get
        Set(ByVal Value As ExDial)
            m_vb6FormDefInstance = Value
        End Set
    End Property
#End Region

    Private Sub cmdCancel_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdCancel.Click
        Apax1.Close()
    End Sub

    Private Sub cmdDirect_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdDirect.Click
        Apax1.PortOpen()
        Apax1.TerminalSetFocus()
        Apax1.PutStringCRLF("ATX3D" & edtPhoneNumber.Text)
    End Sub

    Private Sub cmdTapi_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdTapi.Click
        Apax1.TapiNumber = edtPhoneNumber.Text
        Apax1.TerminalSetFocus()
        Apax1.TapiDial()
    End Sub
End Class