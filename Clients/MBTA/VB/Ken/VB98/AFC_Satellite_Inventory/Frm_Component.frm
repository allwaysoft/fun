VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "Msflxgrd.ocx"
Begin VB.Form Frm_Component 
   Caption         =   "Component Usage "
   ClientHeight    =   8340
   ClientLeft      =   1965
   ClientTop       =   2115
   ClientWidth     =   11565
   LinkTopic       =   "Form2"
   ScaleHeight     =   8340
   ScaleWidth      =   11565
   Begin VB.CommandButton Cmd_Exit 
      BackColor       =   &H000000FF&
      Caption         =   "Exit"
      Height          =   375
      Left            =   8640
      Style           =   1  'Graphical
      TabIndex        =   26
      Top             =   7800
      Width           =   2535
   End
   Begin VB.Frame Fra_Usage 
      Caption         =   "Used Components"
      Height          =   7215
      Left            =   11040
      TabIndex        =   21
      Top             =   480
      Width           =   10695
      Begin VB.CommandButton Cmd_Save_Comp 
         Caption         =   "Add Component"
         Height          =   495
         Left            =   8520
         TabIndex        =   42
         Top             =   2760
         Width           =   1335
      End
      Begin MSFlexGridLib.MSFlexGrid Grd_Items 
         Height          =   2655
         Left            =   840
         TabIndex        =   41
         Top             =   3480
         Width           =   9015
         _ExtentX        =   15901
         _ExtentY        =   4683
         _Version        =   393216
      End
      Begin VB.TextBox txt_Narr 
         Height          =   975
         Left            =   2160
         TabIndex        =   40
         Top             =   2160
         Width           =   5895
      End
      Begin VB.CheckBox Chk_Trash 
         Caption         =   "Item thrown away"
         Height          =   255
         Left            =   4560
         TabIndex        =   38
         Top             =   1320
         Width           =   2055
      End
      Begin VB.TextBox Txt_New_Serial 
         Height          =   285
         Left            =   2160
         TabIndex        =   37
         Top             =   1560
         Width           =   1815
      End
      Begin VB.TextBox Txt_Old_serial 
         Height          =   285
         Left            =   2160
         TabIndex        =   36
         Top             =   1080
         Width           =   1815
      End
      Begin VB.CommandButton Cmd_Exitframe 
         BackColor       =   &H000000FF&
         Caption         =   "Exit Component Entry"
         Height          =   615
         Left            =   9000
         Style           =   1  'Graphical
         TabIndex        =   31
         Top             =   6480
         Width           =   1575
      End
      Begin VB.ComboBox Cbo_Partno2 
         Height          =   315
         Left            =   2160
         TabIndex        =   22
         Top             =   480
         Width           =   5775
      End
      Begin VB.Label Label13 
         Caption         =   "Component Narrative"
         Height          =   255
         Left            =   120
         TabIndex        =   39
         Top             =   2160
         Width           =   1815
      End
      Begin VB.Label Label12 
         Caption         =   "New Serial #"
         Height          =   255
         Left            =   240
         TabIndex        =   35
         Top             =   1560
         Width           =   1215
      End
      Begin VB.Label Label11 
         Caption         =   "Old Serial #"
         Height          =   255
         Left            =   240
         TabIndex        =   34
         Top             =   1080
         Width           =   1215
      End
      Begin VB.Label Label10 
         Caption         =   "Replaced Component"
         Height          =   255
         Left            =   240
         TabIndex        =   33
         Top             =   480
         Width           =   1815
      End
   End
   Begin MSFlexGridLib.MSFlexGrid Grd_OpenWO 
      Height          =   3015
      Left            =   360
      TabIndex        =   20
      Top             =   4680
      Width           =   10575
      _ExtentX        =   18653
      _ExtentY        =   5318
      _Version        =   393216
   End
   Begin VB.Frame Fra_Workorder 
      Height          =   3855
      Left            =   360
      TabIndex        =   0
      Top             =   480
      Width           =   10575
      Begin VB.CommandButton Cmd_Close 
         Caption         =   "Close Work Order"
         Height          =   615
         Left            =   8880
         TabIndex        =   43
         Top             =   2400
         Width           =   1575
      End
      Begin VB.CommandButton Cmd_Add_Components 
         Caption         =   "Enter Used Components"
         Height          =   615
         Left            =   7200
         TabIndex        =   32
         Top             =   3120
         Width           =   1455
      End
      Begin VB.CommandButton Cmd_Cal2 
         Caption         =   "Calendar"
         Height          =   255
         Left            =   7320
         TabIndex        =   6
         Top             =   1920
         Width           =   1095
      End
      Begin VB.CommandButton Cmd_Cal1 
         Caption         =   "Calendar"
         Height          =   255
         Left            =   7320
         TabIndex        =   5
         Top             =   1440
         Width           =   1095
      End
      Begin VB.TextBox Txt_End_Date 
         BackColor       =   &H00C0FFFF&
         Height          =   285
         Left            =   5280
         Locked          =   -1  'True
         TabIndex        =   29
         Top             =   1920
         Width           =   1935
      End
      Begin VB.TextBox Txt_St_Date 
         BackColor       =   &H00C0FFFF&
         Height          =   285
         Left            =   5280
         Locked          =   -1  'True
         TabIndex        =   28
         Top             =   1440
         Width           =   1935
      End
      Begin VB.TextBox Txt_Notes 
         Height          =   735
         Left            =   1800
         ScrollBars      =   2  'Vertical
         TabIndex        =   11
         Top             =   2400
         Width           =   4935
      End
      Begin VB.ComboBox Cbo_End_Min 
         Height          =   315
         ItemData        =   "Frm_Component.frx":0000
         Left            =   9480
         List            =   "Frm_Component.frx":0032
         TabIndex        =   10
         Top             =   1920
         Width           =   735
      End
      Begin VB.ComboBox Cbo_St_Min 
         Height          =   315
         ItemData        =   "Frm_Component.frx":0064
         Left            =   9480
         List            =   "Frm_Component.frx":0096
         TabIndex        =   8
         Top             =   1440
         Width           =   735
      End
      Begin VB.ComboBox Cbo_End_Hour 
         Height          =   315
         ItemData        =   "Frm_Component.frx":00C8
         Left            =   8520
         List            =   "Frm_Component.frx":0107
         TabIndex        =   9
         Top             =   1920
         Width           =   855
      End
      Begin VB.ComboBox Cbo_St_Hour 
         Height          =   315
         ItemData        =   "Frm_Component.frx":0146
         Left            =   8520
         List            =   "Frm_Component.frx":0185
         TabIndex        =   7
         Top             =   1440
         Width           =   855
      End
      Begin VB.TextBox Txt_Incident 
         Height          =   285
         Left            =   1800
         TabIndex        =   4
         Top             =   1920
         Width           =   2295
      End
      Begin VB.CommandButton Cmd_SaveWorkorder 
         Caption         =   "Save Workorder"
         Height          =   615
         Left            =   8880
         TabIndex        =   12
         Top             =   3120
         Width           =   1575
      End
      Begin VB.TextBox Txt_RecSerial 
         Height          =   285
         Left            =   1800
         TabIndex        =   3
         Top             =   1440
         Width           =   2295
      End
      Begin VB.TextBox Txt_Label 
         Height          =   285
         Left            =   1800
         TabIndex        =   1
         Top             =   240
         Width           =   3975
      End
      Begin VB.ComboBox Cbo_Partno 
         Height          =   315
         Left            =   1800
         TabIndex        =   2
         Top             =   960
         Width           =   5775
      End
      Begin VB.Label Label9 
         Caption         =   "  Hours           Minutes"
         Height          =   255
         Left            =   8520
         TabIndex        =   30
         Top             =   1080
         Width           =   1695
      End
      Begin VB.Label Label8 
         Alignment       =   1  'Right Justify
         Caption         =   "Repair Notes"
         Height          =   255
         Left            =   360
         TabIndex        =   27
         Top             =   2400
         Width           =   1215
      End
      Begin VB.Label Label7 
         Caption         =   "Time Ended"
         Height          =   255
         Left            =   4320
         TabIndex        =   25
         Top             =   1920
         Width           =   975
      End
      Begin VB.Label Label6 
         Caption         =   "Time Started"
         Height          =   255
         Left            =   4320
         TabIndex        =   24
         Top             =   1440
         Width           =   1095
      End
      Begin VB.Label Label4 
         Alignment       =   1  'Right Justify
         Caption         =   "Incident Number"
         Height          =   255
         Left            =   120
         TabIndex        =   23
         Top             =   1920
         Width           =   1455
      End
      Begin VB.Label Label3 
         Caption         =   "Or"
         Height          =   255
         Left            =   960
         TabIndex        =   16
         Top             =   600
         Width           =   375
      End
      Begin VB.Label Label 
         Alignment       =   1  'Right Justify
         Caption         =   "Scan Label "
         Height          =   255
         Index           =   33
         Left            =   120
         TabIndex        =   15
         Top             =   240
         Width           =   1455
      End
      Begin VB.Label Label2 
         Alignment       =   1  'Right Justify
         Caption         =   "Serial Number"
         Height          =   255
         Left            =   120
         TabIndex        =   14
         Top             =   1440
         Width           =   1455
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Unit Being Repaird"
         Height          =   255
         Left            =   120
         TabIndex        =   13
         Top             =   960
         Width           =   1455
      End
   End
   Begin VB.Label LBL_ID 
      Caption         =   "User"
      Height          =   255
      Left            =   4440
      TabIndex        =   19
      Top             =   120
      Width           =   3135
   End
   Begin VB.Label LBL_Station 
      Caption         =   "Station"
      Height          =   255
      Left            =   7920
      TabIndex        =   18
      Top             =   120
      Width           =   3135
   End
   Begin VB.Label Label5 
      Caption         =   "Label5"
      Height          =   15
      Left            =   3840
      TabIndex        =   17
      Top             =   5880
      Width           =   135
   End
   Begin VB.Menu Workorders 
      Caption         =   "Workorders"
      Begin VB.Menu NewWorkorder 
         Caption         =   "Create New Workorder"
      End
      Begin VB.Menu ExistingWorkorder 
         Caption         =   "Modify Existing Workorder"
      End
   End
