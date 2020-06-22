VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Begin VB.Form Frm_ICodes 
   Caption         =   "Incident Code Maintenance"
   ClientHeight    =   8115
   ClientLeft      =   1635
   ClientTop       =   555
   ClientWidth     =   10725
   LinkTopic       =   "Form1"
   ScaleHeight     =   8115
   ScaleWidth      =   10725
   Begin VB.CommandButton Cmd_reset 
      Caption         =   "Reset"
      Height          =   615
      Left            =   7080
      TabIndex        =   10
      Top             =   2400
      Width           =   1335
   End
   Begin VB.CommandButton Cmd_AddSave 
      Caption         =   "Add/Save Entry"
      Height          =   615
      Left            =   8760
      TabIndex        =   9
      Top             =   2400
      Width           =   1335
   End
   Begin VB.ComboBox Cbo_IType 
      Height          =   315
      ItemData        =   "Frm_ICodes.frx":0000
      Left            =   7200
      List            =   "Frm_ICodes.frx":000A
      TabIndex        =   5
      Top             =   1680
      Width           =   2175
   End
   Begin VB.ComboBox Cbo_Branch 
      Height          =   315
      ItemData        =   "Frm_ICodes.frx":002D
      Left            =   4680
      List            =   "Frm_ICodes.frx":003A
      TabIndex        =   4
      Top             =   1680
      Width           =   2295
   End
   Begin VB.TextBox Txt_IDesc 
      Height          =   285
      Left            =   1680
      TabIndex        =   3
      Top             =   1680
      Width           =   2775
   End
   Begin VB.TextBox Txt_ICode 
      Height          =   285
      Left            =   240
      TabIndex        =   1
      Top             =   1680
      Width           =   1335
   End
   Begin MSFlexGridLib.MSFlexGrid Grd_Codes 
      Height          =   4215
      Left            =   360
      TabIndex        =   0
      Top             =   3120
      Width           =   10095
      _ExtentX        =   17806
      _ExtentY        =   7435
      _Version        =   393216
   End
   Begin VB.Label Label4 
      Caption         =   "Code Type"
      Height          =   255
      Left            =   7440
      TabIndex        =   8
      Top             =   1320
      Width           =   1575
   End
   Begin VB.Label Label3 
      Caption         =   "Maintenance Branch"
      Height          =   255
      Left            =   4800
      TabIndex        =   7
      Top             =   1320
      Width           =   1575
   End
   Begin VB.Label Label2 
      Caption         =   "Description/Comment"
      Height          =   255
      Left            =   1800
      TabIndex        =   6
      Top             =   1320
      Width           =   2295
   End
   Begin VB.Label Label1 
      Caption         =   "Status Code"
      Height          =   255
      Left            =   480
      TabIndex        =   2
      Top             =   1320
      Width           =   975
   End
End
Attribute VB_Name = "Frm_ICodes"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim sline As String
Dim icol As Long
Dim LG_GridIdx As Long
Dim Code_ID As Long
Dim step As Long

Private Sub Cmd_AddSave_Click()
    If Txt_ICode.Text = "" Then
        MsgBox ("you can't have a blank Status code"), vbOKOnly
        Exit Sub
    End If
    If Txt_IDesc.Text = "" Then
        MsgBox ("you can't have a blank Description"), vbOKOnly
        Exit Sub
    End If
    If Cbo_Branch.ListIndex = -1 Then
        MsgBox ("you can't have a blank Maintenance Branch"), vbOKOnly
        Exit Sub
    End If
    If Cbo_IType.ListIndex = -1 Then
        MsgBox ("you can't have a blank code type"), vbOKOnly
        Exit Sub
    End If
    If Code_ID = 0 Then
        sSql = "Insert into incident_codes (ic_type, ic_branch, ic_abrv, ic_description) values(" & _
        Cbo_Branch.ItemData(Cbo_Branch.ListIndex) & "," & Cbo_IType.ItemData(Cbo_IType.ListIndex) & _
        ",'" & Trim(Txt_ICode.Text) & "','" & Txt_IDesc.Text & "')"
    Else
        sSql = "update incident_codes set ic_type=" & Cbo_IType.ItemData(Cbo_IType.ListIndex) & _
        ", ic_branch=" & Cbo_Branch.ItemData(Cbo_Branch.ListIndex) & ", ic_abrv= '" & Trim(Txt_ICode.Text) & _
        "', ic_description='" & Trim(Txt_ICode.Text) & "' where ic_id =" & Code_ID
    End If
    SQLData.Execute (sSql)
    Code_ID = 0
    Call Cmd_Reset_Click

