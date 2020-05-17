VERSION 5.00
Begin VB.Form Frm_Trans_History 
   Caption         =   "Transaction History Reporting"
   ClientHeight    =   6555
   ClientLeft      =   60
   ClientTop       =   570
   ClientWidth     =   11535
   LinkTopic       =   "Form1"
   ScaleHeight     =   6555
   ScaleWidth      =   11535
   Begin VB.TextBox Txt_Sort 
      BackColor       =   &H0080FFFF&
      Height          =   285
      Left            =   1920
      Locked          =   -1  'True
      TabIndex        =   27
      Top             =   5760
      Width           =   5535
   End
   Begin VB.CommandButton Cmd_Reset_sort 
      Caption         =   "Reset Sort"
      Height          =   375
      Left            =   5640
      TabIndex        =   26
      Top             =   4560
      Width           =   1095
   End
   Begin VB.ListBox Lst_Sort 
      Height          =   645
      ItemData        =   "Frm_trans_history.frx":0000
      Left            =   1920
      List            =   "Frm_trans_history.frx":0022
      Sorted          =   -1  'True
      TabIndex        =   14
      Top             =   4440
      Width           =   3495
   End
   Begin VB.ListBox Lst_Tran_Type 
      Height          =   840
      ItemData        =   "Frm_trans_history.frx":00A8
      Left            =   1920
      List            =   "Frm_trans_history.frx":00AA
      MultiSelect     =   2  'Extended
      TabIndex        =   10
      Top             =   2760
      Width           =   3375
   End
   Begin VB.CommandButton Cmd_Process_report 
      Caption         =   "Process Report"
      Height          =   495
      Left            =   8760
      TabIndex        =   15
      Top             =   5280
      Width           =   2415
   End
   Begin VB.ComboBox Cbo_Employee 
      Height          =   315
      Left            =   7200
      TabIndex        =   9
      Top             =   2280
      Width           =   3135
   End
   Begin VB.ListBox Lst_Location 
      Height          =   840
      ItemData        =   "Frm_trans_history.frx":00AC
      Left            =   7200
      List            =   "Frm_trans_history.frx":00AE
      MultiSelect     =   2  'Extended
      TabIndex        =   11
      Top             =   2760
      Width           =   3375
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
      Left            =   240
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      TabIndex        =   20
      Top             =   480
      Width           =   11055
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Calendar"
      Height          =   315
      Left            =   9360
      TabIndex        =   13
      Top             =   3840
      Width           =   1335
   End
   Begin VB.CommandButton Cmd_Cal1 
      Caption         =   "Calendar"
      Height          =   315
      Left            =   3840
      TabIndex        =   12
      Top             =   3840
      Width           =   1335
   End
   Begin VB.ComboBox Cbo_EndPartno 
      Height          =   315
      Left            =   7200
      TabIndex        =   7
      Top             =   1800
      Width           =   4215
   End
   Begin VB.TextBox Txt_EndTranDate 
      BackColor       =   &H0080FFFF&
      Height          =   285
      Left            =   7200
      Locked          =   -1  'True
      TabIndex        =   18
      Top             =   3840
      Width           =   1815
   End
   Begin VB.TextBox Txt_StTranDate 
      BackColor       =   &H0080FFFF&
      Height          =   285
      Left            =   1920
      Locked          =   -1  'True
      TabIndex        =   16
      Top             =   3840
      Width           =   1815
   End
   Begin VB.TextBox Txt_Serialno 
      Height          =   285
      Left            =   1920
      TabIndex        =   8
      Top             =   2280
      Width           =   2055
   End
   Begin VB.ComboBox Cbo_StPartno 
      Height          =   315
      Left            =   1920
      TabIndex        =   6
      Top             =   1800
      Width           =   4455
   End
   Begin VB.Label Label 
      Caption         =   "Pick up to 2 sort parameters.  "
      ForeColor       =   &H00FF0000&
      Height          =   255
      Index           =   11
      Left            =   1920
      TabIndex        =   25
      Top             =   5400
      Width           =   3495
   End
   Begin VB.Label Label 
      Caption         =   "(Default is Part#/Location/Datetime"
      ForeColor       =   &H00FF0000&
      Height          =   255
      Index           =   10
      Left            =   1920
      TabIndex        =   24
      Top             =   5160
      Width           =   3495
   End
   Begin VB.Label Label 
      Caption         =   "(multiselect)"
      ForeColor       =   &H00FF0000&
      Height          =   255
      Index           =   5
      Left            =   6240
      TabIndex        =   23
      Top             =   3000
      Width           =   855
   End
   Begin VB.Label Label8 
      Caption         =   "(multiselect)"
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   960
      TabIndex        =   22
      Top             =   3120
      Width           =   855
   End
   Begin VB.Label Label 
      Caption         =   "Sort Order"
      Height          =   255
      Index           =   9
      Left            =   240
      TabIndex        =   21
      Top             =   4440
      Width           =   1215
   End
   Begin VB.Label Label 
      Caption         =   "Thru"
      Height          =   255
      Index           =   3
      Left            =   6480
      TabIndex        =   19
      Top             =   1800
      Width           =   495
   End
   Begin VB.Label Label 
      Caption         =   "Thru"
      Height          =   255
      Index           =   7
      Left            =   6480
      TabIndex        =   17
      Top             =   3840
      Width           =   495
   End
   Begin VB.Label Label 
      Caption         =   "Tran Date"
      Height          =   255
      Index           =   8
      Left            =   240
      TabIndex        =   5
      Top             =   3840
      Width           =   1455
   End
   Begin VB.Label Label 
      Caption         =   "Location"
      Height          =   255
      Index           =   6
      Left            =   6240
      TabIndex        =   4
      Top             =   2760
      Width           =   855
   End
   Begin VB.Label Label 
      Caption         =   "S&&B Part Number"
      Height          =   255
      Index           =   0
      Left            =   240
      TabIndex        =   3
      Top             =   1800
      Width           =   1455
   End
   Begin VB.Label Label 
      Caption         =   "Employee"
      Height          =   255
      Index           =   4
      Left            =   6240
      TabIndex        =   2
      Top             =   2280
      Width           =   855
   End
   Begin VB.Label Label 
      Caption         =   "Serial Number"
      Height          =   255
      Index           =   1
      Left            =   240
      TabIndex        =   1
      Top             =   2280
      Width           =   1455
   End
   Begin VB.Label Label 
      Caption         =   "Transaction type"
      Height          =   255
      Index           =   2
      Left            =   240
      TabIndex        =   0
      Top             =   2760
      Width           =   1455
   End
