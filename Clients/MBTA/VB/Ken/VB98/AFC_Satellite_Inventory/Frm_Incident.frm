VERSION 5.00
Begin VB.Form Frm_Incident 
   Caption         =   "Incident Reporting"
   ClientHeight    =   9345
   ClientLeft      =   135
   ClientTop       =   465
   ClientWidth     =   11715
   LinkTopic       =   "Form1"
   ScaleHeight     =   9345
   ScaleWidth      =   11715
   Begin VB.Frame Fra_Totals 
      Caption         =   "Total Section"
      Height          =   2055
      Left            =   360
      TabIndex        =   55
      Top             =   6840
      Width           =   11175
      Begin VB.ComboBox Cbo_Group1 
         Height          =   315
         ItemData        =   "Frm_Incident.frx":0000
         Left            =   6120
         List            =   "Frm_Incident.frx":002E
         TabIndex        =   64
         Text            =   " "
         Top             =   480
         Width           =   2295
      End
      Begin VB.ComboBox Cbo_Group2 
         Height          =   315
         ItemData        =   "Frm_Incident.frx":00CA
         Left            =   6120
         List            =   "Frm_Incident.frx":00F8
         TabIndex        =   63
         Text            =   " "
         Top             =   840
         Width           =   2295
      End
      Begin VB.ComboBox Cbo_Group3 
         Height          =   315
         ItemData        =   "Frm_Incident.frx":0193
         Left            =   6120
         List            =   "Frm_Incident.frx":01C1
         TabIndex        =   62
         Text            =   " "
         Top             =   1200
         Width           =   2295
      End
      Begin VB.ComboBox Cbo_Group4 
         Height          =   315
         ItemData        =   "Frm_Incident.frx":025D
         Left            =   6120
         List            =   "Frm_Incident.frx":028B
         TabIndex        =   61
         Text            =   " "
         Top             =   1560
         Width           =   2295
      End
      Begin VB.ComboBox Cbo_Sort1 
         Height          =   315
         ItemData        =   "Frm_Incident.frx":0327
         Left            =   8760
         List            =   "Frm_Incident.frx":0334
         TabIndex        =   60
         Text            =   " "
         Top             =   480
         Width           =   1935
      End
      Begin VB.ComboBox Cbo_Sort2 
         Height          =   315
         ItemData        =   "Frm_Incident.frx":0352
         Left            =   8760
         List            =   "Frm_Incident.frx":035F
         TabIndex        =   59
         Text            =   " "
         Top             =   840
         Width           =   1935
      End
      Begin VB.ComboBox Cbo_Sort3 
         Height          =   315
         ItemData        =   "Frm_Incident.frx":037D
         Left            =   8760
         List            =   "Frm_Incident.frx":038A
         TabIndex        =   58
         Text            =   " "
         Top             =   1200
         Width           =   1935
      End
      Begin VB.ComboBox Cbo_Sort4 
         Height          =   315
         ItemData        =   "Frm_Incident.frx":03A8
         Left            =   8760
         List            =   "Frm_Incident.frx":03B5
         TabIndex        =   57
         Text            =   " "
         Top             =   1560
         Width           =   1935
      End
      Begin VB.TextBox Text1 
         BackColor       =   &H0080FFFF&
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1695
         Left            =   240
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   56
         Text            =   "Frm_Incident.frx":03D3
         Top             =   240
         Width           =   3735
      End
      Begin VB.Label Label 
         Caption         =   "Sorting"
         Height          =   255
         Index           =   21
         Left            =   9000
         TabIndex        =   70
         Top             =   120
         Width           =   1575
      End
      Begin VB.Label Label 
         Alignment       =   1  'Right Justify
         Caption         =   "Grand Total"
         Height          =   255
         Index           =   16
         Left            =   4800
         TabIndex        =   69
         Top             =   660
         Width           =   1005
      End
      Begin VB.Label Label 
         Alignment       =   1  'Right Justify
         Caption         =   "Sub Total 1"
         Height          =   255
         Index           =   17
         Left            =   4800
         TabIndex        =   68
         Top             =   1020
         Width           =   1005
      End
      Begin VB.Label Label 
         Alignment       =   1  'Right Justify
         Caption         =   "Sub Total 2"
         Height          =   255
         Index           =   18
         Left            =   4800
         TabIndex        =   67
         Top             =   1380
         Width           =   1005
      End
      Begin VB.Label Label 
         Alignment       =   1  'Right Justify
         Caption         =   "Sub Total 3"
         Height          =   255
         Index           =   19
         Left            =   4800
         TabIndex        =   66
         Top             =   1740
         Width           =   1005
      End
      Begin VB.Label Label 
         Caption         =   "Grouping"
         Height          =   255
         Index           =   20
         Left            =   6360
         TabIndex        =   65
         Top             =   120
         Width           =   1575
      End
   End
   Begin VB.Frame Fra_Sorting 
      Caption         =   "Sort Options"
      Height          =   2055
      Left            =   360
      TabIndex        =   46
      Top             =   6600
      Width           =   11055
      Begin VB.CommandButton Cmd_Res_Sort 
         Caption         =   "Reset Sort"
         Height          =   375
         Left            =   5400
         TabIndex        =   54
         Top             =   1560
         Width           =   1815
      End
      Begin VB.TextBox Txt_Sort 
         BackColor       =   &H0080FFFF&
         Height          =   285
         Left            =   240
         Locked          =   -1  'True
         TabIndex        =   53
         Top             =   1680
         Width           =   4695
      End
      Begin VB.ComboBox Cbo_Group 
         Height          =   315
         ItemData        =   "Frm_Incident.frx":03D9
         Left            =   6600
         List            =   "Frm_Incident.frx":03F8
         TabIndex        =   50
         Top             =   360
         Width           =   3495
      End
      Begin VB.ListBox Lst_Sort 
         Height          =   645
         ItemData        =   "Frm_Incident.frx":0474
         Left            =   1200
         List            =   "Frm_Incident.frx":0490
         MultiSelect     =   2  'Extended
         TabIndex        =   48
         Top             =   360
         Width           =   3495
      End
      Begin VB.Label Label19 
         Caption         =   "Pick up to 2 sort parameters.  "
         ForeColor       =   &H00FF0000&
         Height          =   255
         Left            =   240
         TabIndex        =   52
         Top             =   1440
         Width           =   3495
      End
      Begin VB.Label Label20 
         Caption         =   "(Default is Date Reported/Location Name"
         ForeColor       =   &H00FF0000&
         Height          =   255
         Left            =   240
         TabIndex        =   51
         Top             =   1200
         Width           =   3495
      End
      Begin VB.Label Label17 
         Caption         =   "Report Grouping for counts"
         Height          =   495
         Left            =   5040
         TabIndex        =   49
         Top             =   360
         Width           =   1335
      End
      Begin VB.Label Label18 
         Caption         =   "Sort Options"
         Height          =   255
         Left            =   240
         TabIndex        =   47
         Top             =   360
         Width           =   1215
      End
   End
   Begin VB.Frame Fra_Replacement 
      Caption         =   "Replaced Component"
      Height          =   855
      Left            =   360
      TabIndex        =   43
      Top             =   4680
      Width           =   5175
      Begin VB.ComboBox Cbo_Iparts 
         Height          =   315
         Left            =   840
         TabIndex        =   45
         Top             =   360
         Width           =   4095
      End
      Begin VB.Label Label21 
         Caption         =   "Part#"
         Height          =   255
         Left            =   120
         TabIndex        =   44
         Top             =   360
         Width           =   615
      End
   End
   Begin VB.CommandButton Cmd_ResetScr 
      BackColor       =   &H00FF8080&
      Caption         =   "Reset Entry Screen"
      Height          =   495
      Left            =   5760
      Style           =   1  'Graphical
      TabIndex        =   42
      Top             =   8760
      Width           =   1815
   End
   Begin VB.Frame Frm_Status 
      Caption         =   "Status Tracking (Multi Select)"
      Height          =   2055
      Left            =   5760
      TabIndex        =   32
      Top             =   3000
      Width           =   5535
      Begin VB.ListBox Lst_Action 
         Height          =   450
         ItemData        =   "Frm_Incident.frx":04F8
         Left            =   1800
         List            =   "Frm_Incident.frx":04FA
         MultiSelect     =   2  'Extended
         TabIndex        =   38
         Top             =   1440
         Width           =   3135
      End
      Begin VB.ListBox Lst_Defect 
         Height          =   450
         ItemData        =   "Frm_Incident.frx":04FC
         Left            =   1800
         List            =   "Frm_Incident.frx":04FE
         MultiSelect     =   2  'Extended
         TabIndex        =   37
         Top             =   840
         Width           =   3135
      End
      Begin VB.ListBox Lst_Arival 
         Height          =   450
         ItemData        =   "Frm_Incident.frx":0500
         Left            =   1800
         List            =   "Frm_Incident.frx":0502
         MultiSelect     =   2  'Extended
         TabIndex        =   36
         Top             =   240
         Width           =   3135
      End
      Begin VB.Label Label 
         Caption         =   "Action Performed"
         Height          =   255
         Index           =   11
         Left            =   120
         TabIndex        =   35
         Top             =   1560
         Width           =   1455
      End
      Begin VB.Label Label 
         Caption         =   "Defect Found"
         Height          =   255
         Index           =   10
         Left            =   240
         TabIndex        =   34
         Top             =   960
         Width           =   1455
      End
      Begin VB.Label Label 
         Caption         =   "Status on Arival"
         Height          =   255
         Index           =   9
         Left            =   120
         TabIndex        =   33
         Top             =   360
         Width           =   1455
      End
   End
   Begin VB.Frame Frm_Employee 
      Caption         =   "Employee Tracking"
      Height          =   1575
      Left            =   360
      TabIndex        =   25
      Top             =   3000
      Width           =   5175
      Begin VB.ComboBox Cbo_ClosedBy 
         Height          =   315
         Left            =   1800
         TabIndex        =   31
         Text            =   " "
         Top             =   1080
         Width           =   3135
      End
      Begin VB.ComboBox Cbo_CompletedBy 
         Height          =   315
         Left            =   1800
         TabIndex        =   29
         Top             =   720
         Width           =   3135
      End
      Begin VB.ComboBox Cbo_CreatedBy 
         Height          =   315
         Left            =   1800
         TabIndex        =   27
         Top             =   360
         Width           =   3135
      End
      Begin VB.Label Label 
         Caption         =   "Incident Closed By"
         Height          =   255
         Index           =   8
         Left            =   240
         TabIndex        =   30
         Top             =   1080
         Width           =   1575
      End
      Begin VB.Label Label 
         Caption         =   "Incident Completed By"
         Height          =   255
         Index           =   7
         Left            =   120
         TabIndex        =   28
         Top             =   720
         Width           =   1695
      End
      Begin VB.Label Label 
         Caption         =   "Incident Created By"
         Height          =   255
         Index           =   6
         Left            =   120
         TabIndex        =   26
         Top             =   360
         Width           =   1575
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "Line/Station Options"
      Height          =   1335
      Left            =   360
      TabIndex        =   20
      Top             =   1560
      Width           =   10935
      Begin VB.ComboBox Cbo_MaintSec 
         Height          =   315
         ItemData        =   "Frm_Incident.frx":0504
         Left            =   8400
         List            =   "Frm_Incident.frx":053A
         TabIndex        =   40
         Top             =   600
         Width           =   2175
      End
      Begin VB.ListBox Lst_Stations 
         Height          =   840
         ItemData        =   "Frm_Incident.frx":05E0
         Left            =   4560
         List            =   "Frm_Incident.frx":05E2
         MultiSelect     =   2  'Extended
         TabIndex        =   23
         Top             =   360
         Width           =   2415
      End
      Begin VB.ListBox Lst_Lines 
         Height          =   840
         ItemData        =   "Frm_Incident.frx":05E4
         Left            =   1320
         List            =   "Frm_Incident.frx":05E6
         MultiSelect     =   2  'Extended
         TabIndex        =   21
         Top             =   360
         Width           =   1815
      End
      Begin VB.Label Label 
         Alignment       =   2  'Center
         Caption         =   "OR Service-Area "
         Height          =   495
         Index           =   5
         Left            =   7200
         TabIndex        =   39
         Top             =   480
         Width           =   1095
      End
      Begin VB.Label Label 
         Alignment       =   2  'Center
         Caption         =   "OR Stations/Garage (Multi)"
         Height          =   735
         Index           =   4
         Left            =   3240
         TabIndex        =   24
         Top             =   360
         Width           =   1215
      End
      Begin VB.Label Label 
         Alignment       =   2  'Center
         Caption         =   "Subway Line (Multi)"
         Height          =   495
         Index           =   3
         Left            =   240
         TabIndex        =   22
         Top             =   480
         Width           =   975
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Device Options"
      Height          =   1335
      Left            =   360
      TabIndex        =   13
      Top             =   120
      Width           =   10935
      Begin VB.CheckBox Chk_Rst 
         Alignment       =   1  'Right Justify
         Caption         =   "RST Devices Only"
         Height          =   255
         Left            =   6720
         TabIndex        =   41
         Top             =   600
         Width           =   1815
      End
      Begin VB.ListBox Lst_Item_Types 
         Height          =   840
         ItemData        =   "Frm_Incident.frx":05E8
         Left            =   3840
         List            =   "Frm_Incident.frx":05EA
         MultiSelect     =   2  'Extended
         TabIndex        =   19
         Top             =   360
         Width           =   2415
      End
      Begin VB.ComboBox Cbo_SDevice 
         Height          =   315
         Left            =   1080
         TabIndex        =   16
         Top             =   300
         Width           =   1575
      End
      Begin VB.ComboBox Cbo_EDevice 
         Height          =   315
         Left            =   1080
         TabIndex        =   15
         Top             =   840
         Width           =   1575
      End
      Begin VB.Label Label 
         Alignment       =   2  'Center
         Caption         =   "OR Device-Type (Multi)"
         Height          =   735
         Index           =   2
         Left            =   2760
         TabIndex        =   18
         Top             =   480
         Width           =   975
      End
      Begin VB.Label Label 
         Caption         =   "Thru"
         Height          =   255
         Index           =   1
         Left            =   1680
         TabIndex        =   17
         Top             =   600
         Width           =   495
      End
      Begin VB.Label Label 
         Caption         =   "Device #"
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   14
         Top             =   360
         Width           =   735
      End
   End
   Begin VB.CommandButton Cmd_ColCal4 
      Caption         =   "Calendar"
      Height          =   315
      Left            =   8880
      TabIndex        =   12
      Top             =   6120
      Width           =   1335
   End
   Begin VB.TextBox Txt_EClosed 
      BackColor       =   &H0080FFFF&
      Height          =   285
      Left            =   6840
      Locked          =   -1  'True
      TabIndex        =   11
      Top             =   6150
      Width           =   1815
   End
   Begin VB.CommandButton Cmd_ColCal3 
      Caption         =   "Calendar"
      Height          =   315
      Left            =   4680
      TabIndex        =   9
      Top             =   6120
      Width           =   1335
   End
   Begin VB.TextBox Txt_SClosed 
      BackColor       =   &H0080FFFF&
      Height          =   285
      Left            =   2400
      Locked          =   -1  'True
      TabIndex        =   8
      Top             =   6150
      Width           =   1815
   End
   Begin VB.CommandButton Cmd_Col_Cal2 
      Caption         =   "Calendar"
      Height          =   315
      Left            =   8880
      TabIndex        =   6
      Top             =   5640
      Width           =   1335
   End
   Begin VB.TextBox Txt_ECreated 
      BackColor       =   &H0080FFFF&
      Height          =   285
      Left            =   6840
      Locked          =   -1  'True
      TabIndex        =   5
      Top             =   5670
      Width           =   1815
   End
   Begin VB.CommandButton Cmd_ColCal1 
      Caption         =   "Calendar"
      Height          =   315
      Left            =   4680
      TabIndex        =   3
      Top             =   5640
      Width           =   1335
   End
   Begin VB.TextBox Txt_SCreated 
      BackColor       =   &H0080FFFF&
      Height          =   285
      Left            =   2400
      Locked          =   -1  'True
      TabIndex        =   2
      Top             =   5670
      Width           =   1815
   End
   Begin VB.CommandButton Cmd_Process 
      Caption         =   "Process Report"
      Height          =   495
      Left            =   9480
      TabIndex        =   0
      Top             =   8760
      Width           =   1815
   End
   Begin VB.Label Label 
      Caption         =   "Thru"
      Height          =   255
      Index           =   15
      Left            =   6240
      TabIndex        =   10
      Top             =   6180
      Width           =   495
   End
   Begin VB.Label Label 
      Caption         =   "Date Closed"
      Height          =   255
      Index           =   13
      Left            =   840
      TabIndex        =   7
      Top             =   6120
      Width           =   1455
   End
   Begin VB.Label Label 
      Caption         =   "Thru"
      Height          =   255
      Index           =   14
      Left            =   6240
      TabIndex        =   4
      Top             =   5700
      Width           =   495
   End
   Begin VB.Label Label 
      Caption         =   "Date Created"
      Height          =   255
      Index           =   12
      Left            =   840
      TabIndex        =   1
      Top             =   5640
      Width           =   1455
   End
