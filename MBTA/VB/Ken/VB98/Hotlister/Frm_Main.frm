VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "Msflxgrd.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "Comdlg32.ocx"
Begin VB.Form Frm_Main 
   Caption         =   "School SmartCard distribution system"
   ClientHeight    =   7350
   ClientLeft      =   3105
   ClientTop       =   1545
   ClientWidth     =   9855
   LinkTopic       =   "Form1"
   ScaleHeight     =   7350
   ScaleWidth      =   9855
   Begin VB.ComboBox Combo1 
      Height          =   315
      ItemData        =   "Frm_Main.frx":0000
      Left            =   2520
      List            =   "Frm_Main.frx":000D
      TabIndex        =   8
      Top             =   1200
      Width           =   2415
   End
   Begin VB.CommandButton Cmd_Block 
      Caption         =   "Hotlist"
      Height          =   615
      Left            =   6240
      TabIndex        =   7
      Top             =   1200
      Width           =   1815
   End
   Begin VB.ComboBox Cbo_Reason 
      Height          =   315
      ItemData        =   "Frm_Main.frx":002D
      Left            =   2520
      List            =   "Frm_Main.frx":002F
      TabIndex        =   4
      Top             =   1560
      Width           =   2415
   End
   Begin VB.TextBox Txt_Charliecard_Block 
      Height          =   285
      Left            =   2520
      TabIndex        =   2
      Top             =   720
      Width           =   2415
   End
   Begin VB.Timer Timer1 
      Left            =   840
      Top             =   6840
   End
   Begin MSComDlg.CommonDialog cmdialog1 
      Left            =   120
      Top             =   6840
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      DialogTitle     =   "Explorer"
      InitDir         =   "H:\Data32\ExtScImp"
   End
   Begin MSFlexGridLib.MSFlexGrid Grd_Cards 
      Height          =   3255
      Left            =   360
      TabIndex        =   6
      Top             =   2640
      Width           =   8655
      _ExtentX        =   15266
      _ExtentY        =   5741
      _Version        =   393216
   End
   Begin VB.Label Label1 
      Caption         =   "Ticket Type"
      Height          =   255
      Left            =   600
      TabIndex        =   9
      Top             =   1200
      Width           =   1695
   End
   Begin VB.Label Label5 
      Caption         =   "Reason For Block"
      Height          =   255
      Left            =   480
      TabIndex        =   5
      Top             =   1560
      Width           =   1335
   End
   Begin VB.Label Label4 
      Caption         =   "Serialnumber to hotlist"
      Height          =   255
      Left            =   480
      TabIndex        =   3
      Top             =   720
      Width           =   1815
   End
   Begin VB.Label Lbl_Comp 
      Height          =   255
      Left            =   6600
      TabIndex        =   1
      Top             =   480
      Width           =   2175
   End
   Begin VB.Label Lbl_User 
      Height          =   255
      Left            =   6600
      TabIndex        =   0
      Top             =   120
      Width           =   2055
   End
   Begin VB.Menu menu 
      Caption         =   "SmartCard Functions"
      Begin VB.Menu Import 
         Caption         =   "Import Production cards"
      End
      Begin VB.Menu BatchHotlist 
         Caption         =   "Batch Hotlist"
      End
   End
End
Attribute VB_Name = "Frm_Main"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim Filename As String
Dim Row As Long
Dim FSO As FileSystemObject
Dim fileMhs As File
Dim txtsMhs As TextStream
Dim Data As String
Dim dataMhs() As String
Dim Sequence As Long
Dim SchoolIDX As Long
Dim sline As String
Dim CharlieCard As String
Dim Last_Sequence As Long
Dim Card_Count As Long
Dim School_Enddate As Date
Dim Month As Long
Dim Year As Long






Private Sub Cmd_Block_Click()
    If Txt_Charliecard_Block.Text = "" Then
        MsgBox ("You must enter a valid CharlieCard to block"), vbOKOnly
        Exit Sub
    End If
    If Combo1.ListIndex = -1 Then
        MsgBox ("You must select a Ticket type"), vbOKOnly
        Exit Sub
    End If
    If Cbo_Reason.ListIndex = -1 Then
        MsgBox ("You must select a reason for blocking this CharlieCard"), vbOKOnly
        Exit Sub
    End If
    
    sSql = "select * from hotlist where serialnumber = " & Trim(Txt_Charliecard_Block.Text)
    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAdata.Execute(sSql)
    
    If RsWork.EOF <> True Then
        MsgBox ("The serialnumber entered is already on the hotlist"), vbOKOnly
        Txt_Charliecard_Block.Text = ""
        Cbo_Reason.ListIndex = -1
        Combo1.ListIndex = -1
        Txt_Charliecard_Block.SetFocus
        RsWork.Close
        Set RsWork = Nothing
        Exit Sub
    End If
    
   
    If MsgBox("Are you sure you want to block the Serialnumber # " & Trim(Txt_Charliecard_Block.Text), vbYesNo) = vbYes Then


