VERSION 5.00
Begin VB.Form Frm_Incident_Counts 
   Caption         =   "Incident Count Criteria"
   ClientHeight    =   3765
   ClientLeft      =   1095
   ClientTop       =   1560
   ClientWidth     =   10725
   LinkTopic       =   "Form1"
   ScaleHeight     =   3765
   ScaleWidth      =   10725
   Begin VB.CommandButton Cmd_Clear 
      Caption         =   "Clear Entries"
      Height          =   735
      Left            =   6120
      TabIndex        =   14
      Top             =   2640
      Width           =   1335
   End
   Begin VB.CommandButton Cmd_Process 
      Caption         =   "Process Report"
      Height          =   735
      Left            =   8400
      TabIndex        =   13
      Top             =   2640
      Width           =   1335
   End
   Begin VB.Frame Fra3 
      Height          =   735
      Left            =   600
      TabIndex        =   7
      Top             =   1680
      Width           =   8775
      Begin VB.OptionButton Opt_ADA 
         Caption         =   "ADA Gate"
         Height          =   195
         Left            =   3600
         TabIndex        =   12
         Top             =   240
         Width           =   1215
      End
      Begin VB.OptionButton Opt_HS 
         Caption         =   "High Speed Gate"
         Height          =   195
         Left            =   4920
         TabIndex        =   11
         Top             =   240
         Width           =   1695
      End
      Begin VB.OptionButton Opt_FB 
         Caption         =   "Farebox"
         Height          =   195
         Left            =   6840
         TabIndex        =   10
         Top             =   240
         Width           =   1455
      End
      Begin VB.OptionButton Opt_CL 
         Caption         =   "Cashless TVM"
         Height          =   195
         Left            =   1920
         TabIndex        =   9
         Top             =   240
         Width           =   1455
      End
      Begin VB.OptionButton Opt_FS 
         Caption         =   "Full Service TVM"
         Height          =   195
         Left            =   240
         TabIndex        =   8
         Top             =   240
         Width           =   1695
      End
   End
   Begin VB.Frame Fra1 
      Height          =   1215
      Left            =   600
      TabIndex        =   0
      Top             =   360
      Width           =   8775
      Begin VB.CommandButton Cmd_Cal2 
         Caption         =   "Calendar"
         Height          =   375
         Left            =   6840
         TabIndex        =   6
         Top             =   480
         Width           =   855
      End
      Begin VB.CommandButton Cmd_Cal1 
         Caption         =   "Calendar"
         Height          =   375
         Left            =   3120
         TabIndex        =   5
         Top             =   480
         Width           =   855
      End
      Begin VB.TextBox Txt_Enddate 
         BackColor       =   &H00C0FFFF&
         Height          =   285
         Left            =   5160
         Locked          =   -1  'True
         TabIndex        =   4
         Top             =   480
         Width           =   1455
      End
      Begin VB.TextBox Txt_Stdate 
         BackColor       =   &H00C0FFFF&
         Height          =   285
         Left            =   1560
         Locked          =   -1  'True
         TabIndex        =   1
         Top             =   480
         Width           =   1335
      End
      Begin VB.Label Label2 
         Caption         =   "To"
         Height          =   255
         Left            =   4440
         TabIndex        =   3
         Top             =   480
         Width           =   375
      End
      Begin VB.Label Label1 
         Caption         =   "Incident Date"
         Height          =   255
         Left            =   240
         TabIndex        =   2
         Top             =   480
         Width           =   1215
      End
   End
End
Attribute VB_Name = "Frm_Incident_Counts"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

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

Private Sub Cmd_Process_Click()
    
    If Txt_Stdate = "" Then
        MsgBox (" A date range must be selected"), vbOKOnly
        Exit Sub
    End If
    
    If Opt_FS.Value = False And Opt_CL.Value = False And Opt_ADA.Value = False And Opt_HS.Value = False And Opt_FB.Value = False Then
        MsgBox (" A device type must be selected"), vbOKOnly
        Exit Sub
    End If

    St_Date = Txt_Stdate.Text
    End_Date = Txt_Enddate.Text
    R_Branch = 2
    
    If Opt_FS.Value = True Then
        String1 = "Device_Type: Full Service TVM's"
        St_Device = "201000"
        End_Device = "202000"
        R_Branch = 2
    End If
    
    If Opt_CL.Value = True Then
        String1 = "Device_Type: Cashless TVM's"
        St_Device = "202000"
        End_Device = "203000"
        R_Branch = 2
    End If

    If Opt_ADA.Value = True Then
        String1 = "Device_Type: ADA Gates"
        St_Device = "441000"
        End_Device = "442000"
        R_Branch = 2
    End If

    If Opt_HS.Value = True Then
        String1 = "Device_Type: High speed Gates"
        St_Device = "411000"
        End_Device = "412000"
        R_Branch = 2
    End If

    If Opt_FB.Value = True Then
        String1 = "Device_Type: Farebox's"
        St_Device = ""
        End_Device = "999999"
        R_Branch = 3
    End If
    
    
    
    Report_Name = "Incident_Counts"
    Frm_Report.Show vbModal
    
End Sub