End
Attribute VB_Name = "Frm_Incident"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim sline As String
Dim index As Long
Dim Ent_Dev
Dim hold_keyascii As Long
Dim testd1 As Date
Dim testd2 As Date


Private Sub Cbo_EDevice_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        If Len(Ent_Dev) <= 1 Then
            Ent_Dev = ""
            Cbo_EDevice.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    Ent_Dev = Ent_Dev & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_EDevice, KeyAscii, True)

End Sub





Private Sub Cbo_SDevice_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        If Len(Ent_Dev) <= 1 Then
            Ent_Dev = ""
            Cbo_SDevice.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    Ent_Dev = Ent_Dev & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_SDevice, KeyAscii, True)

End Sub

Private Sub Cmd_Col_Cal2_Click()
    Txt_ECreated.Text = Calendar_date(Txt_SCreated.Text)

End Sub

Private Sub Cmd_ColCal1_Click()
    Txt_SCreated.Text = Calendar_date(Txt_SCreated.Text)

End Sub

Private Sub Cmd_ColCal3_Click()
    Txt_SClosed.Text = Calendar_date(Txt_SClosed.Text)

End Sub

Private Sub Cmd_ColCal4_Click()
    Txt_EClosed.Text = Calendar_date(Txt_SClosed.Text)

