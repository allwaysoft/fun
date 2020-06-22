VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Begin VB.Form Frm_Funding 
   Caption         =   "Federal and State Funding Information"
   ClientHeight    =   7995
   ClientLeft      =   1650
   ClientTop       =   1755
   ClientWidth     =   8520
   LinkTopic       =   "Form1"
   ScaleHeight     =   7995
   ScaleWidth      =   8520
   Begin MSFlexGridLib.MSFlexGrid Grid_Grant 
      Height          =   2655
      Left            =   240
      TabIndex        =   8
      Top             =   2880
      Width           =   7815
      _ExtentX        =   13785
      _ExtentY        =   4683
      _Version        =   393216
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   2
      Left            =   2280
      MaxLength       =   2
      TabIndex        =   7
      Top             =   1800
      Width           =   615
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   1
      Left            =   2280
      MaxLength       =   50
      TabIndex        =   6
      Top             =   1320
      Width           =   3495
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Index           =   0
      Left            =   2280
      MaxLength       =   15
      TabIndex        =   5
      Top             =   960
      Width           =   2415
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      ItemData        =   "Frm_Funding.frx":0000
      Left            =   2280
      List            =   "Frm_Funding.frx":000D
      TabIndex        =   1
      Top             =   480
      Width           =   2415
   End
   Begin VB.Label Label 
      Alignment       =   1  'Right Justify
      Caption         =   "Grant/Bond Percentage"
      Height          =   255
      Index           =   3
      Left            =   120
      TabIndex        =   4
      Top             =   1920
      Width           =   1935
   End
   Begin VB.Label Label 
      Alignment       =   1  'Right Justify
      Caption         =   "Grant/Bond Description"
      Height          =   255
      Index           =   2
      Left            =   120
      TabIndex        =   3
      Top             =   1440
      Width           =   1935
   End
   Begin VB.Label Label 
      Alignment       =   1  'Right Justify
      Caption         =   "Grant/Bond Number"
      Height          =   255
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   960
      Width           =   1935
   End
   Begin VB.Label Label 
      Alignment       =   1  'Right Justify
      Caption         =   "Grant Type"
      Height          =   255
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   480
      Width           =   1935
   End
End
Attribute VB_Name = "Frm_Funding"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim sline As String
Dim icol As Long
Private Sub Form_Load()
    
    Call Load_Grid_Grant
    
End Sub

Public Sub Grid_Grant_Init()
With Grid_Grant
    .Clear
    .AllowUserResizing = flexResizeColumns
    
    .Rows = 1
    .Cols = 5
    .FixedCols = 0
    .FixedRows = 0
    
    .TextMatrix(0, 0) = "Index"
    .TextMatrix(0, 1) = "Type"
    .TextMatrix(0, 2) = "Grant/Bond #"
    .TextMatrix(0, 3) = "Description"
    .TextMatrix(0, 4) = "Percentage"
    
    .ColWidth(0) = 0
    .ColWidth(1) = 1500
    .ColWidth(2) = 1500
    .ColWidth(3) = 2400
    .ColWidth(4) = 1500
    
    
    .ColAlignment(0) = flexAlignLeftCenter
    .ColAlignment(1) = flexAlignLeftCenter
    .ColAlignment(2) = flexAlignLeftCenter
    .ColAlignment(3) = flexAlignLeftCenter
    .ColAlignment(4) = flexAlignLeftCenter
    
    For icol = 0 To 4
        .col = icol
        .row = 0
        .CellBackColor = &HC0C0C0
    Next
End With
End Sub
Public Sub Load_Grid_Grant()
Dim GType As String

    Call Grid_Grant_Init
    
    sSql = "SELECT * from AFC_Grants"
    
    Call Get_Trans("Read")
    
    Do While RS_Trans.EOF = False
        GType = "Other"
        If RS_Trans("AG_Grant_Type") = 1 Then GType = "Federal"
        If RS_Trans("AG_Grant_Type") = 2 Then GType = "State"
        
        sline = RS_Trans("ag_id") & vbTab & _
        GType & vbTab & _
        Trim(RS_Trans("ag_grantno")) & vbTab & _
        Trim(RS_Trans("ag_description")) & vbTab & _
        Trim(RS_Trans("ag_percentage"))

        Grid_Grant.AddItem sline
        
        RS_Trans.MoveNext
    Loop
    Call Get_Trans("Close")
End Sub