End
Attribute VB_Name = "Frm_Component"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim icol As Long
Dim splitter As String
Dim Pos As Integer
Dim label_part As String
Dim Label_serial As String
Dim KeyAscii As Integer
Dim step As Long
Dim period As String
Dim WorkOrder As String
Dim is_next As Long
Dim LG_GridIdx As Long
Dim WO_Index As Long
Dim sline As String
Dim ent_part As String



Private Sub Cbo_Partno_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        If Len(ent_part) <= 1 Then
            ent_part = ""
            Cbo_Partno.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    ent_part = ent_part & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_Partno, KeyAscii, True)

End Sub

Private Sub Cbo_Partno2_KeyPress(KeyAscii As Integer)
    If KeyAscii = 8 Then
        If Len(ent_part) <= 1 Then
            ent_part = ""
            Cbo_Partno2.Text = ""
            Exit Sub
        End If
    ElseIf KeyAscii = 13 Then
        KeyAscii = 0
        SendKeys "{TAB}"
    End If
    ent_part = ent_part & Chr(KeyAscii)
    hold_keyascii = KeyAscii
    KeyAscii = AutoFind(Cbo_Partno2, KeyAscii, True)

End Sub

Private Sub Cmd_Add_Components_Click()
    Fra_Usage.Visible = True
    Fra_Usage.Left = 240
    Cmd_Exit.Visible = False
    Call Load_GridItems