End Sub

Private Sub Cmd_Process_Click()
Dim tester As Integer
Dim step As Integer

Device_String = " "
Subway = " "
Created_By = 0
Closed_By = 0
Completed_By = 0
Arival = " "
Defect = " "
Action = " "
Date_Created = " "
Date_Closed = " "
'Range of
    
    step = 0
    Rpt_Text1 = "Devices: All"
    If Cbo_SDevice.ListIndex <> -1 Then
        Device_String = " cast(au.au_mbtano as nvarchar(10)) >='" & CLng(Cbo_SDevice.ItemData(Cbo_SDevice.ListIndex)) & "' and cast(au.au_mbtano as nvarchar(10)) <='" & CLng(Cbo_EDevice.ItemData(Cbo_EDevice.ListIndex)) & "'"
        Rpt_Text1 = "Device Range: " & CLng(Cbo_SDevice.ItemData(Cbo_SDevice.ListIndex)) & " thru " & CLng(Cbo_EDevice.ItemData(Cbo_EDevice.ListIndex))
    Else
        Rpt_Text1 = "Devices: "
        Device_String = "ai.ai_unit_type in (0"
        For index = 0 To Lst_Item_Types.ListCount - 1
            If Lst_Item_Types.Selected(index) = True And Lst_Item_Types.ItemData(index) <> 0 Then
                Device_String = Trim(Device_String) & "," & Lst_Item_Types.ItemData(index)
                Rpt_Text1 = Rpt_Text1 & Lst_Item_Types.List(index) & " "
            End If
        Next
        Device_String = Trim(Device_String) & ")"
        If Device_String = "ai.ai_unit_type in (0)" Then Device_String = " "
        Device_String = Replace(Device_String, "(0,", "(")
    
    End If
    If Chk_Rst.Value = 1 Then
        Rpt_Text1 = Rpt_Text1 & " RST Only"
        If Device_String <> " " Then
            Device_String = Device_String & " and isnull(au.au_rst,'''') = 'Y' "
            Rpt_Text1 = Rpt_Text1 & " RST Only"
        Else
            Device_String = " isnull(au.au_rst,'''') = 'Y' "
        End If
    End If
