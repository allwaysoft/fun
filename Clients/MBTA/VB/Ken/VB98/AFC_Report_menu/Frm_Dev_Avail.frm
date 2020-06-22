VERSION 5.00
Begin VB.Form Frm_Dev_Avail 
   Caption         =   "Device Availity Report"
   ClientHeight    =   3675
   ClientLeft      =   1275
   ClientTop       =   1425
   ClientWidth     =   10320
   LinkTopic       =   "Form1"
   ScaleHeight     =   3675
   ScaleWidth      =   10320
   Begin VB.CommandButton Cmd_Clear 
      Caption         =   "Clear Entries"
      Height          =   735
      Left            =   6960
      TabIndex        =   13
      Top             =   2880
      Width           =   1335
   End
   Begin VB.CommandButton Cmd_Proc 
      Caption         =   "Process Report"
      Height          =   735
      Left            =   8760
      TabIndex        =   12
      Top             =   2880
      Width           =   1335
   End
   Begin VB.Frame Fra2 
      Height          =   975
      Left            =   2280
      TabIndex        =   7
      Top             =   1680
      Width           =   5655
      Begin VB.TextBox Txt_EndHour 
         Height          =   285
         Left            =   4560
         TabIndex        =   11
         Top             =   360
         Width           =   735
      End
      Begin VB.TextBox txt_StHour 
         Height          =   285
         Left            =   1800
         TabIndex        =   9
         Top             =   360
         Width           =   735
      End
      Begin VB.Label Label5 
         Caption         =   "End Hour (5-25)"
         Height          =   255
         Left            =   3000
         TabIndex        =   10
         Top             =   390
         Width           =   1335
      End
      Begin VB.Label Label3 
         Caption         =   "Start Hour (5-25)"
         Height          =   255
         Left            =   240
         TabIndex        =   8
         Top             =   390
         Width           =   1455
      End
   End
   Begin VB.Frame Fra1 
      Height          =   1215
      Left            =   960
      TabIndex        =   0
      Top             =   360
      Width           =   8775
      Begin VB.TextBox Txt_Stdate 
         BackColor       =   &H00C0FFFF&
         Height          =   285
         Left            =   1560
         Locked          =   -1  'True
         TabIndex        =   4
         Top             =   480
         Width           =   1335
      End
      Begin VB.TextBox Txt_Enddate 
         BackColor       =   &H00C0FFFF&
         Height          =   285
         Left            =   5160
         Locked          =   -1  'True
         TabIndex        =   3
         Top             =   480
         Width           =   1455
      End
      Begin VB.CommandButton Cmd_Cal1 
         Caption         =   "Calendar"
         Height          =   375
         Left            =   3120
         TabIndex        =   2
         Top             =   480
         Width           =   855
      End
      Begin VB.CommandButton Cmd_Cal2 
         Caption         =   "Calendar"
         Height          =   375
         Left            =   6840
         TabIndex        =   1
         Top             =   480
         Width           =   855
      End
      Begin VB.Label Label1 
         Caption         =   "Availability Date"
         Height          =   255
         Left            =   240
         TabIndex        =   6
         Top             =   480
         Width           =   1215
      End
      Begin VB.Label Label2 
         Caption         =   "To"
         Height          =   255
         Left            =   4440
         TabIndex        =   5
         Top             =   480
         Width           =   375
      End
   End
End
Attribute VB_Name = "Frm_Dev_Avail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Cmd_Clear_Click()
txt_StHour = ""
Txt_EndHour = ""
Txt_Stdate = ""
Txt_Enddate = ""

End Sub

Private Sub Cmd_Proc_Click()
    If Txt_Stdate = "" Then
        MsgBox (" A date range must be selected"), vbOKOnly
        Exit Sub
    End If
    

    St_Date = Txt_Stdate.Text
    End_Date = Txt_Enddate.Text
    StHour = txt_StHour
    EndHour = Txt_EndHour
    Report_Name = "Availibility"
    Frm_Report.Show vbModal
    Report_Name = ""

End Sub

Private Sub Cmd_Cal1_Click()
    Txt_Stdate.Text = Calendar_date(Txt_Stdate.Text)

End Sub

Private Sub Cmd_Cal2_Click()
    
    Txt_Enddate.Text = Calendar_date(Txt_Stdate.Text)
          If Format(Txt_Stdate.Text, "mm/dd/yyyy") > Format(Txt_Enddate.Text, "mm/dd/yyyy") Then
            MsgBox ("The ending date has to be greater than the starting date")
            Exit Sub
        End If
End Sub

