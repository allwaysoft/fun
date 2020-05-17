VERSION 5.00
Begin VB.Form Frm_WorkBench 
   Caption         =   "Work Bench Reporting"
   ClientHeight    =   6855
   ClientLeft      =   240
   ClientTop       =   750
   ClientWidth     =   12090
   LinkTopic       =   "Form1"
   ScaleHeight     =   6855
   ScaleWidth      =   12090
   Begin VB.CheckBox Chk_Received 
      Caption         =   "Received From Repair"
      Height          =   255
      Left            =   6360
      TabIndex        =   6
      Top             =   2640
      Width           =   3135
   End
   Begin VB.CheckBox Chk_Waiting 
      Caption         =   "Still Out for Repair"
      Height          =   255
      Left            =   6360
      TabIndex        =   5
      Top             =   2280
      Width           =   3135
   End
   Begin VB.TextBox Txt_Header 
      BackColor       =   &H0080FFFF&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   855
      Left            =   600
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   36
      Top             =   240
      Width           =   11055
   End
   Begin VB.ListBox Lst_Sort 
      Height          =   645
      ItemData        =   "Frm_WorkBench.frx":0000
      Left            =   1680
      List            =   "Frm_WorkBench.frx":0020
      Sorted          =   -1  'True
      TabIndex        =   13
      Top             =   4680
      Width           =   3495
   End
   Begin VB.CommandButton Cmd_Reset_sort 
      Caption         =   "Reset Sort"
      Height          =   375
      Left            =   5400
      TabIndex        =   32
      Top             =   4920
      Width           =   1095
   End
   Begin VB.TextBox Txt_Sort 
      BackColor       =   &H0080FFFF&
      Height          =   285
      Left            =   1680
      Locked          =   -1  'True
      TabIndex        =   31
      Top             =   6120
      Width           =   5535
   End
   Begin VB.CommandButton Cmd_Process 
      Caption         =   "Process Report"
      Height          =   495
      Left            =   9120
      TabIndex        =   14
      Top             =   5160
      Width           =   1695
   End
   Begin VB.CommandButton Cmd_RecCal2 
      Caption         =   "Calendar"
      Height          =   315
      Left            =   9720
      TabIndex        =   12
      Top             =   4260
      Width           =   1335
   End
   Begin VB.TextBox Txt_EndRec_Date 
      BackColor       =   &H0080FFFF&
      Height          =   285
      Left            =   7800
      Locked          =   -1  'True
      TabIndex        =   28
      Top             =   4290
      Width           =   1815
   End
   Begin VB.CommandButton Cmd_sntCal2 
      Caption         =   "Calendar"
      Height          =   315
      Left            =   9720
      TabIndex        =   10
      Top             =   3780
      Width           =   1335
   End
   Begin VB.TextBox Txt_EndSent_Date 
      BackColor       =   &H0080FFFF&
      Height          =   285
      Left            =   7800
      Locked          =   -1  'True
      TabIndex        =   27
      Top             =   3810
      Width           =   1815
   End
   Begin VB.TextBox Txt_EndCol_Date 
      BackColor       =   &H0080FFFF&
      Height          =   285
      Left            =   7800
      Locked          =   -1  'True
      TabIndex        =   25
      Top             =   3330
      Width           =   1815
   End
   Begin VB.CommandButton Cmd_ColCal2 
      Caption         =   "Calendar"
      Height          =   315
      Left            =   9720
      TabIndex        =   8
      Top             =   3300
      Width           =   1335
   End
   Begin VB.TextBox Txt_STRec_Date 
      BackColor       =   &H0080FFFF&
      Height          =   285
      Left            =   3240
      Locked          =   -1  'True
      TabIndex        =   23
      Top             =   4290
      Width           =   1815
   End
   Begin VB.CommandButton Cmd_RecCal1 
      Caption         =   "Calendar"
      Height          =   315
      Left            =   5160
      TabIndex        =   11
      Top             =   4260
      Width           =   1335
   End
   Begin VB.TextBox Txt_StSent_Date 
      BackColor       =   &H0080FFFF&
      Height          =   285
      Left            =   3240
      Locked          =   -1  'True
      TabIndex        =   21
      Top             =   3810
      Width           =   1815
   End
   Begin VB.CommandButton Cmd_sntCal1 
      Caption         =   "Calendar"
      Height          =   315
      Left            =   5160
      TabIndex        =   9
      Top             =   3780
      Width           =   1335
   End
   Begin VB.TextBox Txt_StCol_date 
      BackColor       =   &H0080FFFF&
      Height          =   285
      Left            =   3240
      Locked          =   -1  'True
      TabIndex        =   19
      Top             =   3330
      Width           =   1815
   End
   Begin VB.CommandButton Cmd_ColCal1 
      Caption         =   "Calendar"
      Height          =   315
      Left            =   5160
      TabIndex        =   7
      Top             =   3300
      Width           =   1335
   End
   Begin VB.ListBox Lst_Location 
      Height          =   840
      ItemData        =   "Frm_WorkBench.frx":00BC
      Left            =   2040
      List            =   "Frm_WorkBench.frx":00BE
      MultiSelect     =   2  'Extended
      TabIndex        =   4
      Top             =   2280
      Width           =   3375
   End
   Begin VB.TextBox Txt_Serialno 
      Height          =   285
      Left            =   2040
      TabIndex        =   3
      Top             =   1800
      Width           =   2055
   End
   Begin VB.ComboBox Cbo_StPartno 
      Height          =   315
      Left            =   2040
      TabIndex        =   0
      Top             =   1320
      Width           =   4455
   End
   Begin VB.ComboBox Cbo_EndPartno 
      Height          =   315
      Left            =   7320
      TabIndex        =   2
      Top             =   1320
      Width           =   4215
   End
   Begin VB.Label Label 
      Caption         =   "Sort Order"
      Height          =   255
      Index           =   9
      Left            =   360
      TabIndex        =   35
      Top             =   4800
      Width           =   1215
   End
   Begin VB.Label Label 
      Caption         =   "(Default is Part#/Serial#/Collect date"
      ForeColor       =   &H00FF0000&
      Height          =   255
      Index           =   10
      Left            =   1680
      TabIndex        =   34
      Top             =   5520
      Width           =   3495
   End
   Begin VB.Label Label13 
      Caption         =   "Pick up to 3 sort parameters.  "
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   1680
      TabIndex        =   33
      Top             =   5760
      Width           =   3495
   End
   Begin VB.Label Label 
      Caption         =   "Thru"
      Height          =   255
      Index           =   8
      Left            =   6720
      TabIndex        =   30
      Top             =   4320
      Width           =   615
   End
   Begin VB.Label Label 
      Caption         =   "Thru"
      Height          =   255
      Index           =   7
      Left            =   6720
      TabIndex        =   29
      Top             =   3840
      Width           =   615
   End
   Begin VB.Label Label 
      Caption         =   "Thru"
      Height          =   255
      Index           =   6
      Left            =   6720
      TabIndex        =   26
      Top             =   3360
      Width           =   615
   End
   Begin VB.Label Label 
      Caption         =   "Date Returned From Work Bench"
      Height          =   255
      Index           =   5
      Left            =   360
      TabIndex        =   24
      Top             =   4320
      Width           =   2415
   End
   Begin VB.Label Label 
      Caption         =   "Date Sent To Work Bench"
      Height          =   255
      Index           =   4
      Left            =   360
      TabIndex        =   22
      Top             =   3840
      Width           =   2415
   End
   Begin VB.Label Label 
      Caption         =   "Date Collected from Satellite"
      Height          =   255
      Index           =   3
      Left            =   360
      TabIndex        =   20
      Top             =   3360
      Width           =   2415
   End
   Begin VB.Label Label 
      Caption         =   "Location"
      Height          =   255
      Index           =   2
      Left            =   360
      TabIndex        =   18
      Top             =   2280
      Width           =   1575
   End
   Begin VB.Label Label9 
      Caption         =   "(multiselect)"
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   1080
      TabIndex        =   17
      Top             =   2520
      Width           =   855
   End
   Begin VB.Label Label 
      Caption         =   "Serial Number"
      Height          =   255
      Index           =   1
      Left            =   360
      TabIndex        =   16
      Top             =   1800
      Width           =   1455
   End
   Begin VB.Label Label 
      Caption         =   "S&&B Part Number"
      Height          =   255
      Index           =   0
      Left            =   360
      TabIndex        =   15
      Top             =   1320
      Width           =   1455
   End
   Begin VB.Label Label12 
      Caption         =   "Thru"
      Height          =   255
      Left            =   6600
      TabIndex        =   1
      Top             =   1320
      Width           =   495
   End