'check to see if multiple device options selected


' Criteria based on subway location's where clause setup
    Rpt_Text2 = "Line/Station: "
    Subway = "al.al_line in (0"
    For index = 0 To Lst_Lines.ListCount - 1
        If Lst_Lines.Selected(index) = True And Lst_Lines.ItemData(index) <> 0 Then
            Subway = Trim(Subway) & "," & Lst_Lines.ItemData(index)
            Rpt_Text2 = Rpt_Text2 & Lst_Lines.List(index)
        End If
    Next
        Subway = Trim(Subway) & ")"
        If Subway = "al.al_line in (0)" Then
            Subway = " "
            Rpt_Text2 = "Line/Station: All"
        Else
            Subway = Replace(Subway, "(0,", "(")
            GoTo Skip_Rest
        End If
        
    Rpt_Text2 = "Line/Station: "
    Subway = "al.al_id in (0"
    For index = 0 To Lst_Stations.ListCount - 1
        If Lst_Stations.Selected(index) = True And Lst_Stations.ItemData(index) <> 0 Then
            Subway = Trim(Subway) & "," & Lst_Stations.ItemData(index)
            Rpt_Text2 = Rpt_Text2 & Lst_Stations.List(index)
        End If
    Next
        Subway = Subway & Trim(Stations) & ")"
        If Subway = "al.al_id in (0)" Then
            Subway = " "
            Rpt_Text2 = "Line/Station: All"
        Else
            Subway = Replace(Subway, "(0,", "(")
            GoTo Skip_Rest
        End If
    If Cbo_MaintSec.ListIndex <> -1 Then
        Subway = " isnull(al.al_maint_Section,0) = " & CLng(Cbo_MaintSec.ItemData(Cbo_MaintSec.ListIndex))
        Rpt_Text2 = "Line/Station: " & Cbo_MaintSec.List(Cbo_MaintSec.ListIndex)
    End If
    
    step = 0
    
