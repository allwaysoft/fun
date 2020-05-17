VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Begin VB.Form Frm_Reservations 
   Caption         =   "Reservations"
   ClientHeight    =   1875
   ClientLeft      =   1245
   ClientTop       =   2175
   ClientWidth     =   7635
   LinkTopic       =   "Form1"
   ScaleHeight     =   1875
   ScaleWidth      =   7635
   Begin MSFlexGridLib.MSFlexGrid Grid_Res 
      Height          =   1215
      Left            =   480
      TabIndex        =   0
      Top             =   360
      Width           =   5775
      _ExtentX        =   10186
      _ExtentY        =   2143
      _Version        =   393216
   End
End
Attribute VB_Name = "Frm_Reservations"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim sline As String
Dim dis_name As String
Private Sub Form_Load()

    Call Grid_Res_Init
    Call Load_Grid_Res
               
End Sub

Public Sub Load_Grid_Res()

    sSql = "select ate.at_id, ate.at_emplname, ate.at_empfname, ath.ath_time, ath.ath_index from afc_technicians ate " & _
            "left outer join afc_transaction_history ath on ate.at_id = ath.ath_empno " & _
            "where ath.ath_tran_type = 1 and isnull(ath.ath_closed,0) <> 1 and ath.ath_partno =" & tAI_Index & _
            " and ath.ath_location = " & CLng(FRM_Main.Grid_LocBal.TextMatrix(FRM_Main.Grid_LocBal.Row, 0))
    Call Get_Trans("Read")
    dis_name = ""
    Do While RS_Trans.EOF = False
        dis_name = Trim(RS_Trans("at_empfname")) & " " & RS_Trans("at_emplname")
        sline = dis_name & vbTab & _
        RS_Trans("ath_time") & vbTab & _
        RS_Trans("ath_index") & vbTab & _
        RS_Trans("at_id")
        
        Grid_Res.AddItem sline
    
        RS_Trans.MoveNext
    Loop
        
    RS_Trans.Close
    Set RS_Trans = Nothing
 End Sub
 
Public Sub Grid_Res_Init()
With Grid_Res
    
    .Clear
    .AllowUserResizing = flexResizeColumns
    .Rows = 1
    .Cols = 4
    .FixedCols = 0

    
    .TextMatrix(0, 0) = "Name"
    .TextMatrix(0, 1) = "Date and Time"
    .TextMatrix(0, 2) = "Ath index"
    .TextMatrix(0, 3) = "Tech ID"

    
    
    .ColWidth(0) = 2400
    .ColWidth(1) = 2000
    .ColWidth(2) = 0
    .ColWidth(3) = 0
    
    .ColAlignment(0) = flexAlignLeftCenter
    .ColAlignment(1) = flexAlignLeftCenter
End With
End Sub

Private Sub Grid_Res_Click()
    If Current_User_Level < 6 Then Exit Sub
    sSql = "update AFC_LocBalance set alb_reserve = alb_reserve-1 where alb_location = " & CLng(FRM_Main.Grid_LocBal.TextMatrix(FRM_Main.Grid_LocBal.Row, 0)) & _
            " and alb_partno = " & tAI_Index
    SQLData.Execute (sSql)
    
    sSql = "update afc_transaction_History set ath_closed = 1, ath_candate='" & Now & "'" & _
        " where ath_empno = " & CLng(Grid_Res.TextMatrix(Grid_Res.Row, 3)) & _
        " and ath_location = " & CLng(FRM_Main.Grid_LocBal.TextMatrix(FRM_Main.Grid_LocBal.Row, 0)) & _
        " and ath_partno = " & tAI_Index
    SQLData.Execute (sSql)
    Call Grid_Res_Init
    Call Load_Grid_Res
End Sub
