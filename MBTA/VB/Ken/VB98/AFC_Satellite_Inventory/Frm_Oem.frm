VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Begin VB.Form Frm_Oem 
   Caption         =   "OEM Search"
   ClientHeight    =   4515
   ClientLeft      =   810
   ClientTop       =   1590
   ClientWidth     =   9150
   LinkTopic       =   "Form1"
   ScaleHeight     =   4515
   ScaleWidth      =   9150
   Begin VB.CommandButton Cmd_Exit 
      Caption         =   "Exit Lookup"
      Height          =   495
      Left            =   6840
      TabIndex        =   7
      Top             =   3840
      Width           =   1455
   End
   Begin VB.CommandButton Cmd_Search 
      Caption         =   "Search"
      Height          =   375
      Left            =   4200
      TabIndex        =   5
      Top             =   960
      Width           =   1335
   End
   Begin MSFlexGridLib.MSFlexGrid Grid_Lookup 
      Height          =   1935
      Left            =   480
      TabIndex        =   4
      Top             =   1560
      Width           =   8295
      _ExtentX        =   14631
      _ExtentY        =   3413
      _Version        =   393216
   End
   Begin VB.TextBox Txt_SrchDesc 
      Height          =   285
      Left            =   1320
      TabIndex        =   3
      Top             =   960
      Width           =   2535
   End
   Begin VB.TextBox Txt_SrchOEM 
      Height          =   285
      Left            =   1320
      TabIndex        =   1
      Top             =   450
      Width           =   1575
   End
   Begin VB.Label Label3 
      Caption         =   $"Frm_Oem.frx":0000
      Height          =   615
      Left            =   3960
      TabIndex        =   6
      Top             =   120
      Width           =   4935
   End
   Begin VB.Label Label2 
      Caption         =   "Description"
      Height          =   255
      Left            =   240
      TabIndex        =   2
      Top             =   990
      Width           =   975
   End
   Begin VB.Label Label1 
      Caption         =   "EOM #"
      Height          =   255
      Left            =   240
      TabIndex        =   0
      Top             =   480
      Width           =   735
   End
End
Attribute VB_Name = "Frm_Oem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim icol As Long
Dim sline As String
Dim LG_GridIdx As Long

Private Sub Cmd_Exit_Click()
    Pass_Index = 0
    Unload Me
End Sub

Private Sub Cmd_Search_Click()
If Txt_SrchOEM.Text <> "" And Txt_SrchDesc.Text <> "" Then
    MsgBox ("You canonly select one search cryteria option")
    Exit Sub
End If

    sSql = "Select ai_index, ai_partno, ai_oempartno, ai_description, ai_parttype from afc_inventory where "
    If Txt_SrchOEM.Text <> "" Then
        sSql = sSql & " ai_oempartno like '%" & Trim(Txt_SrchOEM.Text) & "%'"
    Else
        sSql = sSql & " ai_description like '%" & Trim(Txt_SrchDesc.Text) & "%'"
    End If
    
    Call Get_Inventory("Read")

    If RS_Inventory.EOF = True Then
        MsgBox ("nothing found for selected criteria")
        Call Get_Inventory("Close")
        Exit Sub
    End If

    Do While RS_Inventory.EOF = False
        sline = RS_Inventory("ai_index") & vbTab & _
        RS_Inventory("AI_Partno") & vbTab & _
        RS_Inventory("AI_OEMPartno") & vbTab & _
        RS_Inventory("AI_Description") & vbTab & _
        RS_Inventory("AI_Parttype")
        
        Grid_Lookup.AddItem sline
        
        RS_Inventory.MoveNext
    Loop
End Sub

Private Sub Form_Load()
    Call Grid_Lookup_Init

End Sub

Public Sub Grid_Lookup_Init()
With Grid_Lookup
    .Clear
    .AllowUserResizing = flexResizeColumns
    
    .Rows = 1
    .Cols = 5
    .FixedCols = 0
    .FixedRows = 0
    
    .TextMatrix(0, 0) = "Index"
    .TextMatrix(0, 1) = "S&B Part#"
    .TextMatrix(0, 2) = "OEM Part#"
    .TextMatrix(0, 3) = "Description"
    .TextMatrix(0, 4) = "Part Type"

    .ColWidth(0) = 0
    .ColWidth(1) = 1200
    .ColWidth(2) = 1200
    .ColWidth(3) = 2500
    .ColWidth(4) = 15000

    .ColAlignment(0) = flexAlignLeftCenter
    .ColAlignment(1) = flexAlignLeftCenter
    .ColAlignment(2) = flexAlignLeftCenter
    .ColAlignment(3) = flexAlignLeftCenter
    .ColAlignment(4) = flexAlignLeftCenter

    For icol = 0 To 4
        .Col = icol
        .Row = 0
        .CellBackColor = &HC0C0C0
    Next
End With

End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode = vbFormControlMenu Then
     Cancel = True
  End If
End Sub



Private Sub Grid_Lookup_Click()
    LG_GridIdx = Grid_Lookup.Row
    If LG_GridIdx = 0 Then
        Grid_Lookup.FixedRows = 1
        Grid_Lookup.Sort = 1
        Grid_Lookup.Refresh
        Grid_Lookup.FixedRows = 0
        Exit Sub
    End If

    Pass_Index = Grid_Lookup.TextMatrix(LG_GridIdx, 0)
    Unload Me
End Sub