Skip_Rest:
    If Subway <> " " Then step = step + 1

    If step > 1 Then
        MsgBox ("You can only select one Line/Station option... Not multiples."), vbOKOnly
        Exit Sub
    End If

' Employee selection where clause setup
    Rpt_Text8 = "Created By: All "
    If Cbo_CreatedBy.ListIndex > 0 Then
        Created_By = CLng(Cbo_CreatedBy.ItemData(Cbo_CreatedBy.ListIndex))
        Rpt_Text8 = "Created By: " & Cbo_CreatedBy.List(Cbo_CreatedBy.ListIndex)
    End If
    
    Rpt_Text9 = "Completed By: All "
    If Cbo_CompletedBy.ListIndex > 0 Then
        Completed_By = CLng(Cbo_CompletedBy.ItemData(Cbo_CompletedBy.ListIndex))
        Rpt_Text9 = "Completed By: " & Cbo_CompletedBy.List(Cbo_CompletedBy.ListIndex)
    End If
    

    Rpt_Text10 = "Closed By: All "
    If Cbo_ClosedBy.ListIndex > 0 Then
        Closed_By = CLng(Cbo_ClosedBy.ItemData(Cbo_ClosedBy.ListIndex))
        Rpt_Text10 = "Closed By: " & Cbo_ClosedBy.List(Cbo_ClosedBy.ListIndex)
    End If

' Status Tracking where clause setup
    Rpt_Text3 = "Arival Status's: "
    Arival = "(0"
    For index = 0 To Lst_Arival.ListCount - 1
        If Lst_Arival.Selected(index) = True And Lst_Arival.ItemData(index) <> 0 Then
            Arival = Trim(Arival) & "," & Lst_Arival.ItemData(index)
            Rpt_Text3 = Rpt_Text3 & Lst_Arival.List(index) & " "
        End If
    Next
        Arival = Trim(Arival) & ")"
        If Arival = "(0)" Then
            Arival = " "
            Rpt_Text3 = "Arival Status's: All"
        End If
        Arival = Replace(Arival, "(0,", "(")
        
    Defect = "(0"
    Rpt_Text4 = "Defects's: "
    For index = 0 To Lst_Defect.ListCount - 1
        If Lst_Defect.Selected(index) = True And Lst_Defect.ItemData(index) <> 0 Then
            Defect = Trim(Defect) & "," & Lst_Defect.ItemData(index)
            Rpt_Text4 = Rpt_Text4 & Lst_Defect.List(index) & " "
        End If
    Next
        Defect = Trim(Defect) & ")"
        If Defect = "(0)" Then
            Defect = " "
            Rpt_Text4 = "Defects: All"
        End If
        Defect = Replace(Defect, "(0,", "(")
    
    Rpt_Text5 = "Action's: "
    Action = "(0"
    For index = 0 To Lst_Action.ListCount - 1
        If Lst_Action.Selected(index) = True And Lst_Action.ItemData(index) <> 0 Then
            Action = Trim(Action) & "," & Lst_Action.ItemData(index)
            Rpt_Text5 = Rpt_Text5 & Lst_Action.List(index) & " "
        End If
    Next
        Action = Trim(Action) & ")"
        If Action = "(0)" Then
            Action = " "
            Rpt_Text5 = "Action's: All"
        End If
        Action = Replace(Action, "(0,", "(")
    Rpt_Text6 = "Created Date: All"
    
    
    If Txt_SCreated.Text <> "" Then
        testd1 = Format(Txt_SCreated.Text, "mm/dd/yyyy")
        testd2 = Format(Txt_ECreated.Text, "mm/dd/yyyy")
        If testd1 <= testd2 Then
            Date_Created = " CAST(FLOOR(CAST(i.I_DT_Reported AS float)) AS datetime) >= '" & Trim(Txt_SCreated.Text) & "' and CAST(FLOOR(CAST(i.I_DT_Reported AS float)) AS datetime) <= '" & Txt_ECreated.Text & "'"
            Rpt_Text6 = "Date Created: " & Trim(Txt_SCreated.Text) & " Thru " & Trim(Txt_ECreated.Text)
        End If
    End If
    
    Rpt_Text7 = "Date Closed: All"

    If Txt_SClosed.Text <> "" Then
        testd1 = Format(Txt_SClosed.Text, "mm/dd/yyyy")
        testd2 = Format(Txt_EClosed.Text, "mm/dd/yyyy")
        If testd1 <= testd2 Then
            Date_Closed = " CAST(FLOOR(CAST(i.I_DT_Reported AS float)) AS datetime) >= '" & Trim(Txt_SClosed.Text) & "' and CAST(FLOOR(CAST(i.I_DT_Reported AS float)) AS datetime) <= '" & Txt_EClosed.Text & "'"
            Rpt_Text7 = "Date Closed: " & Trim(Txt_SClosed.Text) & " Thru " & Trim(Txt_EClosed.Text)
        End If
    End If
    
    Rpt_Text11 = "Group by: Device #"
    
    
