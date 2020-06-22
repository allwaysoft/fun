VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Begin VB.Form Frm_FileFinder 
   Caption         =   "Form1"
   ClientHeight    =   4275
   ClientLeft      =   1605
   ClientTop       =   1755
   ClientWidth     =   4185
   LinkTopic       =   "Form1"
   ScaleHeight     =   4275
   ScaleWidth      =   4185
   Begin VB.CommandButton Cmd_GetFile 
      Caption         =   "Open File"
      Height          =   495
      Left            =   2880
      TabIndex        =   0
      Top             =   3480
      Width           =   975
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   960
      Top             =   1560
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
End
Attribute VB_Name = "Frm_FileFinder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim file_path As String

Private Sub Cmd_GetFile_Click()

' Need to loop thru 3 work sheets in 1 work book

Dim sconn As String
Dim f_date As Date 'date
Dim f_device As String ' device id
Dim f_container As String ' container
Dim f_type As String 'Bagtype
Dim f_findings As String 'Research findings
      
      Set rs_work = New ADODB.Recordset
    
      rs_work.CursorLocation = adUseClient
      rs_work.CursorType = adOpenKeyset
      rs_work.LockType = adLockBatchOptimistic

      sconn = "DRIVER=Microsoft Excel Driver (*.xls);" & "DBQ=" & file_path
      rs_work.Open "SELECT * FROM [AFC$]", sconn
fix_err:
      Debug.Print Err.Description + " " + _
                  Err.Source, vbCritical, "Import"
      Err.Clear

    Do While rs_work.EOF = False
        f_date = Format(rs_work("date"), "mm/dd/yyyy")
        f_device = rs_work("device id")
        f_container = rs_work("container id")
        f_type = rs_work("bag type")
        f_findings = rs_work("research findings")
        
        'sSql = "insert into afc_unittable (au_partno, au_mbtano, au_serialno,au_daterolledout, au_location) values(98,'" & Name & "',' ','" & Inst & "'," & loc & ")"
        'SQLData.Execute (sSql)
        rs_work.MoveNext
        
    Loop
    rs_work.Close
    Set rswork = Nothing

End Sub

Private Sub Form_Load()
CommonDialog1.ShowOpen
file_path = CommonDialog1.FileName
End Sub