End Sub

Private Sub Cmd_Reset_Click()
    Txt_ICode.Text = ""
    Txt_IDesc.Text = ""
    Cbo_IType.ListIndex = -1
    Cbo_Branch.ListIndex = -1
    Code_ID = 0
End Sub

Private Sub Form_Load()

Dim Branches(5) As String
Dim Codes(4) As String
Codes(0) = " "
Codes(1) = "Equipment types"
Codes(2) = "Original Status/Defects"
Codes(3) = "Action Taken"

Branches(0) = " "
Branches(1) = " "
Branches(2) = "Subway Tech"
Branches(3) = "Bus/Trolly Tech"
Branches(4) = "Both"

    Call Init_Grd_Codes
    sSql = "select * from Incident_codes where ic_type in (2,3)"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
    
        sline = RS_Trans("IC_ID") & vbTab & _
            RS_Trans("ic_abrv") & vbTab & _
            RS_Trans("IC_description") & vbTab & _
            Branches(RS_Trans("IC_Branch")) & vbTab & _
            RS_Trans("IC_Branch") & vbTab & _
            Codes(RS_Trans("ic_type")) & vbTab & _
            RS_Trans("ic_type")
            Grd_Codes.AddItem sline
        RS_Trans.MoveNext
    Loop
    Call Get_Trans("Close")
    
End Sub

Private Sub Grd_Codes_Click()
    LG_GridIdx = Grd_Codes.Row

    LG_GridIdx = Grd_Codes.Row
    If LG_GridIdx = 0 Then
        Grd_Codes.FixedRows = 1
        Grd_Codes.sort = 1
        Grd_Codes.Refresh
        Grd_Codes.FixedRows = 0
        Txt_ICode.Text = ""
        Txt_IDesc.Text = ""
        Cbo_Branch.ListIndex = -1
        Cbo_IType.ListIndex = -1
        Exit Sub
    End If
    Code_ID = Grd_Codes.TextMatrix(LG_GridIdx, 0)
    Txt_ICode = Grd_Codes.TextMatrix(LG_GridIdx, 1)
    Txt_IDesc = Grd_Codes.TextMatrix(LG_GridIdx, 2)
    For step = 0 To Cbo_Branch.ListCount
        If Cbo_Branch.ItemData(step) = CInt(Trim(Grd_Codes.TextMatrix(LG_GridIdx, 4))) Then
            Cbo_Branch.ListIndex = step
            step = Cbo_Branch.ListCount
        End If
    Next
    For step = 0 To Cbo_IType.ListCount
        If Cbo_IType.ItemData(step) = CInt(Trim(Grd_Codes.TextMatrix(LG_GridIdx, 6))) Then
            Cbo_IType.ListIndex = step
            step = Cbo_IType.ListCount
        End If
    Next


End Sub

Public Sub Init_Grd_Codes()
With Grd_Codes
.Clear
    .AllowUserResizing = flexResizeColumns
    
    .Rows = 1
    .Cols = 7
    .FixedCols = 0
    .FixedRows = 0
    
    .TextMatrix(0, 0) = "Index"
    .TextMatrix(0, 1) = "Code"
    .TextMatrix(0, 2) = "Description"
    .TextMatrix(0, 3) = "Maint Branch"
    .TextMatrix(0, 4) = "BranchID"
    .TextMatrix(0, 5) = "Code Type"
    .TextMatrix(0, 6) = "CodID"

    .ColWidth(0) = 0
    .ColWidth(1) = 1000
    .ColWidth(2) = 2500
    .ColWidth(3) = 2000
    .ColWidth(4) = 0
    .ColWidth(5) = 2000
    .ColWidth(6) = 0

    .ColAlignment(0) = flexAlignLeftCenter
    .ColAlignment(1) = flexAlignLeftCenter
    .ColAlignment(2) = flexAlignLeftCenter
    .ColAlignment(3) = flexAlignLeftCenter
    .ColAlignment(4) = flexAlignLeftCenter
    For icol = 0 To 6
        .col = icol
        .Row = 0
        .CellBackColor = &HC0C0C0
    Next
End With

End Sub