' replacement parts
    Rpt_Text13 = "Replaced Parts: All"
    If Cbo_Iparts.ListIndex <> -1 Then
        Rpt_Text13 = "Replaced Parts: " & Cbo_Iparts.Text
        Rpt_sPartno = Cbo_Iparts.ItemData(Cbo_Iparts.ListIndex)
    End If
'Setup date created where clause

    If Report_Name = "Incident Detail" Then
        If Cbo_Group.ListIndex <> -1 Then
            Rpt_Group = Cbo_Group.ItemData(Cbo_Group.ListIndex)
            Rpt_Text11 = "Group by: " & Cbo_Group.List(Cbo_Group.ListIndex)
        End If
    Else
        Rpt_Group2 = 0
        Rpt_Group3 = 0
        Rpt_Group4 = 0
        If Cbo_Group1.ListIndex <> -1 Then
            Rpt_Group1 = Cbo_Group1.ItemData(Cbo_Group1.ListIndex)
            Rpt_Text11 = "Group by: " & Trim(Cbo_Group1.List(Cbo_Group1.ListIndex))
            Rpt_Group1_order = Cbo_Sort1.ItemData(Cbo_Sort1.ListIndex)
            If Rpt_Group1_order = 0 Then Rpt_Group1_order = 1
        Else
            MsgBox ("You must select a Primary Group,  The report will not function with out a primary group"), vbOKOnly
            Exit Sub
        End If
        If Cbo_Group2.ListIndex <> -1 Then
            Rpt_Group2 = Cbo_Group2.ItemData(Cbo_Group2.ListIndex)
            Rpt_Text11 = Rpt_Text11 & ", " & Trim(Cbo_Group2.List(Cbo_Group2.ListIndex))
            Rpt_Group2_order = Cbo_Sort2.ItemData(Cbo_Sort2.ListIndex)
            If Rpt_Group2_order = 0 Then Rpt_Group2_order = 1
        End If
        If Cbo_Group3.ListIndex <> -1 Then
            Rpt_Group3 = Cbo_Group3.ItemData(Cbo_Group3.ListIndex)
            Rpt_Text11 = Rpt_Text11 & ", " & Trim(Cbo_Group3.List(Cbo_Group3.ListIndex))
            Rpt_Group3_order = Cbo_Sort3.ItemData(Cbo_Sort3.ListIndex)
            If Rpt_Group3_order = 0 Then Rpt_Group3_order = 1
        End If
        If Cbo_Group4.ListIndex <> -1 Then
            Rpt_Group4 = Cbo_Group4.ItemData(Cbo_Group4.ListIndex)
            Rpt_Text11 = Rpt_Text11 & ", " & Trim(Cbo_Group4.List(Cbo_Group4.ListIndex))
            Rpt_Group4_order = Cbo_Sort4.ItemData(Cbo_Sort4.ListIndex)
            If Rpt_Group4_order = 0 Then Rpt_Group4_order = 1
        End If
    End If
    
    Frm_RptViewer.Show vbModal

End Sub

Private Sub Cmd_Res_Sort_Click()
    Rpt_Text11 = ""
    Rpt_Sort1 = 0
    Rpt_Sort2 = 0
    Txt_Sort = ""
End Sub