End
Attribute VB_Name = "Frm_WorkBench"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim idx As Long
Dim ent_part As String
Dim ent_part2 As String


Private Sub Cbo_EndPartno_KeyPress(KeyAscii As Integer)
    
    If KeyAscii = 8 Then
        If Len(ent_part2) <= 1 Then
            ent_part2 = ""
            Cbo_EndPartno.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    ent_part2 = ent_part2 & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_EndPartno, KeyAscii, True)

End Sub

Private Sub Cbo_StPartno_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        If Len(ent_part) <= 1 Then
            ent_part = ""
            Cbo_StPartno.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    ent_part = ent_part & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_StPartno, KeyAscii, True)

End Sub

Private Sub Cmd_ColCal1_Click()

    Txt_StCol_date.Text = Calendar_date(Txt_StCol_date.Text)

End Sub

Private Sub Cmd_ColCal2_Click()

    Txt_EndCol_Date.Text = Calendar_date(Txt_StCol_date.Text)
    If Txt_StCol_date.Text > Txt_EndCol_Date.Text Then
        MsgBox ("The Ending date must be Greater or Equal to the starting date")
    End If
End Sub


Private Sub Cmd_Process_Click()
    Rpt_sPartno = 0
    Rpt_ePartno = 0
    Rpt_Serial = ""
    If Chk_Waiting = 1 And Chk_Received = 1 Then
        Chk_Waiting.Value = 0
        Chk_Received.Value = 0
        MsgBox ("You can't selecte both received and pending receipts on the report this way."), vbOKOnly
        
        Exit Sub
    End If
    Rpt_Text1 = "Item Range = ALL"
    If Cbo_StPartno.ListIndex <> -1 Then
        Rpt_sPartno = Cbo_StPartno.ItemData(Cbo_StPartno.ListIndex)
        Rpt_ePartno = Cbo_EndPartno.ItemData(Cbo_EndPartno.ListIndex)
        Rpt_Text1 = "Item Range = " & Cbo_StPartno.ItemData(Cbo_StPartno.ListIndex) & " thru " & Trim(Cbo_EndPartno.ItemData(Cbo_EndPartno.ListIndex))
    End If
    Rpt_Text2 = "Serial # = ALL"

    Rpt_Serial = ""
    
    If Txt_Serialno.Text <> "" Then
        Rpt_Text2 = Trim(Txt_Serialno.Text)
        Rpt_Serial = " awb.awb_serialno = '" & Trim(Txt_Serialno.Text) & "'"
    End If
    
    Loc_String = "("
    Rpt_Text3 = "Locations = "
    For idx = 0 To Lst_Location.ListCount - 1
        If Lst_Location.Selected(idx) = True Then
            If Trim(Loc_String) > "(" Then Loc_String = Loc_String & ", "
            Loc_String = Loc_String & Lst_Location.ItemData(idx)
            Rpt_Text3 = Rpt_Text3 + Trim(Mid(Lst_Location.List(idx), 1, 5)) & ", "
        End If
    Next

    Loc_String = Loc_String & ")"
    If Loc_String = "()" Then
        Loc_String = ""
        Rpt_Text3 = "Locations = All"
    End If
    
    
    ColDate_String = ""
    If Txt_StCol_date.Text = "" Then
    Rpt_Text4 = "Collect Date Range = ALL"
    Else
        If Txt_StCol_date.Text = Txt_EndCol_Date.Text Then
            ColDate_String = "awb.awb_date_collected = CONVERT(DATETIME,'" & Txt_StCol_date.Text & "')"
            Rpt_Text4 = " Date Range = " & Txt_StCol_date.Text
        Else
            ColDate_String = "awb.awb_date_collected between CONVERT(DATETIME,'" & Txt_StCol_date.Text & "') and CONVERT(DATETIME,'" & Txt_EndCol_Date.Text & "')"
            Rpt_Text4 = "Collect Date Range = " & Txt_StCol_date.Text & " thru " & Txt_EndCol_Date.Text
        End If
    End If
        
    SentDate_String = ""
    If Txt_StSent_Date.Text = "" Then
    Rpt_Text5 = "Sent Date Range = ALL"
    Else
        If Txt_StSent_Date.Text = Txt_EndSent_Date.Text Then
            SentDate_String = "awb.awb_date_sent = CONVERT(DATETIME,'" & Txt_StSent_Date.Text & "')"
            Rpt_Text5 = " Date Range = " & Txt_StSent_Date.Text
        Else
            SentDate_String = "awb.awb_date_sent between CONVERT(DATETIME,'" & Txt_StSent_Date.Text & "') and CONVERT(DATETIME,'" & Txt_EndSent_Date.Text & "')"
            Rpt_Text5 = "Sent Date Range = " & Txt_StSent_Date.Text & " thru " & Txt_EndSent_Date.Text
        End If
    End If
    RecDate_String = ""
    If Txt_STRec_Date.Text = "" Then
    Rpt_Text6 = "Received Date Range = ALL"
    Else
        If Txt_STRec_Date.Text = Txt_EndRec_Date.Text Then
            RecDate_String = "awb.awb_date_back = CONVERT(DATETIME,'" & Txt_STRec_Date.Text & "')"
            Rpt_Text6 = " Date Range = " & Txt_STRec_Date.Text
        Else
            RecDate_String = "awb.awb_date_back between CONVERT(DATETIME,'" & Txt_STRec_Date.Text & "') and CONVERT(DATETIME,'" & Txt_EndRec_Date.Text & "')"
            Rpt_Text6 = "Received Date Range = " & Txt_STRec_Date.Text & " thru " & Txt_EndRec_Date.Text
        End If
    End If
    Rpt_Outstanding = ""
    If Chk_Waiting.Value = 1 Then
        Rpt_Outstanding = "Y"
    End If
    If Chk_Received.Value = 1 Then
        Rpt_Outstanding = "N"
    End If
        
    
    Frm_RptViewer.Show vbModal