End
Attribute VB_Name = "Frm_Trans_History"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim sdesc As String
Dim spart As Long
Dim part_desc As String
Dim Vdate As Date
Dim Location_String As String
Dim ent_part As String
Dim ent_part2 As String

Dim stcriteria(6) As String
Dim sort(3) As Long
Dim idx As Long

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


Private Sub Cmd_Process_report_Click()

    Rpt_sPartno = 0
    Rpt_ePartno = 0
    Rpt_Serial = ""
    Rpt_Employee = 0
    Rpt_TranType = 0
    Rpt_Text1 = "Item Range = ALL"
    If Cbo_StPartno.ListIndex <> -1 Then
        Rpt_sPartno = Cbo_StPartno.ItemData(Cbo_StPartno.ListIndex)
        Rpt_ePartno = Cbo_EndPartno.ItemData(Cbo_EndPartno.ListIndex)
        Rpt_Text1 = "Item Range = " & Cbo_StPartno.ItemData(Cbo_StPartno.ListIndex) & " thru " & Trim(Cbo_EndPartno.ItemData(Cbo_EndPartno.ListIndex))
    End If
    Rpt_Text2 = "Serial # = ALL"
    
    If Txt_Serialno.Text <> "" Then
        Rpt_Serial = "'" & Txt_Serialno.Text & "'" & " "
        If Txt_Serialno.Text <> "" Then Rpt_Text2 = Trim(Txt_Serialno.Text)
    End If
    
    Rpt_Text3 = "Employee = All"
    If Cbo_Employee.ListIndex <> -1 Then
        Rpt_Employee = Cbo_Employee.ItemData(Cbo_Employee.ListIndex)
        Rpt_Text3 = "Employee = " & Cbo_Employee.List(Cbo_Employee.ListIndex)
    End If
    
    Rpt_Text4 = "Transaction Types = All"
    Type_String = "("
    If Lst_Tran_Type.ListCount <> -1 Then
        Rpt_Text4 = "Transaction Types = "
        For idx = 0 To Lst_Tran_Type.ListCount - 1
            If Lst_Tran_Type.Selected(idx) = True Then
                If Trim(Type_String) > "(" Then Type_String = Type_String & ", "
                Type_String = Type_String & Lst_Tran_Type.ItemData(idx)
                Rpt_Text4 = Trim(Rpt_Text4) & Trim(Mid(Lst_Tran_Type.List(idx), 1, 7)) & ", "
            End If
        Next
    End If
    Type_String = Type_String & ")"
    If Type_String = "()" Then Type_String = ""
        
    Loc_String = "("
    Rpt_Text5 = "Locatons = All"
    If Lst_Location.ListIndex <> -1 Then
        Rpt_Text5 = "Locations = "
        For idx = 0 To Lst_Location.ListCount - 1
            If Lst_Location.Selected(idx) = True Then
                If Trim(Loc_String) > "(" Then Loc_String = Loc_String & ", "
                Loc_String = Loc_String & Lst_Location.ItemData(idx)
                Rpt_Text5 = Rpt_Text5 + Trim(Mid(Lst_Location.List(idx), 1, 5)) & ", "
            End If
        Next
    End If
    Loc_String = Loc_String & ")"
    If Loc_String = "()" Then Loc_String = ""
    
    Date_String = ""
    If Txt_StTranDate.Text = "" Then
    Rpt_Text6 = "Date Range = ALL"
    Else
        If Txt_StTranDate.Text = Txt_EndTranDate.Text Then
            Date_String = "ath.ath_tran_date = CONVERT(DATETIME,'" & Txt_StTranDate.Text & "')"
            Rpt_Text6 = " Date Range = " & Txt_StTranDate.Text
        Else
            Date_String = "ath.ath_tran_date between CONVERT(DATETIME,'" & Txt_StTranDate.Text & "') and CONVERT(DATETIME,'" & Txt_EndTranDate.Text & "')"
            Rpt_Text6 = "Date Range = " & Txt_StTranDate.Text & " thru " & Txt_EndTranDate.Text
        End If
    End If
        
    Frm_RptViewer.Show vbModal
    
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

