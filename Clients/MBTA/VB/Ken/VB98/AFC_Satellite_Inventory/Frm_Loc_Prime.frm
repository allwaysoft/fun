VERSION 5.00
Begin VB.Form Frm_Loc_Prime 
   Caption         =   "Form1"
   ClientHeight    =   2805
   ClientLeft      =   1410
   ClientTop       =   1515
   ClientWidth     =   7350
   LinkTopic       =   "Form1"
   ScaleHeight     =   2805
   ScaleWidth      =   7350
   Begin VB.CommandButton Cmd_Close 
      Caption         =   "Close"
      Height          =   495
      Left            =   5160
      TabIndex        =   3
      Top             =   2160
      Width           =   1455
   End
   Begin VB.CommandButton Cmd_Generate 
      Caption         =   "Generate Records"
      Height          =   495
      Left            =   5160
      TabIndex        =   2
      Top             =   1320
      Width           =   1455
   End
   Begin VB.ComboBox Cbo_Location 
      Height          =   315
      Left            =   240
      TabIndex        =   1
      Top             =   840
      Width           =   5535
   End
   Begin VB.Label Label1 
      Caption         =   "Generate Blank records for new satellite location"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   360
      TabIndex        =   0
      Top             =   240
      Width           =   6135
   End
End
Attribute VB_Name = "Frm_Loc_Prime"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim sline As String

Private Sub Cmd_Close_Click()
Unload Me
End Sub

Private Sub Cmd_Generate_Click()
    sSql = " select ai_index,ai_partno from afc_inventory where ai_satellite = 'Y'"
    Call Get_Trans("Read")
    
    Do While RS_Trans.EOF = False
        On Error Resume Next
        sSql = "insert into afc_locbalance (alb_location,alb_partno,alb_onhand, alb_damaged, alb_reserve) values("
        sSql = sSql & Cbo_Location.ItemData(Cbo_Location.ListIndex) & "," & RS_Trans("ai_index") & ",0,0,0)"
        SQLData.Execute (sSql)
        On Error GoTo 0
        RS_Trans.MoveNext
    Loop
    MsgBox ("Base records have been created"), vbOKOnly
    Call Get_Trans("Close")
End Sub

Private Sub Form_Load()
    sSql = "select al_id,al_abrv, al_location_Name from AFC_location where al_location_Type in (1,2) order by al_location_name"
    Call Get_Location("Read")
    Cbo_Location.Clear

    Do While RS_Location.EOF = False
        sline = Trim(RS_Location("AL_Abrv")) & "  " & _
        Trim(RS_Location("AL_Location_Name"))
            Cbo_Location.AddItem sline
            Cbo_Location.ItemData(Cbo_Location.NewIndex) = RS_Location("al_id")
    RS_Location.MoveNext
    Loop
    Call Get_Location("Close")

End Sub