End Sub

Private Sub Cmd_Cal1_Click()
    If Not IsDate(Txt_St_Date.Text) Then
        Vdate = Date - 1
    Else
        Vdate = Txt_St_Date.Text
    End If
    Call Frm_Calendar.SetStartDate(Vdate)
startit:
    Frm_Calendar.Show vbModal
    Vdate = Frm_Calendar.GetDate
    If IsDate(Vdate) = True Then
        If Vdate > Date Then
            If (MsgBox("Date Cannot be greater than Todays date", vbRetryCancel) = vbRetry) Then
                GoTo startit
            Else
                Exit Sub
            End If
        End If
        Txt_St_Date.Text = Format(Vdate, "MM/DD/YYYY")
    End If
End Sub


Private Sub Cmd_Cal2_Click()
    If Not IsDate(Txt_End_Date.Text) Then
        Vdate = Txt_St_Date.Text
    Else
        Vdate = Txt_End_Date.Text
    End If
    Call Frm_Calendar.SetStartDate(Vdate)
startit:
    Frm_Calendar.Show vbModal
    Vdate = Frm_Calendar.GetDate
    If IsDate(Vdate) = True Then
        If Vdate > Date Then
            If (MsgBox("Date Cannot be greater than Todays date", vbRetryCancel) = vbRetry) Then
                GoTo startit
            Else
                Exit Sub
            End If
        End If
        Txt_End_Date.Text = Format(Vdate, "MM/DD/YYYY")
    End If