Private Sub Cmd_ResetScr_Click()
    Cbo_SDevice.ListIndex = -1
    Cbo_EDevice.ListIndex = -1
    For index = 0 To Lst_Item_Types.ListCount - 1
        Lst_Item_Types.Selected(index) = False
    Next
    Chk_Rst.Value = 0
    For index = 0 To Lst_Lines.ListCount - 1
        Lst_Lines.Selected(index) = False
    Next
    For index = 0 To Lst_Stations.ListCount - 1
        Lst_Stations.Selected(index) = False
    Next
    Cbo_MaintSec.ListIndex = -1
    Cbo_CreatedBy.ListIndex = -1
    Cbo_CompletedBy.ListIndex = -1
    Cbo_ClosedBy.ListIndex = -1
    For index = 0 To Lst_Arival.ListCount - 1
        Lst_Arival.Selected(index) = False
    Next
    For index = 0 To Lst_Defect.ListCount - 1
        Lst_Defect.Selected(index) = False
    Next
    For index = 0 To Lst_Action.ListCount - 1
        Lst_Action.Selected(index) = False
    Next
    Txt_SCreated.Text = ""
    Txt_ECreated.Text = ""
    Txt_SClosed.Text = ""
    Txt_EClosed.Text = ""
    Cbo_Group.ListIndex = -1
    For index = 0 To Lst_Sort.ListCount - 1
        Lst_Sort.Selected(index) = False
    Next
    Txt_Sort.Text = ""
    Cbo_Group1.ListIndex = -1
    Cbo_Group2.ListIndex = -1
    Cbo_Group3.ListIndex = -1
    Cbo_Group4.ListIndex = -1
    Cbo_Sort1.ListIndex = -1
    Cbo_Sort2.ListIndex = -1
    Cbo_Sort3.ListIndex = -1
    Cbo_Sort4.ListIndex = -1

End Sub

Private Sub Form_Load()
    If Report_Name = "Incident Totals" Then
        Fra_Totals.Visible = True
        Fra_Totals.Left = 360
        Fra_Totals.Top = 6600
    Else
        Fra_Totals.Visible = False
    End If

    Rpt_Text12 = "Sort Options = Date Reported/Location"
    Text1.Text = "Select the order in wich you would like to see totals.  1 total and 3 subtotals are available.  If subtotals are not desired don't select a group."
    
' load the device # combo boxes for a device range
    
    sSql = "SELECT CAST(AFC_UnitTable.AU_MBTAno AS numeric) AS deviceno, AFC_Parttypes.APTabrv " & _
    "FROM  AFC_Inventory " & _
    "LEFT OUTER JOIN AFC_Parttypes ON AFC_Inventory.AI_Unit_Type = AFC_Parttypes.APTidx " & _
    "Left OUTER JOIN AFC_UnitTable ON AFC_Inventory.AI_Index = AFC_UnitTable.AU_Partno " & _
    "WHERE (AFC_UnitTable.AU_MBTAno <> ' ') AND (AFC_UnitTable.AU_MBTAno <> 'end') and afc_inventory.AI_Unit_type <> 13 ORDER BY deviceno"
    Call Get_Trans("Read")
    
    Do While RS_Trans.EOF = False
        Cbo_SDevice.AddItem CStr(RS_Trans("deviceno")) & " " & RS_Trans("aptabrv")
        Cbo_SDevice.ItemData(Cbo_SDevice.NewIndex) = RS_Trans("deviceno")

        Cbo_EDevice.AddItem CStr(RS_Trans("deviceno")) & " " & RS_Trans("aptabrv")
        Cbo_EDevice.ItemData(Cbo_SDevice.NewIndex) = RS_Trans("deviceno")
        RS_Trans.MoveNext
    Loop
    
    Call Get_Trans("Close")
    
'Load the Device type list box
    sSql = "select * from AFC_Parttypes"
    Call Get_Trans("Read")
    Lst_Item_Types.AddItem " "
    Lst_Item_Types.ItemData(Lst_Item_Types.NewIndex) = 0
    Do While RS_Trans.EOF = False
        Lst_Item_Types.AddItem RS_Trans("APTdesc")
        Lst_Item_Types.ItemData(Lst_Item_Types.NewIndex) = RS_Trans("APTidx")
        RS_Trans.MoveNext
    Loop
    Call Get_Trans("Close")

'Load the Line List box

    sSql = "select * from afc_locationtype where alt_line = 'Y'"
    Call Get_Trans("Read")
    Lst_Lines.AddItem " "
    Lst_Lines.ItemData(Lst_Lines.NewIndex) = 0

    Do While RS_Trans.EOF = False
        Lst_Lines.AddItem RS_Trans("alt_description")
        Lst_Lines.ItemData(Lst_Lines.NewIndex) = RS_Trans("alt_index")
        RS_Trans.MoveNext
    Loop
    Call Get_Trans("Close")
    