Private Sub Cmd_Cal1_Click()
    
    Txt_StTranDate.Text = Calendar_date(Txt_StTranDate.Text)

End Sub

Private Sub Command1_Click()
    
    Txt_EndTranDate.Text = Calendar_date(Txt_StTranDate.Text)
          If Txt_StTranDate.Text > Txt_EndTranDate Then
            MsgBox ("The ending date has to be greater than the starting date")
            Exit Sub
        End If

End Sub

Private Sub Form_Load()
'the nasty call to the Trans_History stroed procedure
'Tran_history (@STPartno Bigint,@EndPartno Bigint,@Serialno char(18),@Employee integer,@TranType varchar(2000),@Location Bigint,@datestring varchar(500))
'exec Tran_history 0,0,'',0,'(1,2,3,4)',0,'ath.ath_tran_date between CONVERT(DATETIME,''11/02/2006'') and CONVERT(DATETIME,''11/09/2006'')'

    Txt_Header.Text = "Enter information in the fields you would like the report to be filtered on.  If you dont want the filter to apply, don't entery anything in the field.  Date Ranges will include the entered dates."
    Call Cbo_Partno_Load
    Call Lst_TranType_Load
    Call Cbo_Employee_Load
    Call Lst_Location_Load
    Rpt_Text7 = "Sort Options = Part Number/Location/Date time"

End Sub


Public Sub Cbo_Partno_Load()

    sSql = "select ai_index,ai_partno,AI_Description,AI_Parttype from AFC_Inventory"
    Call Get_Inventory("Read")
    Cbo_StPartno.Clear
    Cbo_EndPartno.Clear

    Do While RS_Inventory.EOF = False
    
        spart = RS_Inventory("ai_partno")            'part number
        sdesc = Mid(Trim(RS_Inventory("ai_description")), 1, 20)            'description
        part_desc = spart & " -  " & sdesc
        If Trim(RS_Inventory("AI_PartType")) = Trim("UNIT") Then
        Else
            Cbo_StPartno.AddItem (part_desc)
            Cbo_StPartno.ItemData(Cbo_StPartno.NewIndex) = RS_Inventory("ai_partno")

            Cbo_EndPartno.AddItem (part_desc)
            Cbo_EndPartno.ItemData(Cbo_EndPartno.NewIndex) = RS_Inventory("ai_partno")
        End If