End Sub

Private Sub Cmd_RecCal1_Click()
    Txt_STRec_Date.Text = Calendar_date(Txt_STRec_Date.Text)

End Sub

Private Sub Cmd_RecCal2_Click()

    Txt_EndRec_Date.Text = Calendar_date(Txt_STRec_Date.Text)
    If Txt_EndRec_Date.Text < Txt_STRec_Date.Text Then
        MsgBox ("The Ending date must be Greater or Equal to the starting date")
    End If
End Sub

Private Sub Cmd_Reset_sort_Click()
    For idx = 0 To Lst_Location.ListCount - 1
        Lst_Location.Selected(idx) = False
    Next
    Rpt_Sort1 = 0
    Rpt_Sort2 = 0
    Rpt_Sort3 = 0
    Txt_Sort.Text = ""

End Sub

Private Sub Cmd_sntCal1_Click()
    Txt_StSent_Date.Text = Calendar_date(Txt_StSent_Date.Text)

End Sub

Private Sub Cmd_sntCal2_Click()
    
    Txt_EndSent_Date.Text = Calendar_date(Txt_StSent_Date.Text)
    If Txt_EndSent_Date.Text < Txt_StSent_Date.Text Then
        MsgBox ("The Ending date must be Greater or Equal to the starting date")
    End If