' Load the location list box
    sSql = "select * from afc_location where al_location_type in (5,19,20) order by al_location_name"
    Call Get_Trans("Read")
    Lst_Stations.AddItem " "
    Lst_Stations.ItemData(Lst_Stations.NewIndex) = 0

    Do While RS_Trans.EOF = False
        Lst_Stations.AddItem RS_Trans("al_location_name")
        Lst_Stations.ItemData(Lst_Stations.NewIndex) = RS_Trans("al_id")
        RS_Trans.MoveNext
    Loop
    Call Get_Trans("Close")
    
    sSql = "select * from afc_technicians order by at_emplname"
    Call Get_Trans("Read")
    Cbo_CreatedBy.AddItem " "
    Cbo_CreatedBy.ItemData(Cbo_CreatedBy.NewIndex) = 0
    Cbo_CompletedBy.AddItem " "
    Cbo_CompletedBy.ItemData(Cbo_CompletedBy.NewIndex) = 0
    Cbo_ClosedBy.AddItem " "
    Cbo_ClosedBy.ItemData(Cbo_ClosedBy.NewIndex) = 0

    Do While RS_Trans.EOF = False

        Cbo_CreatedBy.AddItem Trim(RS_Trans("at_emplname")) & ", " & Trim(RS_Trans("at_empfname"))
        Cbo_CreatedBy.ItemData(Cbo_CreatedBy.NewIndex) = RS_Trans("at_id")
        
        Cbo_CompletedBy.AddItem Trim(RS_Trans("at_emplname")) & ", " & Trim(RS_Trans("at_empfname"))
        Cbo_CompletedBy.ItemData(Cbo_CompletedBy.NewIndex) = RS_Trans("at_id")
        
        Cbo_ClosedBy.AddItem Trim(RS_Trans("at_emplname")) & ", " & Trim(RS_Trans("at_empfname"))
        Cbo_ClosedBy.ItemData(Cbo_ClosedBy.NewIndex) = RS_Trans("at_id")
        RS_Trans.MoveNext
    Loop
    Call Get_Trans("Close")
    
    sSql = "select * from incident_codes where ic_type = 2"
    Call Get_Trans("Read")
    Lst_Arival.AddItem " "
    Lst_Arival.ItemData(Lst_Arival.NewIndex) = 0
    Lst_Defect.AddItem " "
    Lst_Defect.ItemData(Lst_Defect.NewIndex) = 0

    Do While RS_Trans.EOF = False
        Lst_Arival.AddItem RS_Trans("IC_Description")
        Lst_Arival.ItemData(Lst_Arival.NewIndex) = RS_Trans("IC_ID")
        
        Lst_Defect.AddItem RS_Trans("IC_Description")
        Lst_Defect.ItemData(Lst_Defect.NewIndex) = RS_Trans("IC_ID")
        
        RS_Trans.MoveNext
    Loop
    
    Call Get_Trans("Close")
    sSql = "select * from incident_codes where ic_type = 3"
    Call Get_Trans("Read")
    Lst_Action.AddItem " "
    Lst_Action.ItemData(Lst_Action.NewIndex) = 0

    Do While RS_Trans.EOF = False
        Lst_Action.AddItem RS_Trans("IC_Description")
        Lst_Action.ItemData(Lst_Action.NewIndex) = RS_Trans("IC_ID")
        RS_Trans.MoveNext
    Loop
' load the Part replaced lookup

    sSql = "SELECT DISTINCT AFC_Inventory.AI_Index, AFC_Inventory.AI_Partno, AFC_Inventory.AI_Description" & _
    " FROM Incident_Parts INNER JOIN " & _
    "AFC_Inventory ON Incident_Parts.IP_PartIndex = AFC_Inventory.AI_Index"
    Set RS_Trans = New ADODB.Recordset
    Set RS_Trans = SQLData.Execute(sSql)
    Do While RS_Trans.EOF = False
        Cbo_Iparts.AddItem Trim(RS_Trans("ai_partno")) & " " & RS_Trans("Ai_Description")
        Cbo_Iparts.ItemData(Cbo_Iparts.NewIndex) = RS_Trans("Ai_index")
        RS_Trans.MoveNext
    Loop
    
    Call Get_Trans("Close")
    If Current_User_Level <> 9 Then
        Frm_Employee.Visible = False
    End If
    
    If Report_Name = "Mean Time" Then
        Frm_Status.Visible = False
        Fra_Totals.Visible = False
        Fra_Replacement.Visible = False
        Fra_Sorting.Visible = False
        
    End If
End Sub

Private Sub Lst_Sort_Click()
    For index = 0 To Lst_Sort.ListCount - 1
        If Lst_Sort.Selected(index) = True And Lst_Sort.ItemData(Lst_Sort.ListIndex) <> Rpt_Sort1 And Lst_Sort.ItemData(Lst_Sort.ListIndex) <> Rpt_Sort2 Then 'And Lst_Sort.ItemData(Lst_Sort.ListIndex) <> Rpt_Sort3 Then
            If Rpt_Sort1 = 0 Then
                Rpt_Sort1 = Lst_Sort.ItemData(Lst_Sort.ListIndex)
                Rpt_Text12 = "Sort Options = " & Trim(Lst_Sort.List(Lst_Sort.ListIndex))
                Txt_Sort.Text = Trim(Lst_Sort.List(Lst_Sort.ListIndex))
            ElseIf Rpt_Sort2 = 0 Then
                Rpt_Sort2 = Lst_Sort.ItemData(Lst_Sort.ListIndex)
                Rpt_Text12 = Rpt_Text12 & "/" & Trim(Lst_Sort.List(Lst_Sort.ListIndex))
                Txt_Sort.Text = Txt_Sort.Text & "/" & Trim(Lst_Sort.List(Lst_Sort.ListIndex))
            Else
                MsgBox ("You have picked too many Sort Parameters.  Reset and start over")
                Exit Sub
            End If
        End If
    Next

End Sub