End Sub

Private Sub Cmd_Close_Click()
    sSql = "update component_repair set rincident = '" & Trim(Txt_Incident.Text) & "', rtimein = '" & _
    Trim(Txt_St_Date.Text) & " " & Trim(Cbo_St_Hour.Text) & ":" & Trim(Cbo_St_Min.Text) & ":00" & "', rtimeout = '" & _
    Trim(Txt_End_Date.Text) & " " & Trim(Cbo_End_Hour.Text) & ":" & Trim(Cbo_End_Min.Text) & ":00'" & _
    ", rclosed = 'Y', rclosed_date = '" & Format(Now, "mm/dd/yyyy") & "' Where rindex = " & WO_Index
    
    SQLData.Execute (sSql)
    
    Cbo_Partno.ListIndex = -1
    Txt_RecSerial.Text = ""
    Txt_Incident.Text = ""
    Txt_St_Date.Text = ""
    Txt_End_Date.Text = ""
    Cbo_St_Hour.ListIndex = -1
    Cbo_St_Min.ListIndex = -1
    Cbo_End_Hour.ListIndex = -1
    Cbo_End_Min.ListIndex = -1
    Txt_Notes.Text = ""
    Cmd_Close.Visible = False
    Load_GridWO
    WO_Index = 0
    
End Sub

Private Sub Cmd_Exit_Click()
    Unload Me
End Sub

Private Sub Cmd_Exitframe_Click()
    Cmd_Exit.Visible = True
    Fra_Usage.Visible = False
End Sub

Private Sub Cmd_Save_Comp_Click()
    If Cbo_Partno2.ListIndex = -1 Then
        MsgBox ("A part must be selected"), vbOKOnly
        Exit Sub
    End If
    
    sSql = "Insert into Component_detail(rindex, crcomponent, crserialold, crserialnew, " & _
    " crtrash, crdateadded, crnarrative) values(" & WO_Index & ", " & Cbo_Partno2.ItemData(Cbo_Partno2.ListIndex) & _
    ",'" & Txt_Old_serial.Text & "','" & Txt_New_Serial.Text & "', " & Chk_Trash.Value & ",'" & _
    Format(Now, "mm/dd/yyyy") & "','" & Trim(txt_Narr) & "')"
    
    SQLData.Execute (sSql)
    
End Sub

Private Sub Cmd_SaveWorkorder_Click()
    sSql = "update component_repair set rincident = '" & Trim(Txt_Incident.Text) & "', rtimein = '" & _
    Trim(Txt_St_Date.Text) & " " & Trim(Cbo_St_Hour.Text) & ":" & Trim(Cbo_St_Min.Text) & ":00" & "', rtimeout = '" & _
    Trim(Txt_End_Date.Text) & " " & Trim(Cbo_End_Hour.Text) & ":" & Trim(Cbo_End_Min.Text) & ":00'" & _
    " Where rindex = " & WO_Index
    Debug.Print sSql
    SQLData.Execute (sSql)
    If Cbo_St_Hour.ListIndex <> -1 And Cbo_St_Min.ListIndex <> -1 And Cbo_End_Hour.ListIndex <> -1 And Cbo_End_Min.ListIndex <> -1 And Txt_St_Date.Text <> "" And Txt_End_Date.Text <> "" Then
        Cmd_Close.Visible = True
    Else
        Cmd_Close.Visible = False
    End If