themove:
        RS_Inventory.MoveNext
        DoEvents
    Loop
    Call Get_Inventory("Close")
End Sub

Public Sub Lst_TranType_Load()
    sSql = "select * from afc_transtype"
    Call Get_Inventory("Read")
    Lst_Tran_Type.Clear

    Do While RS_Inventory.EOF = False

        part_desc = RS_Inventory("att_code") & "- " & Trim(RS_Inventory("att_description"))
        
        Lst_Tran_Type.AddItem (part_desc)
        Lst_Tran_Type.ItemData(Lst_Tran_Type.NewIndex) = RS_Inventory("att_index")
        
        RS_Inventory.MoveNext
    Loop
    Call Get_Inventory("Close")

End Sub

Public Sub Cbo_Employee_Load()
    sSql = "select * from afc_technicians"
    Call Get_Inventory("Read")
    Cbo_Employee.Clear

    Do While RS_Inventory.EOF = False
    
        spart = RS_Inventory("at_empno")            'part number
        sdesc = Trim(RS_Inventory("at_empfname")) & " " & Trim(RS_Inventory("at_empLname"))        'description
        part_desc = spart & " -  " & sdesc
        
        Cbo_Employee.AddItem (part_desc)
        Cbo_Employee.ItemData(Cbo_Employee.NewIndex) = RS_Inventory("at_id")
        
        RS_Inventory.MoveNext
    Loop
    Call Get_Inventory("Close")

End Sub
    
Public Sub Lst_Location_Load()
    sSql = "select * from afc_location where al_location_Type in(1,2,13)"
    Call Get_Inventory("Read")
    Lst_Location.Clear

    Do While RS_Inventory.EOF = False
        'spart = RS_Inventory("al_abrv")            'part number
        sdesc = Trim(RS_Inventory("al_location_Name"))            'description
        part_desc = Mid(RS_Inventory("al_abrv"), 1, 5) & " -  " & sdesc
        
        Lst_Location.AddItem (part_desc)
        Lst_Location.ItemData(Lst_Location.NewIndex) = RS_Inventory("al_id")
        
        RS_Inventory.MoveNext
    Loop
    Call Get_Inventory("Close")

End Sub

Private Sub Lst_Sort_Click()
    For idx = 0 To Lst_Sort.ListCount - 1
        If Lst_Sort.Selected(idx) = True And Lst_Sort.ItemData(Lst_Sort.ListIndex) <> Rpt_Sort1 And Lst_Sort.ItemData(Lst_Sort.ListIndex) <> Rpt_Sort2 Then 'And Lst_Sort.ItemData(Lst_Sort.ListIndex) <> Rpt_Sort3 Then
        If Rpt_Sort1 = 0 Then
            Rpt_Sort1 = Lst_Sort.ItemData(Lst_Sort.ListIndex)
            Rpt_Text7 = "Sort Options = " & Trim(Lst_Sort.List(Lst_Sort.ListIndex))
            Txt_Sort.Text = Trim(Lst_Sort.List(Lst_Sort.ListIndex))
        ElseIf Rpt_Sort2 = 0 Then
            Rpt_Sort2 = Lst_Sort.ItemData(Lst_Sort.ListIndex)
            Rpt_Text7 = Rpt_Text7 & "/" & Trim(Lst_Sort.List(Lst_Sort.ListIndex))
            Txt_Sort.Text = Txt_Sort.Text & "/" & Trim(Lst_Sort.List(Lst_Sort.ListIndex))
        'ElseIf Rpt_Sort3 = 0 Then
        '    Rpt_Sort3 = Lst_Sort.ItemData(Lst_Sort.ListIndex)
        '    Rpt_Text7 = Rpt_Text7 & "/" & Trim(Lst_Sort.List(Lst_Sort.ListIndex))
        '    Txt_Sort.Text = Txt_Sort.Text & "/" & Trim(Lst_Sort.List(Lst_Sort.ListIndex))
        Else
            MsgBox ("You have picked too many Sort Parameters.  Reset and start over")
            Exit Sub
        End If
        End If
    Next
End Sub

