Option Strict Off
Option Explicit On 


Friend Class Form1
    Inherits System.Windows.Forms.Form
#Region "Header Information"
    '/**********************************************************\
    '|*                    ExComm - APAX                       *|
    '|*      Copyright (c) TurboPower Software 2002            *|
    '|*                 All rights reserved.                   *|
    '|**********************************************************|

    '|**********************Description*************************|
    '|* An example of data being sent/received across a port.  *|
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
    Public WithEvents lstReceived As System.Windows.Forms.ListBox
    Public WithEvents txtPut As System.Windows.Forms.TextBox
    Public WithEvents cmdPutData As System.Windows.Forms.Button
    Public WithEvents cmdPutStringCRLF As System.Windows.Forms.Button
    Public WithEvents cmdPutString As System.Windows.Forms.Button
    Public WithEvents Frame2 As System.Windows.Forms.GroupBox
    Public WithEvents cmdClose As System.Windows.Forms.Button
    Public WithEvents cmdOpen As System.Windows.Forms.Button
    Public WithEvents txtComNumber As System.Windows.Forms.TextBox
    Public WithEvents Label1 As System.Windows.Forms.Label
    Public WithEvents Frame1 As System.Windows.Forms.GroupBox
    Public WithEvents Label2 As System.Windows.Forms.Label
    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(Form1))
        Me.components = New System.ComponentModel.Container()
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(components)
        Me.ToolTip1.Active = True
        Me.Apax1 = New AxAPAX1.AxApax()
        Me.lstReceived = New System.Windows.Forms.ListBox()
        Me.Frame2 = New System.Windows.Forms.GroupBox()
        Me.txtPut = New System.Windows.Forms.TextBox()
        Me.cmdPutData = New System.Windows.Forms.Button()
        Me.cmdPutStringCRLF = New System.Windows.Forms.Button()
        Me.cmdPutString = New System.Windows.Forms.Button()
        Me.Frame1 = New System.Windows.Forms.GroupBox()
        Me.cmdClose = New System.Windows.Forms.Button()
        Me.cmdOpen = New System.Windows.Forms.Button()
        Me.txtComNumber = New System.Windows.Forms.TextBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.Label2 = New System.Windows.Forms.Label()
        CType(Me.Apax1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Text = "ExComm - Serial Comm Port Communications"
        Me.ClientSize = New System.Drawing.Size(513, 505)
        Me.Location = New System.Drawing.Point(4, 23)
        Me.StartPosition = System.Windows.Forms.FormStartPosition.WindowsDefaultLocation
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
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
        Me.Apax1.Size = New System.Drawing.Size(497, 233)
        Me.Apax1.Location = New System.Drawing.Point(8, 8)
        Me.Apax1.TabIndex = 12
        Me.Apax1.Visible = -1
        Me.Apax1.Name = "Apax1"
        Me.lstReceived.Size = New System.Drawing.Size(497, 124)
        Me.lstReceived.Location = New System.Drawing.Point(8, 376)
        Me.lstReceived.TabIndex = 10
        Me.lstReceived.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lstReceived.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lstReceived.BackColor = System.Drawing.SystemColors.Window
        Me.lstReceived.CausesValidation = True
        Me.lstReceived.Enabled = True
        Me.lstReceived.ForeColor = System.Drawing.SystemColors.WindowText
        Me.lstReceived.IntegralHeight = True
        Me.lstReceived.Cursor = System.Windows.Forms.Cursors.Default
        Me.lstReceived.SelectionMode = System.Windows.Forms.SelectionMode.One
        Me.lstReceived.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lstReceived.Sorted = False
        Me.lstReceived.TabStop = True
        Me.lstReceived.Visible = True
        Me.lstReceived.MultiColumn = False
        Me.lstReceived.Name = "lstReceived"
        Me.Frame2.Size = New System.Drawing.Size(329, 105)
        Me.Frame2.Location = New System.Drawing.Point(176, 248)
        Me.Frame2.TabIndex = 5
        Me.Frame2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Frame2.BackColor = System.Drawing.SystemColors.Control
        Me.Frame2.Enabled = True
        Me.Frame2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Frame2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Frame2.Visible = True
        Me.Frame2.Name = "Frame2"
        Me.txtPut.AutoSize = False
        Me.txtPut.Size = New System.Drawing.Size(289, 19)
        Me.txtPut.Location = New System.Drawing.Point(16, 24)
        Me.txtPut.TabIndex = 9
        Me.txtPut.Text = "1234567890123456789012345678901234567890"
        Me.txtPut.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtPut.AcceptsReturn = True
        Me.txtPut.TextAlign = System.Windows.Forms.HorizontalAlignment.Left
        Me.txtPut.BackColor = System.Drawing.SystemColors.Window
        Me.txtPut.CausesValidation = True
        Me.txtPut.Enabled = True
        Me.txtPut.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtPut.HideSelection = True
        Me.txtPut.ReadOnly = False
        Me.txtPut.MaxLength = 0
        Me.txtPut.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtPut.Multiline = False
        Me.txtPut.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtPut.ScrollBars = System.Windows.Forms.ScrollBars.None
        Me.txtPut.TabStop = True
        Me.txtPut.Visible = True
        Me.txtPut.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.txtPut.Name = "txtPut"
        Me.cmdPutData.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        Me.cmdPutData.Text = "PutData"
        Me.cmdPutData.Size = New System.Drawing.Size(89, 25)
        Me.cmdPutData.Location = New System.Drawing.Point(216, 64)
        Me.cmdPutData.TabIndex = 8
        Me.cmdPutData.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdPutData.BackColor = System.Drawing.SystemColors.Control
        Me.cmdPutData.CausesValidation = True
        Me.cmdPutData.Enabled = True
        Me.cmdPutData.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdPutData.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdPutData.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdPutData.TabStop = True
        Me.cmdPutData.Name = "cmdPutData"
        Me.cmdPutStringCRLF.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        Me.cmdPutStringCRLF.Text = "PutStringCRLF"
        Me.cmdPutStringCRLF.Size = New System.Drawing.Size(89, 25)
        Me.cmdPutStringCRLF.Location = New System.Drawing.Point(120, 64)
        Me.cmdPutStringCRLF.TabIndex = 7
        Me.cmdPutStringCRLF.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdPutStringCRLF.BackColor = System.Drawing.SystemColors.Control
        Me.cmdPutStringCRLF.CausesValidation = True
        Me.cmdPutStringCRLF.Enabled = True
        Me.cmdPutStringCRLF.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdPutStringCRLF.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdPutStringCRLF.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdPutStringCRLF.TabStop = True
        Me.cmdPutStringCRLF.Name = "cmdPutStringCRLF"
        Me.cmdPutString.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        Me.cmdPutString.Text = "PutString"
        Me.cmdPutString.Size = New System.Drawing.Size(89, 25)
        Me.cmdPutString.Location = New System.Drawing.Point(24, 64)
        Me.cmdPutString.TabIndex = 6
        Me.cmdPutString.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdPutString.BackColor = System.Drawing.SystemColors.Control
        Me.cmdPutString.CausesValidation = True
        Me.cmdPutString.Enabled = True
        Me.cmdPutString.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdPutString.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdPutString.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdPutString.TabStop = True
        Me.cmdPutString.Name = "cmdPutString"
        Me.Frame1.Size = New System.Drawing.Size(161, 105)
        Me.Frame1.Location = New System.Drawing.Point(8, 248)
        Me.Frame1.TabIndex = 0
        Me.Frame1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Frame1.BackColor = System.Drawing.SystemColors.Control
        Me.Frame1.Enabled = True
        Me.Frame1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Frame1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Frame1.Visible = True
        Me.Frame1.Name = "Frame1"
        Me.cmdClose.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        Me.cmdClose.Text = "Close"
        Me.cmdClose.Size = New System.Drawing.Size(65, 25)
        Me.cmdClose.Location = New System.Drawing.Point(88, 64)
        Me.cmdClose.TabIndex = 4
        Me.cmdClose.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdClose.BackColor = System.Drawing.SystemColors.Control
        Me.cmdClose.CausesValidation = True
        Me.cmdClose.Enabled = True
        Me.cmdClose.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdClose.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdClose.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdClose.TabStop = True
        Me.cmdClose.Name = "cmdClose"
        Me.cmdOpen.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        Me.cmdOpen.Text = "Open"
        Me.cmdOpen.Size = New System.Drawing.Size(65, 25)
        Me.cmdOpen.Location = New System.Drawing.Point(16, 64)
        Me.cmdOpen.TabIndex = 3
        Me.cmdOpen.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdOpen.BackColor = System.Drawing.SystemColors.Control
        Me.cmdOpen.CausesValidation = True
        Me.cmdOpen.Enabled = True
        Me.cmdOpen.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdOpen.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdOpen.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdOpen.TabStop = True
        Me.cmdOpen.Name = "cmdOpen"
        Me.txtComNumber.AutoSize = False
        Me.txtComNumber.Size = New System.Drawing.Size(41, 19)
        Me.txtComNumber.Location = New System.Drawing.Point(96, 24)
        Me.txtComNumber.TabIndex = 1
        Me.txtComNumber.Text = "0"
        Me.txtComNumber.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtComNumber.AcceptsReturn = True
        Me.txtComNumber.TextAlign = System.Windows.Forms.HorizontalAlignment.Left
        Me.txtComNumber.BackColor = System.Drawing.SystemColors.Window
        Me.txtComNumber.CausesValidation = True
        Me.txtComNumber.Enabled = True
        Me.txtComNumber.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtComNumber.HideSelection = True
        Me.txtComNumber.ReadOnly = False
        Me.txtComNumber.MaxLength = 0
        Me.txtComNumber.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtComNumber.Multiline = False
        Me.txtComNumber.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtComNumber.ScrollBars = System.Windows.Forms.ScrollBars.None
        Me.txtComNumber.TabStop = True
        Me.txtComNumber.Visible = True
        Me.txtComNumber.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.txtComNumber.Name = "txtComNumber"
        Me.Label1.Text = "ComNumber"
        Me.Label1.Size = New System.Drawing.Size(58, 13)
        Me.Label1.Location = New System.Drawing.Point(24, 24)
        Me.Label1.TabIndex = 2
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
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
        Me.Label2.Text = "OnRXD event data"
        Me.Label2.Size = New System.Drawing.Size(91, 13)
        Me.Label2.Location = New System.Drawing.Point(8, 360)
        Me.Label2.TabIndex = 11
        Me.Label2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
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
        Me.Controls.Add(lstReceived)
        Me.Controls.Add(Frame2)
        Me.Controls.Add(Frame1)
        Me.Controls.Add(Label2)
        Me.Frame2.Controls.Add(txtPut)
        Me.Frame2.Controls.Add(cmdPutData)
        Me.Frame2.Controls.Add(cmdPutStringCRLF)
        Me.Frame2.Controls.Add(cmdPutString)
        Me.Frame1.Controls.Add(cmdClose)
        Me.Frame1.Controls.Add(cmdOpen)
        Me.Frame1.Controls.Add(txtComNumber)
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
        Set(ByVal Value As Form1)
            m_vb6FormDefInstance = Value
        End Set
    End Property
#End Region
    Dim DataBuffer() As Byte

    Private Sub Apax1_OnRXD(ByVal Data As Object)
        Dim i, S As Integer
        If IsArray(Data) Then
            For i = LBound(Data) To UBound(Data)
                S = S & " &H" & Hex(Data(i))
            Next
            lstReceived.Items.Add((S))
        End If
    End Sub

    Private Sub cmdClose_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdClose.Click
        Apax1.Close()
    End Sub

    Private Sub cmdOpen_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdOpen.Click
        Apax1.ComNumber = CShort(txtComNumber.Text)
        Apax1.PortOpen()
        txtComNumber.Text = CStr(Apax1.ComNumber)
    End Sub

    Private Sub cmdPutData_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdPutData.Click
        Dim i, Count As Integer
        Dim S() As Object
        Count = Len(txtPut.Text)
        ReDim S(Count)
        For i = 1 To Count
            S(i - 1) = GetChar_Renamed(txtPut.Text, i)
        Next
        Apax1.PutData(S)
    End Sub

    Private Sub cmdPutString_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdPutString.Click
        Apax1.PutString(txtPut.Text)
    End Sub

    Private Sub cmdPutStringCRLF_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdPutStringCRLF.Click
        Apax1.PutStringCRLF(txtPut.Text)
    End Sub

    Private Function GetChar_Renamed(ByVal Str_Renamed As String, ByVal Index As Short) As Byte
        GetChar_Renamed = Asc(Mid(Str_Renamed, Index, 1))
    End Function
End Class