End Sub

Private Sub Form_Load()
    LBL_ID = "User: " & Current_User_Id & " " & Current_User_Name
    LBL_Station = "Station id: " & m_ComputerName
    Call LoadPart_Arrays
    Fra_Workorder.Visible = False
    Fra_Usage.Visible = False
    Call Load_GridWO
    Cmd_Close.Visible = False

End Sub


Private Sub Grd_OpenWO_Click()

    LG_GridIdx = Grd_OpenWO.row
    If LG_GridIdx = 0 Then
        Grd_OpenWO.FixedRows = 1
        Grd_OpenWO.sort = 1
        Grd_OpenWO.Refresh
        Grd_OpenWO.FixedRows = 0
        Txt_Label.Text = ""
        Txt_RecSerial.Text = ""
        Txt_Incident.Text = ""
        Cbo_Partno.ListIndex = -1
        Txt_St_Date.Text = ""
        Txt_End_Date.Text = ""
        Cbo_St_Hour.ListIndex = -1
        Cbo_End_Hour.ListIndex = -1
        Cbo_St_Min.ListIndex = -1
        Cbo_End_Min.ListIndex = -1

        Exit Sub
    End If
    If Current_User_Level < 5 Then Exit Sub
    
    For step = 0 To Cbo_Partno.ListCount
        If Cbo_Partno.ItemData(step) = CInt(Trim(Grd_OpenWO.TextMatrix(LG_GridIdx, 8))) Then
            Cbo_Partno.ListIndex = step
            step = Cbo_Partno.ListCount
        End If
    Next
    Txt_RecSerial.Text = Trim(Grd_OpenWO.TextMatrix(LG_GridIdx, 4))
    Txt_Incident.Text = ""
    Fra_Workorder.Visible = True
    WO_Index = Grd_OpenWO.TextMatrix(LG_GridIdx, 0)
    sSql = "select * from  component_repair where rindex = " & Grd_OpenWO.TextMatrix(LG_GridIdx, 0)
    
    Call Get_Work("Read")
    
    Txt_St_Date.Text = Format(RS_Work("rtimein"), "mm/dd/yyyy")
    Txt_End_Date.Text = Format(RS_Work("rtimeout"), "mm/dd/yyyy")
    Txt_Incident.Text = RS_Work("rincident")
    
    If RS_Work("rtimein") <> vbNullString Then
    For step = 0 To Cbo_St_Hour.ListCount
        If Cbo_St_Hour.ItemData(step) = Hour(RS_Work("rtimein")) Then
            Cbo_St_Hour.ListIndex = step
            step = Cbo_St_Hour.ListCount
        End If
    Next
    For step = 0 To Cbo_St_Min.ListCount
        If Cbo_St_Min.ItemData(step) = Minute(RS_Work("rtimein")) Then
            Cbo_St_Min.ListIndex = step
            step = Cbo_St_Min.ListCount
        End If
    Next
    Else
        Cbo_St_Hour.ListIndex = -1
        Cbo_St_Min.ListIndex = -1
    End If
    
    If RS_Work("rtimeout") <> vbNullString Then
    For step = 0 To Cbo_End_Hour.ListCount
        If Cbo_End_Hour.ItemData(step) = Hour(RS_Work("rtimeout")) Then
            Cbo_End_Hour.ListIndex = step
            step = Cbo_End_Hour.ListCount
        End If
    Next
    For step = 0 To Cbo_End_Min.ListCount
        If Cbo_End_Min.ItemData(step) = Minute(RS_Work("rtimeout")) Then
            Cbo_End_Min.ListIndex = step
            step = Cbo_End_Min.ListCount
        End If
    Next
    Else
        Cbo_End_Hour.ListIndex = -1
        Cbo_End_Min.ListIndex = -1
    End If
    If Cbo_St_Hour.ListIndex <> -1 And Cbo_St_Min.ListIndex <> -1 And Cbo_End_Hour.ListIndex <> -1 And Cbo_End_Min.ListIndex <> -1 And Txt_St_Date.Text <> "" And Txt_End_Date.Text <> "" Then
        Cmd_Close.Visible = True
    Else
        Cmd_Close.Visible = False
    End If

