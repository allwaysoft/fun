VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Begin VB.Form Frm_Incident_MM 
   Caption         =   "Incident Inventory Miss Match"
   ClientHeight    =   6840
   ClientLeft      =   345
   ClientTop       =   1440
   ClientWidth     =   11670
   LinkTopic       =   "Form1"
   ScaleHeight     =   6840
   ScaleWidth      =   11670
   Begin VB.CommandButton Cmd_View_Closed 
      Caption         =   "View Closed Components"
      Height          =   495
      Left            =   5760
      TabIndex        =   2
      Top             =   1200
      Width           =   1695
   End
   Begin VB.CommandButton Cmd_View_open 
      Caption         =   "View Unresolved Components"
      Height          =   495
      Left            =   2880
      TabIndex        =   1
      Top             =   1200
      Width           =   1695
   End
   Begin MSFlexGridLib.MSFlexGrid Grd_Missmatch 
      Height          =   4215
      Left            =   720
      TabIndex        =   0
      Top             =   1800
      Width           =   10335
      _ExtentX        =   18230
      _ExtentY        =   7435
      _Version        =   393216
   End
End
Attribute VB_Name = "Frm_Incident_MM"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim icol As Long
Dim sline As String


Private Sub Cmd_View_Closed_Click()
    sSql = "SELECT IE_ID, IE_Incident, IE_Partno, IE_Serialno, IE_Machineno, IE_Date_Worked," & _
    "AI_Partno, AI_Description, I_Incidentno , AU_MBTAno " & _
    "FROM Incident_Exceptions " & _
    "LEFT OUTER JOIN AFC_UnitTable ON IE_Machineno = AU_Index " & _
    "LEFT OUTER JOIN AFC_Inventory ON IE_Partno = AI_Index " & _
    "LEFT OUTER JOIN Incident ON IE_Incident = I_ID " & _
    "WHERE ISNULL(Incident_Exceptions.IE_Verified, '') = 'Y'"
    Call Get_Trans("Read")
    Grd_Missmatch_Init
    Do While RS_Trans.EOF = False
        sline = RS_Trans("ie_id") & vbTab & _
            RS_Trans("ie_incident") & vbTab & _
            RS_Trans("ie_partno") & vbTab & _
            RS_Trans("ie_machineno") & vbTab & _
            RS_Trans("I_Incidentno") & vbTab & _
            RS_Trans("au_mbtano") & vbTab & _
            RS_Trans("Ie_serialno") & vbTab & _
            RS_Trans("ai_description") & vbTab & _
            RS_Trans("ie_date_worked")
            
            Grd_Missmatch.AddItem sline
        RS_Trans.MoveNext
    Loop
    Call Get_Trans("Close")
    
End Sub

Private Sub Cmd_View_open_Click()
    sSql = "SELECT IE_ID, IE_Incident, IE_Partno, IE_Serialno, IE_Machineno, IE_Date_Worked," & _
    "AI_Partno, AI_Description, I_Incidentno , AU_MBTAno " & _
    "FROM Incident_Exceptions " & _
    "LEFT OUTER JOIN AFC_UnitTable ON IE_Machineno = AU_Index " & _
    "LEFT OUTER JOIN AFC_Inventory ON IE_Partno = AI_Index " & _
    "LEFT OUTER JOIN Incident ON IE_Incident = I_ID " & _
    "WHERE ISNULL(Incident_Exceptions.IE_Verified, '') = '' " 'and isnull(incident_parts.ip_verified,'')=''"
    Call Get_Trans("Read")
    Debug.Print sSql
    Grd_Missmatch_Init
    Do While RS_Trans.EOF = False
        sline = RS_Trans("ie_id") & vbTab & _
            RS_Trans("ie_incident") & vbTab & _
            RS_Trans("ie_partno") & vbTab & _
            RS_Trans("ie_machineno") & vbTab & _
            RS_Trans("I_Incidentno") & vbTab & _
            RS_Trans("au_mbtano") & vbTab & _
            RS_Trans("Ie_serialno") & vbTab & _
            RS_Trans("ai_partno") & vbTab & _
            RS_Trans("ai_description") & vbTab & _
            RS_Trans("ie_date_worked")
            
            Grd_Missmatch.AddItem sline
        RS_Trans.MoveNext
    Loop
    
    Call Get_Trans("Close")

End Sub

Public Sub Grd_Missmatch_Init()
With Grd_Missmatch
    .Clear
    .AllowUserResizing = flexResizeColumns
    
    .Rows = 1
    .Cols = 10
    .FixedCols = 0
    .FixedRows = 0
    
    .TextMatrix(0, 0) = "IE_Id"
    .TextMatrix(0, 1) = "IE_Incident"
    .TextMatrix(0, 2) = "IE_Partno"
    .TextMatrix(0, 3) = "IE_Machineno"
    .TextMatrix(0, 4) = "Incident #"
    .TextMatrix(0, 5) = "Device #"
    .TextMatrix(0, 6) = "Serial #"
    .TextMatrix(0, 7) = "Part #"
    .TextMatrix(0, 8) = "Part/Description"
    .TextMatrix(0, 9) = "Date Worked"
    

    .ColWidth(0) = 0
    .ColWidth(1) = 0
    .ColWidth(2) = 0
    .ColWidth(3) = 0
    .ColWidth(4) = 1200
    .ColWidth(5) = 1200
    .ColWidth(6) = 1200
    .ColWidth(7) = 1200
    .ColWidth(8) = 2500
    .ColWidth(9) = 1200

    .ColAlignment(0) = flexAlignLeftCenter
    .ColAlignment(1) = flexAlignLeftCenter
    .ColAlignment(2) = flexAlignLeftCenter
    .ColAlignment(3) = flexAlignLeftCenter
    .ColAlignment(4) = flexAlignLeftCenter
    .ColAlignment(5) = flexAlignLeftCenter
    .ColAlignment(7) = flexAlignLeftCenter
    .ColAlignment(8) = flexAlignLeftCenter
    .ColAlignment(9) = flexAlignLeftCenter
    For icol = 0 To 9
        .col = icol
        .row = 0
        .CellBackColor = &HC0C0C0
    Next
End With
End Sub