' Insert into S&B Hotlist

        sSql = "INSERT INTO hotlist(mediatype, serialnumber,xvalidfrom, serialnumberub, sreason, " & _
        "xvaliduntil, status, usernew, timenew, userchange, timechange) " & _
        "VALUES(" & Combo1.ItemData(Combo1.ListIndex) & "," & Trim(Txt_Charliecard_Block.Text) & ", To_Date('" & Format(Now, "mm/dd/yyyy") & "','mm/dd/yyyy'), " & _
        Trim(Txt_Charliecard_Block.Text) & "," & Cbo_Reason.ItemData(Cbo_Reason.ListIndex) & _
        ",To_Date('" & Format(School_Enddate, "mm/dd/yyyy") & "','mm/dd/yyyy'), 1," & _
        "'HOTLIST',to_date('" & Format(Now, "mm/dd/yyyy hh:mm:ss") & "','mm/dd/yyyy-HH24:MI:SS'), " & _
        "'HOTLIST',to_date('" & Format(Now, "mm/dd/yyyy hh:mm:ss") & "','mm/dd/yyyy-HH24:MI:SS'))"
        ORAdata.Execute (sSql)
        
    End If
    RsWork.Close
    Set RsWork = Nothing
    Txt_Charliecard_Block.Text = ""
    Combo1.ListIndex = -1
    Cbo_Reason.ListIndex = -1
    
End Sub






Private Sub Form_Load()
    Lbl_User = "User: " & User_Name
    Lbl_Comp = "Workstation: " & Comp_Name
    
    MappedLetter = "\\mbtasql\Sharing and apps\"
    PGBLprogname = App.EXEName
    UpDowncount = 0
    
    PGBLprogstatus = PGBLcheckprogstat(MappedLetter, PGBLprogname)
    If UCase(PGBLprogstatus) = "DOWN" Then
        On Error Resume Next
        SQLdata.Close
        Set SQLdata = Nothing
        Unload Me
        End
     End If
    
    sSql = "SELECT * FROM carddenialreasons ORDER BY reasondesc"
    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAdata.Execute(sSql)
    Do While RsWork.EOF = False
        Data = ""
        Data = RsWork("reason") & "   " & RsWork("reasondesc")
        Cbo_Reason.AddItem (Data)
        Cbo_Reason.ItemData(Cbo_Reason.NewIndex) = RsWork("reason")
        RsWork.MoveNext
    Loop
   RsWork.Close
   Set RsWork = Nothing
    
    
    
    
    Month = Mid(Format(Now, "mm/dd/yyyy"), 1, 2)
    Year = Mid(Format(Now, "mm/dd/yyyy"), 7, 4)
    
    
    School_Enddate = "07/01/2100"
    
End Sub





Private Sub Timer1_Timer()
    MappedLetter = "\\mbtasql\Sharing and apps\"
    PGBLprogname = App.EXEName
    UpDowncount = 0
    PGBLprogstatus = PGBLcheckprogstat(MappedLetter, PGBLprogname)
    If UCase(PGBLprogstatus) = "DOWN" Then
        On Error Resume Next
        Unload Me
        End
     End If

    If Inputcheck = True Then '<<<<<<<<<<<<<<<<<<< this will detect any mousemove or key
         myloop = 0
         Exit Sub
    End If
    
    PGBLprogstatus = PGBLcheckprogstat(MappedLetter, PGBLprogname)
    If UCase(PGBLprogstatus) = "DOWN" Then
        On Error Resume Next
        SQLdata.Close
        Set SQLdata = Nothing
        Unload Me
        End
     End If

Dim myForm As Form

myloop = myloop + 1
If myloop < 3 Then Exit Sub 'if not 5 minutes then do nothing
SQLdata.Close
Set SQLdata = Nothing

'this will close all open forms beside the main form
End

'put the code for logoff here

myloop = 0 'zero myLoop
End Sub

Public Sub Grd_Cards_Init()
Dim icol As Long

With Grd_Cards
    .Clear
    .AllowUserResizing = flexResizeColumns
    
    .Rows = 1
    .Cols = 5
    .FixedCols = 0
    .FixedRows = 0
    
    .TextMatrix(0, 0) = "Sequence"
    .TextMatrix(0, 1) = "CharlieCard"
    .TextMatrix(0, 2) = "Date Assigned"
    .TextMatrix(0, 3) = "Date Blocked"
    .TextMatrix(0, 4) = "Blocked Reason"
    


    .ColWidth(0) = 1400
    .ColWidth(1) = 1400
    .ColWidth(2) = 1400
    .ColWidth(3) = 1600
    .ColWidth(4) = 2200
    
    
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