End Sub

Private Sub NewWorkorder_Click()
    Fra_Workorder.Visible = True
End Sub

Public Sub Cmd_LookupWorkorder()

    period = Format(Date, "mmddyy")

    If Txt_Label.Text <> "" Then
        sSql = "select ai_index from afc_inventory where ai_partno = '" & Trim(label_part) & "'"
        Call Get_Trans("Read")
        tATH_Partno = RS_Trans("AI_Index")
        Call Get_Trans("Close")
    Else
        tATH_Partno = Cbo_Partno.ItemData(Cbo_Partno.ListIndex)
    End If

    If IsNumeric(Txt_RecSerial.Text) Then
        Txt_RecSerial.Text = CLng(Txt_RecSerial.Text)
    End If
    

'**********************************************************************
' Check for open workbench items by partno only for receiving back from Work Bench


    If Trim(Txt_RecSerial.Text) = "" Then
        sSql = "select * from component_repair where runit = " & tATH_Partno & _
        " and isnull(rclosed,'')='' and Rworkbranch = " & Current_User_Branch
        Call Get_Trans("Read")
        If RS_Trans.EOF = True Then
            Call Create_Workorder
        Else
            If MsgBox("This Unit has been found Do you still want to add it?", vbYesNo) = vbYes Then
                Call Create_Workorder
            Else
                Call Display_Workorder
            End If
        End If

    Else
        sSql = "select * from component_repair where runit = " & tATH_Partno & _
        " and rserial = " & Trim(Txt_RecSerial.Text) & " and isnull(rclosed,'')='' " & _
        " and Rworkbranch = " & Current_User_Branch
        Call Get_Trans("Read")
        If RS_Trans.EOF = True Then
            Call Create_Workorder
        Else
            If MsgBox("This Unit has been found Do you still want to add it?", vbYesNo) = vbYes Then
                Call Create_Workorder
            Else
                Call Display_Workorder
            End If
        End If

    End If

End Sub
    
Public Sub Display_Workorder()
    Txt_Incident.Text = RS_Trans("rincident")
    Txt_Incident.Text = RS_Trans("rincident")

End Sub
    
Public Sub Create_Workorder()

    sSql = "Select * from incident_seed where is_id=2"
    Call Get_Work("Read")
    If RS_Work.EOF <> True Then
        If RS_Work("is_mmddyy") <> period Then
            sSql = "update incident_seed set is_mmddyy='" & Trim(period) & "', is_next=2 where is_id=2"
            WorkOrder = period & "-0001"
            SQLData.Execute (sSql)
        Else
            sSql = "update incident_seed set is_next = (is_next +1) where is_id=2"
            SQLData.Execute (sSql)
            is_next = RS_Work("is_next")
            Select Case Len(is_next)
            Case 1
                WorkOrder = RS_Work("IS_mmddyy") & "-000" & CStr(is_next)
            Case 2
                WorkOrder = RS_Work("IS_mmddyy") & "-00" & CStr(is_next)
            Case 3
                WorkOrder = RS_Work("IS_mmddyy") & "-0" & CStr(is_next)
            Case 4
                WorkOrder = RS_Work("IS_mmddyy") & "-" & CStr(is_next)
            End Select
        End If
    End If
    
    sSql = "Insert into Component_Repair(rworkorder,runit,rIncident,rserial,rdate,rtechnician,rworkbranch) " & _
    "values('" & WorkOrder & "'," & tATH_Partno & ",'" & Trim(Txt_Incident.Text) & "','" & Trim(Txt_RecSerial.Text) & "','" & _
    Format(Date, "mm/dd/yyyy") & "'," & Current_User_Index & "," & Current_User_Branch & ")"
    SQLData.Execute (sSql)