End Sub

Private Sub Form_Load()
    Call Cbo_Partno_Load
    Call Lst_Location_Load
    Rpt_Text7 = "Sort Options = Part Number/Date Collected/Date Sent"
    Txt_Header.Text = "Enter information in the fields you would like the report to be filtered on.  If you dont want the filter to apply, don't entery anything in the field.  Date Ranges will include the entered dates."
    
End Sub
Public Sub Cbo_Partno_Load()
    sSql = "select ai_index,ai_partno,AI_Description,AI_Parttype from AFC_Inventory"
    Call Get_Inventory("Read")
    Cbo_StPartno.Clear
    Cbo_EndPartno.Clear

    Do While RS_Inventory.EOF = False

        If Trim(RS_Inventory("AI_PartType")) = Trim("UNIT") Then
        Else
            Cbo_StPartno.AddItem (RS_Inventory("ai_partno") & " -  " & Mid(Trim(RS_Inventory("ai_description")), 1, 20))
            Cbo_StPartno.ItemData(Cbo_StPartno.NewIndex) = RS_Inventory("ai_partno")

            Cbo_EndPartno.AddItem ((RS_Inventory("ai_partno") & " -  " & Mid(Trim(RS_Inventory("ai_description")), 1, 20)))
            Cbo_EndPartno.ItemData(Cbo_EndPartno.NewIndex) = RS_Inventory("ai_partno")
        End If
