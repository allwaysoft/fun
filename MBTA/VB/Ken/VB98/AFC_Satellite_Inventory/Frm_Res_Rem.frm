VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Begin VB.Form Frm_Res_Rem 
   Caption         =   "Remove Reservations"
   ClientHeight    =   5430
   ClientLeft      =   630
   ClientTop       =   1695
   ClientWidth     =   10530
   LinkTopic       =   "Form1"
   ScaleHeight     =   5430
   ScaleWidth      =   10530
   Begin MSFlexGridLib.MSFlexGrid Grid_Remove 
      Height          =   3135
      Left            =   480
      TabIndex        =   0
      Top             =   1560
      Width           =   9855
      _ExtentX        =   17383
      _ExtentY        =   5530
      _Version        =   393216
   End
   Begin VB.Label Label1 
      Caption         =   "Click on the item to remove the reservation"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   1320
      TabIndex        =   1
      Top             =   240
      Width           =   8415
   End
End
Attribute VB_Name = "Frm_Res_Rem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim sline As String
Dim LG_GridIdx As Long

Private Sub Form_Load()
Call Grid_Remove_Init
    
    sSql = "SELECT ath.ATH_Index,ath.ATH_Empno, ath.ATH_Tran_type, ath.ATH_Qty, ath.ATH_Location, " & _
            "ath.ATH_CanDate, ath.ATH_Incident, ai.ai_index, ai.AI_Partno, ai.AI_Description, " & _
            "al.al_id, al.AL_Location_Name, at.at_id, at.at_empfname, at.at_emplname, ath.ath_tran_date " & _
            "FROM AFC_Transaction_History ath " & _
            "LEFT OUTER JOIN AFC_Location al ON ath.ATH_Location = al.AL_ID " & _
            "LEFT OUTER JOIN AFC_Inventory ai ON ath.ATH_Partno = ai.AI_Index " & _
            "Left outer join afc_technicians at on ath.ath_empno = at.at_id " & _
            "WHERE (ath.ATH_Tran_type = 1 and ISNULL(ath.ATH_CanDate,'') = '')"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        sline = RS_Trans("ath_index") & vbTab & _
            RS_Trans("ai_partno") & Trim(RS_Trans("ai_description")) & vbTab & _
            RS_Trans("ai_index") & vbTab & _
            RS_Trans("al_location_name") & vbTab & _
            RS_Trans("al_id") & vbTab & _
            Trim(RS_Trans("at_empfname")) & " " & Trim(RS_Trans("at_emplname")) & vbTab & _
            RS_Trans("at_id") & vbTab & _
            RS_Trans("ath_tran_date")
            
            Grid_Remove.AddItem sline
            
        RS_Trans.MoveNext
    Loop
End Sub

Public Sub Grid_Remove_Init()
    Grid_Remove.Clear
    Grid_Remove.AllowUserResizing = flexResizeColumns
    
    Grid_Remove.Rows = 1
    Grid_Remove.Cols = 8
    Grid_Remove.FixedCols = 0
    
    Grid_Remove.TextMatrix(0, 0) = "Tran ID"
    Grid_Remove.TextMatrix(0, 1) = "Part/Desc"
    Grid_Remove.TextMatrix(0, 2) = "I_ID"
    
    Grid_Remove.TextMatrix(0, 3) = "Location"
    Grid_Remove.TextMatrix(0, 4) = "Loc_ID"

    Grid_Remove.TextMatrix(0, 5) = "Technician"
    Grid_Remove.TextMatrix(0, 6) = "Tech_ID"
    Grid_Remove.TextMatrix(0, 7) = "Date Reserved"

    Grid_Remove.ColWidth(0) = 0
    Grid_Remove.ColWidth(1) = 2500
    Grid_Remove.ColWidth(2) = 0
    Grid_Remove.ColWidth(3) = 2000
    Grid_Remove.ColWidth(4) = 0
    Grid_Remove.ColWidth(5) = 2000
    Grid_Remove.ColWidth(6) = 0
    Grid_Remove.ColWidth(7) = 1200

    Grid_Remove.ColAlignment(0) = flexAlignLeftCenter
    Grid_Remove.ColAlignment(1) = flexAlignLeftCenter
    Grid_Remove.ColAlignment(2) = flexAlignLeftCenter
    Grid_Remove.ColAlignment(3) = flexAlignLeftCenter
    Grid_Remove.ColAlignment(4) = flexAlignLeftCenter
    Grid_Remove.ColAlignment(5) = flexAlignLeftCenter
    Grid_Remove.ColAlignment(6) = flexAlignLeftCenter
    Grid_Remove.ColAlignment(7) = flexAlignLeftCenter

End Sub

Private Sub Grid_Remove_Click()
    LG_GridIdx = Grid_Remove.Row

    If MsgBox("This will remove this reservation", vbCritical + vbYesNo) = vbNo Then
        Exit Sub
    End If
    
    sSql = "Update afc_transaction_history set ATH_candate = '" & Now & "', ath_closed=1 where ath_index = " & CLng(Grid_Remove.TextMatrix(LG_GridIdx, 0))
    SQLData.Execute (sSql)
    
    sSql = "update afc_locbalance set alb_reserve = alb_reserve -1 where alb_location = " & CLng(Grid_Remove.TextMatrix(LG_GridIdx, 4)) & " and alb_partno = " & CLng(Grid_Remove.TextMatrix(LG_GridIdx, 2))
    SQLData.Execute (sSql)

End Sub