End Sub
Public Sub LoadPart_Arrays()
Dim spart As Long
Dim sdesc As String
Dim part_desc As String

    sSql = "select ai_index,ai_partno,AI_Description,AI_Parttype, ai_rolledout from AFC_Inventory order by ai_partno"
    Call Get_Inventory("Read")
    Cbo_Partno.Clear
    Cbo_Partno2.Clear

    Do While RS_Inventory.EOF = False
    
        spart = RS_Inventory("ai_partno")            'part number
        sdesc = Trim(RS_Inventory("ai_description"))              'description
        part_desc = spart & " -  " & sdesc
        Cbo_Partno.AddItem (part_desc)
        Cbo_Partno.ItemData(Cbo_Partno.NewIndex) = RS_Inventory("ai_index")
        
        Select Case RS_Inventory("ai_Parttype")
        Case "FRA"
            Cbo_Partno.AddItem (part_desc)
            Cbo_Partno.ItemData(Cbo_Partno.NewIndex) = RS_Inventory("ai_index")
        Case "FRC", "WBC", "C"
            Cbo_Partno2.AddItem (part_desc)
            Cbo_Partno2.ItemData(Cbo_Partno2.NewIndex) = RS_Inventory("ai_index")
        End Select
SkipIT:
        
        RS_Inventory.MoveNext
    Loop
    Call Get_Inventory("Close")

End Sub
Public Sub Load_GridItems()
Dim trash As String

Call Grid_Items_Init

    sSql = "select crindex,crserialold,crserialnew,crtrash,crdateadded, ai_partno, ai_description " & _
    " From component_detail left outer join afc_inventory on ai_index = crcomponent where rindex = " & WO_Index
    
    Call Get_Work("Read")
    
    Do While RS_Work.EOF = False
    trash = "No"
    If RS_Work("crtrash") = True Then trash = "Yes"
    
        sline = RS_Work("crindex") & vbTab & _
            RS_Work("ai_partno") & vbTab & _
            RS_Work("ai_description") & vbTab & _
            RS_Work("crserialold") & vbTab & _
            RS_Work("crserialnew") & vbTab & _
            RS_Work("crdateadded") & vbTab & _
            trash
            Grd_Items.AddItem sline
        
        RS_Work.MoveNext
    Loop
    
End Sub

Public Sub Load_GridWO()

Call Grid_WO_Init
    sSql = "select CR.RINDEX,cr.RWorkorder, cr.Rserial, cr.rdate, cr.rincident, at_emplname, at_empfname, ai.ai_index, ai.ai_partno, ai.Ai_Description,ai.ai_parttype "
    sSql = sSql & " from Component_Repair cr left outer join afc_technicians t on cr.rtechnician = t.at_id "
    sSql = sSql & " left outer join afc_Inventory ai on cr.runit = ai.ai_index where rworkbranch = " & Current_User_Branch & "  and isnull(rclosed,'') <> 'Y'"
    
 
    Call Get_Work("Read")
    
    Do While RS_Work.EOF = False
        sline = RS_Work("RINDEX") & vbTab & _
                RS_Work("rworkorder") & vbTab & _
                RS_Work("ai_partno") & vbTab & _
                RS_Work("ai_description") & vbTab & _
                RS_Work("rserial") & vbTab & _
                RS_Work("ai_parttype") & vbTab & _
                RS_Work("rdate") & vbTab & _
                Trim(RS_Work("at_emplname")) & ", " & Trim(RS_Work("at_empfname")) & vbTab & _
                RS_Work("ai_index")
                
        Grd_OpenWO.AddItem sline
        
        RS_Work.MoveNext
    Loop
End Sub

Public Sub Grid_WO_Init()
With Grd_OpenWO
    .Clear
    .AllowUserResizing = flexResizeColumns
    
    .Rows = 1
    .Cols = 9
    .FixedCols = 0
    
    .TextMatrix(0, 0) = "Index"
    .TextMatrix(0, 1) = "Workorder"
    .TextMatrix(0, 2) = "S&B Part"
    .TextMatrix(0, 3) = "Description"
    .TextMatrix(0, 4) = "Serial#"
    .TextMatrix(0, 5) = "Part Typ"
    .TextMatrix(0, 6) = "Date"
    .TextMatrix(0, 7) = "Repair Tech"
    .TextMatrix(0, 8) = "AI_Index"
    
    .ColWidth(0) = 0
    .ColWidth(1) = 1400
    .ColWidth(2) = 800
    .ColWidth(3) = 2000
    .ColWidth(4) = 1000
    .ColWidth(5) = 800
    .ColWidth(6) = 1800
    .ColWidth(7) = 1400
    .ColWidth(8) = 0


    .ColAlignment(0) = flexAlignLeftCenter
    .ColAlignment(1) = flexAlignLeftCenter
    .ColAlignment(2) = flexAlignLeftCenter
    .ColAlignment(3) = flexAlignLeftCenter
    .ColAlignment(4) = flexAlignLeftCenter
    .ColAlignment(5) = flexAlignLeftCenter
    .ColAlignment(6) = flexAlignLeftCenter


    For icol = 0 To 7
        .col = icol
        .row = 0
        .CellBackColor = &HC0C0C0
    Next