themove:
        RS_Inventory.MoveNext
        DoEvents
    Loop
    Call Get_Inventory("Close")
End Sub

Public Sub Lst_Location_Load()
    sSql = "select * from afc_location where al_location_Type = 17"
    Call Get_Inventory("Read")
    Lst_Location.Clear

    Do While RS_Inventory.EOF = False
        Lst_Location.AddItem (Mid(RS_Inventory("al_abrv"), 1, 5) & " -  " & Trim(RS_Inventory("al_location_Name")))
        Lst_Location.ItemData(Lst_Location.NewIndex) = RS_Inventory("al_id")
        
        RS_Inventory.MoveNext
    Loop
    Call Get_Inventory("Close")

End Sub

Private Sub Lst_Sort_Click()
    For idx = 0 To Lst_Sort.ListCount - 1
        If Lst_Sort.Selected(idx) = True And Lst_Sort.ItemData(Lst_Sort.ListIndex) <> Rpt_Sort1 And Lst_Sort.ItemData(Lst_Sort.ListIndex) <> Rpt_Sort2 And Lst_Sort.ItemData(Lst_Sort.ListIndex) <> Rpt_Sort3 Then
        If Rpt_Sort1 = 0 Then
            Rpt_Sort1 = Lst_Sort.ItemData(Lst_Sort.ListIndex)
            Rpt_Text7 = "Sort Options = " & Trim(Lst_Sort.List(Lst_Sort.ListIndex))
            Txt_Sort.Text = Trim(Lst_Sort.List(Lst_Sort.ListIndex))
        ElseIf Rpt_Sort2 = 0 Then
            Rpt_Sort2 = Lst_Sort.ItemData(Lst_Sort.ListIndex)
            Rpt_Text7 = Rpt_Text7 & "/" & Trim(Lst_Sort.List(Lst_Sort.ListIndex))
            Txt_Sort.Text = Txt_Sort.Text & "/" & Trim(Lst_Sort.List(Lst_Sort.ListIndex))
        ElseIf Rpt_Sort3 = 0 Then
            Rpt_Sort3 = Lst_Sort.ItemData(Lst_Sort.ListIndex)
            Rpt_Text7 = Rpt_Text7 & "/" & Trim(Lst_Sort.List(Lst_Sort.ListIndex))
            Txt_Sort.Text = Txt_Sort.Text & "/" & Trim(Lst_Sort.List(Lst_Sort.ListIndex))
        Else
            MsgBox ("You have picked too many Sort Parameters.  Reset and start over")
            Exit Sub
        End If
        End If
    Next
End Sub

