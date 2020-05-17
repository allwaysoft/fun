VERSION 5.00
Begin VB.Form Frm_Location 
   Caption         =   "Location Selection"
   ClientHeight    =   2220
   ClientLeft      =   1605
   ClientTop       =   1755
   ClientWidth     =   8625
   LinkTopic       =   "Form2"
   ScaleHeight     =   2220
   ScaleWidth      =   8625
   Begin VB.CommandButton Cmd_Run 
      Caption         =   "Process Report"
      Height          =   495
      Left            =   5640
      TabIndex        =   4
      Top             =   1440
      Width           =   1215
   End
   Begin VB.CommandButton Cmd_Close 
      Caption         =   "Exit"
      Height          =   495
      Left            =   7080
      TabIndex        =   3
      Top             =   1440
      Width           =   1215
   End
   Begin VB.ComboBox Cbo_Loc 
      Height          =   315
      Left            =   2040
      TabIndex        =   0
      Top             =   840
      Width           =   3855
   End
   Begin VB.Label Label2 
      Caption         =   "Select a location for the report."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   240
      TabIndex        =   2
      Top             =   240
      Width           =   4935
   End
   Begin VB.Label Label1 
      Caption         =   "Location"
      Height          =   255
      Left            =   240
      TabIndex        =   1
      Top             =   840
      Width           =   1575
   End
End
Attribute VB_Name = "Frm_Location"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim sline As String

Private Sub Cmd_Close_Click()
Unload Me
End Sub

Private Sub Cmd_Run_Click()
    If Cbo_Loc.ListIndex = -1 Then
        MsgBox ("A Location must be selected")
        Exit Sub
    End If
    Rpt_Location = Cbo_Loc.ItemData(Cbo_Loc.ListIndex)
    Unload Me
End Sub

Private Sub Form_Load()
    Rpt_Location = 0
    sSql = "select * from afc_location where al_location_type in (1,2)"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        sline = Trim(RS_Trans("AL_Abrv")) & "  " & _
        Trim(RS_Trans("AL_Location_Name"))
            Cbo_Loc.AddItem sline
            Cbo_Loc.ItemData(Cbo_Loc.NewIndex) = RS_Trans("al_id")
        RS_Trans.MoveNext
    Loop
End Sub