End With
End Sub

Public Sub Grid_Items_Init()
With Grd_Items
    .Clear
    .AllowUserResizing = flexResizeColumns
    
    .Rows = 1
    .Cols = 7
    .FixedCols = 0
    
    .TextMatrix(0, 0) = "Index"
    .TextMatrix(0, 1) = "Component"
    .TextMatrix(0, 2) = "Description"
    .TextMatrix(0, 3) = "Old Serial"
    .TextMatrix(0, 4) = "New Serial"
    .TextMatrix(0, 5) = "DFate Entered"
    .TextMatrix(0, 6) = "Trash"
    
    .ColWidth(0) = 0
    .ColWidth(1) = 1200
    .ColWidth(2) = 2000
    .ColWidth(3) = 1200
    .ColWidth(4) = 1200
    .ColWidth(5) = 1200
    .ColWidth(6) = 1000

    .ColAlignment(0) = flexAlignLeftCenter
    .ColAlignment(1) = flexAlignLeftCenter
    .ColAlignment(2) = flexAlignLeftCenter
    .ColAlignment(3) = flexAlignLeftCenter
    .ColAlignment(4) = flexAlignLeftCenter
    .ColAlignment(5) = flexAlignLeftCenter
    .ColAlignment(6) = flexAlignLeftCenter


    For icol = 0 To 6
        .col = icol
        .row = 0
        .CellBackColor = &HC0C0C0
    Next
End With
End Sub

Private Sub Txt_Label_KeyPress(KeyAscii As Integer)
    Select Case KeyAscii
        Case 8
            Exit Sub
        Case 13
                KeyAscii = 0
                SendKeys "{TAB}"
    End Select
End Sub

Private Sub Txt_Label_Validate(Cancel As Boolean)

    If Txt_Label.Text = "" Then Exit Sub
    Pos = InStr(1, Txt_Label, " ")
    If Pos = 0 Then
        Txt_Label.Text = Replace(Txt_Label.Text, "(A)", " A")
        Txt_Label.Text = Replace(Txt_Label.Text, "D", " D")
        Pos = InStr(1, Txt_Label, " ")
    End If

label_part = CLng(Trim(Mid(Txt_Label.Text, 1, Pos)))
    sSql = "select ai_index from afc_inventory where ai_partno='" & label_part & "'"
    Call Get_Trans("Read")
        If RS_Trans.EOF = True Then
            label_part = CLng(Trim(Mid(Txt_Label.Text, 1, Pos - 2)))
            sSql = "select ai_index from afc_inventory where ai_partno='" & label_part & "'"
            Call Get_Trans("Read")
        End If
    splitter = Trim(Mid(Txt_Label.Text, Pos, Len(Txt_Label.Text)))
    If Mid(splitter, 1, 1) > 9 Then
        splitter = Mid(splitter, 2, Len(splitter))
    End If
    
    If Mid(splitter, 2, 1) > 9 Then
        splitter = Mid(splitter, 3, Len(splitter))
    End If
    Label_serial = CLng(splitter)
    Txt_RecSerial.Text = CLng(splitter)
    
    For step = 0 To Cbo_Partno.ListCount - 1
    If Cbo_Partno.ItemData(step) = RS_Trans("ai_index") Then
        Cbo_Partno.ListIndex = step
        step = Cbo_Partno.ListCount
    End If
    Next
    RS_Trans.Close
    Set RS_Trans = Nothing
    
    Call Cmd_LookupWorkorder
    Txt_Label.SetFocus
End Sub
