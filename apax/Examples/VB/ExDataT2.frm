VERSION 5.00
Begin VB.Form DlgAddTrigger 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Dialog Caption"
   ClientHeight    =   2625
   ClientLeft      =   2760
   ClientTop       =   3750
   ClientWidth     =   6030
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2625
   ScaleWidth      =   6030
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkEnabled 
      Alignment       =   1  'Right Justify
      Caption         =   "&Enabled"
      Enabled         =   0   'False
      Height          =   495
      Left            =   2640
      TabIndex        =   11
      TabStop         =   0   'False
      Top             =   960
      Width           =   975
   End
   Begin VB.TextBox txtTriggerString 
      Height          =   285
      Left            =   1440
      TabIndex        =   0
      Top             =   480
      Width           =   4215
   End
   Begin VB.Frame Frame1 
      Height          =   1935
      Left            =   120
      TabIndex        =   7
      Top             =   120
      Width           =   5775
      Begin VB.CheckBox chkIgnoreCase 
         Alignment       =   1  'Right Justify
         Caption         =   "Ignore Case"
         Height          =   495
         Left            =   3720
         TabIndex        =   4
         Top             =   1320
         Width           =   1575
      End
      Begin VB.CheckBox chkIncludeStrings 
         Alignment       =   1  'Right Justify
         Caption         =   "Include Strings"
         Height          =   495
         Left            =   3720
         TabIndex        =   3
         Top             =   840
         Width           =   1575
      End
      Begin VB.TextBox txtTimeout 
         Height          =   285
         Left            =   1320
         TabIndex        =   2
         Text            =   "0"
         Top             =   1320
         Width           =   855
      End
      Begin VB.TextBox txtPacketSize 
         Height          =   285
         Left            =   1320
         TabIndex        =   1
         Text            =   "0"
         Top             =   840
         Width           =   855
      End
      Begin VB.Label Label3 
         AutoSize        =   -1  'True
         Caption         =   "&Timeout (ms)"
         Height          =   195
         Left            =   240
         TabIndex        =   10
         Top             =   1320
         Width           =   900
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         Caption         =   "&Packet Size"
         Height          =   195
         Left            =   240
         TabIndex        =   9
         Top             =   840
         Width           =   855
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "Trigger &String"
         Height          =   195
         Left            =   240
         TabIndex        =   8
         Top             =   360
         Width           =   945
      End
   End
   Begin VB.CommandButton CancelButton 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   375
      Left            =   4680
      TabIndex        =   6
      TabStop         =   0   'False
      Top             =   2160
      Width           =   1215
   End
   Begin VB.CommandButton OKButton 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   3360
      TabIndex        =   5
      Top             =   2160
      Width           =   1215
   End
End
Attribute VB_Name = "DlgAddTrigger"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Public TriggerString As String
Public PacketSize As Integer
Public Timeout As Integer
Public IncludeStrings As Boolean
Public IgnoreCase As Boolean
Public TriggerEnabled As Boolean
Public ModalResult As Boolean

Private Sub CancelButton_Click()
  ModalResult = False
  Hide
End Sub

Private Sub Form_Activate()
  txtTriggerString.Text = ""
  txtPacketSize.Text = "0"
  txtTimeout.Text = "0"
  chkIncludeStrings.Value = 1
  chkIgnoreCase.Value = 1
  chkEnabled.Value = 1
End Sub

Private Sub OKButton_Click()
  TriggerString = txtTriggerString.Text
  PacketSize = CInt(txtPacketSize.Text)
  Timeout = CInt(txtTimeout.Text)
  IncludeStrings = chkIncludeStrings.Value
  IgnoreCase = chkIgnoreCase.Value
  TriggerEnabled = chkEnabled.Value
  ModalResult = True
  Hide
End Sub
