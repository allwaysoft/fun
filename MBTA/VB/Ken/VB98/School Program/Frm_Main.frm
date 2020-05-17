VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "Msflxgrd.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "Comdlg32.ocx"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form Frm_Main 
   Caption         =   "School SmartCard distribution system"
   ClientHeight    =   7530
   ClientLeft      =   2580
   ClientTop       =   2130
   ClientWidth     =   9525
   LinkTopic       =   "Form1"
   ScaleHeight     =   7530
   ScaleWidth      =   9525
   Begin MSComDlg.CommonDialog Cmn_Dailog4 
      Left            =   3000
      Top             =   6840
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin MSComDlg.CommonDialog Cmn_Dailog3 
      Left            =   2280
      Top             =   6840
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin MSComDlg.CommonDialog Cmn_Dialog2 
      Left            =   1560
      Top             =   6840
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Timer Timer1 
      Left            =   840
      Top             =   6840
   End
   Begin TabDlg.SSTab SSTab1 
      Height          =   5655
      Left            =   240
      TabIndex        =   0
      Top             =   1080
      Width           =   8895
      _ExtentX        =   15690
      _ExtentY        =   9975
      _Version        =   393216
      Tabs            =   5
      Tab             =   3
      TabsPerRow      =   5
      TabHeight       =   520
      TabCaption(0)   =   "Assign Smartcards"
      TabPicture(0)   =   "Frm_Main.frx":0000
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "Cbo_Days"
      Tab(0).Control(1)=   "Txt_SC2"
      Tab(0).Control(2)=   "Txt_S1"
      Tab(0).Control(3)=   "Txt_S2"
      Tab(0).Control(4)=   "Txt_SC1"
      Tab(0).Control(5)=   "Txt_Output"
      Tab(0).Control(6)=   "Cmd_AssignCards"
      Tab(0).Control(7)=   "Cbo_Schools"
      Tab(0).Control(8)=   "Txt_NumberCharliecards"
      Tab(0).Control(9)=   "Label15"
      Tab(0).Control(10)=   "Label8"
      Tab(0).Control(11)=   "Label7"
      Tab(0).Control(12)=   "Label3"
      Tab(0).Control(13)=   "Label2"
      Tab(0).Control(14)=   "Label1"
      Tab(0).ControlCount=   15
      TabCaption(1)   =   "Block Smartcards"
      TabPicture(1)   =   "Frm_Main.frx":001C
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "Cbo_Schools_3"
      Tab(1).Control(1)=   "Cbo_Reason"
      Tab(1).Control(2)=   "Cmd_Block"
      Tab(1).Control(3)=   "Txt_Charliecard_Block"
      Tab(1).Control(4)=   "Label10"
      Tab(1).Control(5)=   "Label5"
      Tab(1).Control(6)=   "Label4"
      Tab(1).ControlCount=   7
      TabCaption(2)   =   "School Lookup"
      TabPicture(2)   =   "Frm_Main.frx":0038
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "Txt_Output2"
      Tab(2).Control(1)=   "Cmd_Export"
      Tab(2).Control(2)=   "Cmd_List"
      Tab(2).Control(3)=   "Cbo_Schools_2"
      Tab(2).Control(4)=   "Grd_Cards"
      Tab(2).Control(5)=   "Label9"
      Tab(2).Control(6)=   "Label6"
      Tab(2).ControlCount=   7
      TabCaption(3)   =   "UnBlock Smartcards"
      TabPicture(3)   =   "Frm_Main.frx":0054
      Tab(3).ControlEnabled=   -1  'True
      Tab(3).Control(0)=   "Label11"
      Tab(3).Control(0).Enabled=   0   'False
      Tab(3).Control(1)=   "Label12"
      Tab(3).Control(1).Enabled=   0   'False
      Tab(3).Control(2)=   "Cbo_Schools_4"
      Tab(3).Control(2).Enabled=   0   'False
      Tab(3).Control(3)=   "Txt_UnblockCard"
      Tab(3).Control(3).Enabled=   0   'False
      Tab(3).Control(4)=   "Cmd_UnBlock"
      Tab(3).Control(4).Enabled=   0   'False
      Tab(3).ControlCount=   5
      TabCaption(4)   =   "Card lookup"
      TabPicture(4)   =   "Frm_Main.frx":0070
      Tab(4).ControlEnabled=   0   'False
      Tab(4).Control(0)=   "Label13"
      Tab(4).Control(1)=   "Label14"
      Tab(4).Control(2)=   "Txt_Cardlookup"
      Tab(4).Control(3)=   "Txt_School"
      Tab(4).Control(4)=   "Cmd_Lookup"
      Tab(4).ControlCount=   5
      Begin VB.ComboBox Cbo_Days 
         Height          =   315
         ItemData        =   "Frm_Main.frx":008C
         Left            =   -70200
         List            =   "Frm_Main.frx":0096
         TabIndex        =   40
         Top             =   840
         Width           =   1695
      End
      Begin VB.CommandButton Cmd_Lookup 
         Caption         =   "Lookup CharlieCard"
         Height          =   375
         Left            =   -70440
         TabIndex        =   39
         Top             =   840
         Width           =   1935
      End
      Begin VB.TextBox Txt_School 
         BackColor       =   &H00C0FFFF&
         Height          =   285
         Left            =   -72600
         Locked          =   -1  'True
         TabIndex        =   37
         Top             =   1560
         Width           =   3975
      End
      Begin VB.TextBox Txt_Cardlookup 
         Height          =   285
         Left            =   -72600
         TabIndex        =   36
         Top             =   960
         Width           =   1575
      End
      Begin VB.CommandButton Cmd_UnBlock 
         Caption         =   "UnBlock Card"
         Height          =   495
         Left            =   5520
         TabIndex        =   34
         Top             =   1680
         Width           =   1815
      End
      Begin VB.TextBox Txt_UnblockCard 
         Height          =   285
         Left            =   1920
         TabIndex        =   33
         Top             =   1560
         Width           =   1695
      End
      Begin VB.ComboBox Cbo_Schools_4 
         Height          =   315
         ItemData        =   "Frm_Main.frx":00A0
         Left            =   1920
         List            =   "Frm_Main.frx":00A2
         TabIndex        =   30
         Top             =   1080
         Width           =   5415
      End
      Begin VB.ComboBox Cbo_Schools_3 
         Height          =   315
         ItemData        =   "Frm_Main.frx":00A4
         Left            =   -72840
         List            =   "Frm_Main.frx":00A6
         TabIndex        =   29
         Top             =   1320
         Width           =   5415
      End
      Begin VB.TextBox Txt_Output2 
         Height          =   285
         Left            =   -72000
         TabIndex        =   26
         Text            =   "Text1"
         Top             =   5160
         Width           =   3735
      End
      Begin VB.CommandButton Cmd_Export 
         Caption         =   "Export List"
         Height          =   375
         Left            =   -70080
         TabIndex        =   25
         Top             =   1200
         Width           =   1575
      End
      Begin VB.TextBox Txt_SC2 
         BackColor       =   &H00C0FFFF&
         Height          =   285
         Left            =   -72240
         Locked          =   -1  'True
         TabIndex        =   22
         Top             =   3000
         Width           =   1575
      End
      Begin VB.TextBox Txt_S1 
         BackColor       =   &H00C0FFFF&
         Height          =   285
         Left            =   -70320
         Locked          =   -1  'True
         TabIndex        =   21
         Top             =   2520
         Width           =   1575
      End
      Begin VB.TextBox Txt_S2 
         BackColor       =   &H00C0FFFF&
         Height          =   285
         Left            =   -70320
         Locked          =   -1  'True
         TabIndex        =   20
         Top             =   3000
         Width           =   1575
      End
      Begin VB.TextBox Txt_SC1 
         BackColor       =   &H00C0FFFF&
         Height          =   285
         Left            =   -72240
         Locked          =   -1  'True
         TabIndex        =   19
         Top             =   2520
         Width           =   1575
      End
      Begin VB.CommandButton Cmd_List 
         Caption         =   "List"
         Height          =   375
         Left            =   -68280
         TabIndex        =   16
         Top             =   1200
         Width           =   1575
      End
      Begin VB.ComboBox Cbo_Schools_2 
         Height          =   315
         ItemData        =   "Frm_Main.frx":00A8
         Left            =   -73080
         List            =   "Frm_Main.frx":00AA
         TabIndex        =   14
         Top             =   720
         Width           =   5415
      End
      Begin MSFlexGridLib.MSFlexGrid Grd_Cards 
         Height          =   3255
         Left            =   -74880
         TabIndex        =   13
         Top             =   1800
         Width           =   8655
         _ExtentX        =   15266
         _ExtentY        =   5741
         _Version        =   393216
      End
      Begin VB.ComboBox Cbo_Reason 
         Height          =   315
         ItemData        =   "Frm_Main.frx":00AC
         Left            =   -72840
         List            =   "Frm_Main.frx":00C4
         TabIndex        =   11
         Top             =   1800
         Width           =   2415
      End
      Begin VB.CommandButton Cmd_Block 
         Caption         =   "Block Card"
         Height          =   375
         Left            =   -69600
         TabIndex        =   10
         Top             =   1800
         Width           =   1695
      End
      Begin VB.TextBox Txt_Charliecard_Block 
         Height          =   285
         Left            =   -72840
         TabIndex        =   9
         Top             =   840
         Width           =   2415
      End
      Begin VB.TextBox Txt_Output 
         BackColor       =   &H00C0FFFF&
         Height          =   285
         Left            =   -72240
         Locked          =   -1  'True
         TabIndex        =   6
         Top             =   3600
         Width           =   4215
      End
      Begin VB.CommandButton Cmd_AssignCards 
         Caption         =   "Assign Cards"
         Height          =   615
         Left            =   -67680
         TabIndex        =   5
         Top             =   1920
         Width           =   1335
      End
      Begin VB.ComboBox Cbo_Schools 
         Height          =   315
         ItemData        =   "Frm_Main.frx":0116
         Left            =   -72720
         List            =   "Frm_Main.frx":0118
         TabIndex        =   3
         Top             =   1320
         Width           =   5415
      End
      Begin VB.TextBox Txt_NumberCharliecards 
         Height          =   285
         Left            =   -72720
         TabIndex        =   1
         Top             =   840
         Width           =   1095
      End
      Begin VB.Label Label15 
         Caption         =   "Days Valid"
         Height          =   255
         Left            =   -71280
         TabIndex        =   41
         Top             =   840
         Width           =   975
      End
      Begin VB.Label Label14 
         Caption         =   "School Assigned to"
         Height          =   255
         Left            =   -74640
         TabIndex        =   38
         Top             =   1560
         Width           =   1575
      End
      Begin VB.Label Label13 
         Caption         =   "CharlieCard #"
         Height          =   255
         Left            =   -74640
         TabIndex        =   35
         Top             =   960
         Width           =   1215
      End
      Begin VB.Label Label12 
         Caption         =   "CharlieCard #"
         Height          =   255
         Left            =   480
         TabIndex        =   32
         Top             =   1575
         Width           =   1095
      End
      Begin VB.Label Label11 
         Caption         =   "School Sent To"
         Height          =   255
         Left            =   360
         TabIndex        =   31
         Top             =   1080
         Width           =   1455
      End
      Begin VB.Label Label10 
         Caption         =   "School Sent To"
         Height          =   255
         Left            =   -74400
         TabIndex        =   28
         Top             =   1320
         Width           =   1215
      End
      Begin VB.Label Label9 
         Caption         =   "Export File location/Name"
         Height          =   255
         Left            =   -74160
         TabIndex        =   27
         Top             =   5160
         Width           =   2055
      End
      Begin VB.Label Label8 
         Caption         =   "Last Serial && Sequence Number"
         Height          =   255
         Left            =   -74880
         TabIndex        =   18
         Top             =   3000
         Width           =   2295
      End
      Begin VB.Label Label7 
         Caption         =   "First Serial && Sequence Number"
         Height          =   255
         Left            =   -74880
         TabIndex        =   17
         Top             =   2520
         Width           =   2295
      End
      Begin VB.Label Label6 
         Caption         =   "School To List"
         Height          =   255
         Left            =   -74520
         TabIndex        =   15
         Top             =   720
         Width           =   1335
      End
      Begin VB.Label Label5 
         Caption         =   "Reason For Block"
         Height          =   255
         Left            =   -74490
         TabIndex        =   12
         Top             =   1800
         Width           =   1335
      End
      Begin VB.Label Label4 
         Caption         =   "CharlieCard to Block"
         Height          =   255
         Left            =   -74640
         TabIndex        =   8
         Top             =   840
         Width           =   1455
      End
      Begin VB.Label Label3 
         Caption         =   "School File Name"
         Height          =   255
         Left            =   -73920
         TabIndex        =   7
         Top             =   3600
         Width           =   1335
      End
      Begin VB.Label Label2 
         Caption         =   "School To Send To"
         Height          =   255
         Left            =   -74400
         TabIndex        =   4
         Top             =   1320
         Width           =   1455
      End
      Begin VB.Label Label1 
         Caption         =   "Number of CharlieCards"
         Height          =   255
         Left            =   -74640
         TabIndex        =   2
         Top             =   840
         Width           =   1695
      End
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
   Begin VB.Label Lbl_Comp 
      Height          =   255
      Left            =   6600
      TabIndex        =   24
      Top             =   480
      Width           =   2175
   End
   Begin VB.Label Lbl_User 
      Height          =   255
      Left            =   6600
      TabIndex        =   23
      Top             =   120
      Width           =   2055
   End
   Begin VB.Menu menu 
      Caption         =   "SmartCard Functions"
      Begin VB.Menu Import 
         Caption         =   "Import Production cards"
      End
      Begin VB.Menu BatchHotlist 
         Caption         =   "Batch Hotlist BPS"
      End
      Begin VB.Menu Batchhotpriv 
         Caption         =   "Batch Hotlist private"
      End
      Begin VB.Menu LoadBPS 
         Caption         =   "Load BPS Assigned Cards"
      End
      Begin VB.Menu CalcMonthlyUsage 
         Caption         =   "Calculate Monthly Usage"
      End
   End
   Begin VB.Menu Reports 
      Caption         =   "Reports"
      Begin VB.Menu CharterSchoolUsage 
         Caption         =   "Charter School Usage"
      End
      Begin VB.Menu BPSUsage 
         Caption         =   "BPS Usage"
      End
      Begin VB.Menu hotlistexport 
         Caption         =   "T-Police Hotlist Export"
      End
   End
   Begin VB.Menu CorpCardCheck 
      Caption         =   "Corporate Card Check"
      Begin VB.Menu CheckCardUsage 
         Caption         =   "Check Card Usage"
      End
      Begin VB.Menu Expcheck 
         Caption         =   "Check Expiration"
      End
   End
   Begin VB.Menu Freepass 
      Caption         =   "Free Pass Usage"
      Begin VB.Menu get_usage 
         Caption         =   "Calculate usage"
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
Dim charliecard As String
Dim accountname As String
Dim Last_Sequence As Long
Dim Card_Count As Long
Dim School_Enddate As Date
Dim Month As Long
Dim Year As Long
Dim i As Long
Dim OutPut_File
Dim Paths As String
Dim period1 As String
Dim period2 As String
Dim period3 As String
Dim period4 As String
Dim period5 As String
Dim period6 As String
Dim period7 As String
Dim period8 As String
Dim period9 As String
Dim period10 As String
Dim period11 As String
Dim period12 As String
Dim period13 As String
Dim period14 As String
Dim dperiod1 As Long
Dim dperiod2 As Long
Dim dperiod3 As Long
Dim dperiod4 As Long
Dim dperiod5 As Long
Dim dperiod6 As Long
Dim dperiod7 As Long
Dim dperiod8 As Long
Dim dperiod9 As Long
Dim dperiod10 As Long
Dim dperiod11 As Long
Dim dperiod12 As Long
Dim dperiod13 As Long
Dim dperiod14 As Long




Private Sub BatchHotlist_Click()
Dim BPSReason As String
Dim MBTAReason As Long
    Cmn_Dialog2.ShowOpen
    Filename = Trim(Cmn_Dialog2.Filename)
    If Filename = "" Then Exit Sub

    Set FSO = New FileSystemObject
    Set fileMhs = FSO.GetFile(Filename)
    Set txtsMhs = fileMhs.OpenAsTextStream(ForReading)
    Data = txtsMhs.ReadLine
    Do While Not txtsMhs.AtEndOfStream
    
        Data = txtsMhs.ReadLine
        dataMhs = Split(Data, ",")
        Sequence = CLng(dataMhs(0))
        charliecard = dataMhs(1)
        BPSReason = dataMhs(2)
        Select Case BPSReason
        Case "W", "N", "I"
            MBTAReason = 34
        Case "R", "T"
            MBTAReason = 32
        Case "L", "S", "D"
            MBTAReason = 31
        Case "X", "M", "Y"
            MBTAReason = 35
        End Select
        
        sSql = "update schoolcards set blockdate = to_date('" & Format(Now, "mm/dd/yyyy hh:mm:ss") & "','mm/dd/yyyy-HH24:MI:SS'), typeblock = " & _
        MBTAReason & " where charliecard = " & charliecard
        
        ORAdata.Execute (sSql)

' Insert into S&B Hotlist

        sSql = "INSERT INTO hotlist(mediatype, serialnumber,xvalidfrom, serialnumberub, sreason, " & _
        "xvaliduntil, status, usernew, timenew, userchange, timechange) " & _
        "VALUES(5," & charliecard & ", To_Date('" & Format(Now, "mm/dd/yyyy") & "','mm/dd/yyyy'), " & _
        charliecard & "," & MBTAReason & _
        ",To_Date('" & Format(School_Enddate, "mm/dd/yyyy") & "','mm/dd/yyyy'), 1," & _
        "'HOTLIST',to_date('" & Format(Now, "mm/dd/yyyy hh:mm:ss") & "','mm/dd/yyyy-HH24:MI:SS'), " & _
        "'HOTLIST',to_date('" & Format(Now, "mm/dd/yyyy hh:mm:ss") & "','mm/dd/yyyy-HH24:MI:SS'))"
        ORAdata.Execute (sSql)
    Loop
    

End Sub



Private Sub Batchhotpriv_Click()
Dim BPSReason As String
Dim MBTAReason As Long
    Cmn_Dialog2.ShowOpen
    Filename = Trim(Cmn_Dialog2.Filename)
    If Filename = "" Then Exit Sub

    Set FSO = New FileSystemObject
    Set fileMhs = FSO.GetFile(Filename)
    Set txtsMhs = fileMhs.OpenAsTextStream(ForReading)
    Data = txtsMhs.ReadLine
    
        Set RsWork = New ADODB.Recordset
    Do While Not txtsMhs.AtEndOfStream
    
        Data = txtsMhs.ReadLine
        dataMhs = Split(Data, ",")
        'Sequence = CLng(dataMhs(0))
        charliecard = dataMhs(0)
        'BPSReason = dataMhs(2)
  
        MBTAReason = 31
        sSql = "select * from schoolcards where charliecard = " & charliecard
        Set RsWork = ORAdata.Execute(sSql)
        If RsWork.EOF = True Then GoTo loopit
        
        If IsNull(RsWork("typeblock")) = True Then
        
            
        
        sSql = "update schoolcards set typeblock = 31, blockdate = to_date('" & Format(Now, "mm/dd/yyyy hh:mm:ss") & "','mm/dd/yyyy-HH24:MI:SS') where charliecard = " & charliecard
        
        ORAdata.Execute (sSql)

' Insert into S&B Hotlist

        sSql = "INSERT INTO hotlist(mediatype, serialnumber,xvalidfrom, serialnumberub, sreason, " & _
        "xvaliduntil, status, usernew, timenew, userchange, timechange) " & _
        "VALUES(5," & charliecard & ", To_Date('" & Format(Now, "mm/dd/yyyy") & "','mm/dd/yyyy'), " & _
        charliecard & "," & MBTAReason & _
        ",To_Date('" & Format(School_Enddate, "mm/dd/yyyy") & "','mm/dd/yyyy'), 1," & _
        "'HOTLIST',to_date('" & Format(Now, "mm/dd/yyyy hh:mm:ss") & "','mm/dd/yyyy-HH24:MI:SS'), " & _
        "'HOTLIST',to_date('" & Format(Now, "mm/dd/yyyy hh:mm:ss") & "','mm/dd/yyyy-HH24:MI:SS'))"
        On Error GoTo loopit
        ORAdata.Execute (sSql)
        End If
loopit:
    Loop
    
End Sub

Private Sub CalcMonthlyUsage_Click()
Dim BegDate As String
Dim EndDate As String
Dim charliecard As String
Dim taps As Long

    EndDate = Format(Date, "yyyy-mm")
    BegDate = Format(DateAdd("m", -1, EndDate), "yyyy-mm")
    
    Debug.Print sSql
    
    sSql = "select sd.ticketserialno, Count(sd.uniquemsid) AS usage from salesdetail sd, schoolcards sc " & _
    " Where sd.ticketserialno = sc.charliecard AND sc.typeblock IS NULL AND sd.deviceclassid IN (411,441,501,801) " & _
    "AND sd.creadate >= To_Date('" & BegDate & "-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND sd.creadate < To_Date('" & EndDate & "-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND sd.partitioningdate >= To_Date('" & BegDate & "-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND sd.partitioningdate < To_Date('" & EndDate & "-04-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "GROUP BY sd.ticketserialno "
    Debug.Print sSql
    
    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAdata.Execute(sSql)
    
     
     
    
    Do While RsWork.EOF = False
    
        charliecard = RsWork("ticketserialno")
        taps = RsWork("usage")
        sSql = "update schoolcards set monthlyusage = " & taps & " where charliecard = '" & charliecard & "'"
        
        ORAdata.Execute (sSql)
        RsWork.MoveNext
    Loop

    RsWork.Close
    Set RsWork = Nothing
    
End Sub

Private Sub CheckCardUsage_Click()
    Dim compstatus As String
    'GoTo Skip_Load
    Cmn_Dailog3.ShowOpen
    Filename = Trim(Cmn_Dailog3.Filename)
    If Filename = "" Then Exit Sub
    sSql = "delete from corpcards2"
    ORAdata.Execute (sSql)

    Set FSO = New FileSystemObject
    Set fileMhs = FSO.GetFile(Filename)
    Set txtsMhs = fileMhs.OpenAsTextStream(ForReading)
        Data = txtsMhs.ReadLine
    Do While Not txtsMhs.AtEndOfStream
    
        Data = txtsMhs.ReadLine
        dataMhs = Split(Data, ",")
        charliecard = dataMhs(0)
        accountname = dataMhs(1)
        compstatus = 1 'dataMhs(2)
        sSql = "insert into corpcards2 (charliecard,accountname, status) values(" & charliecard & ",'" & Replace(accountname, "'", "''") & "','" & compstatus & "')"
        Debug.Print sSql
        
        ORAdata.Execute (sSql)
    Loop
    
Skip_Load:
    sSql = "SELECT DISTINCT serialnumber, movementtype, To_char(TIMESTAMP,'yyyy/mm') AS period FROM corpcards2 " & _
    "left outer join misccardmovement ON serialnumber = charliecard WHERE mediatype = 5 AND movementtype = 15 order by serialnumber asc, to_char(timestamp,'yyyy/mm') desc;"
    Debug.Print sSql
    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAdata.Execute(sSql)
    
    Do While RsWork.EOF = False
        If charliecard <> RsWork("serialnumber") Then
        
            If charliecard <> "" Then Call UpdateCorp
        End If
        
        charliecard = RsWork("serialnumber")

        i = i + 1
        Select Case i
        Case 1
            period1 = RsWork("period")
        Case 2
            period2 = RsWork("period")
        Case 3
            period3 = RsWork("period")
        Case 4
            period4 = RsWork("period")
        Case 5
            period5 = RsWork("period")
        Case 6
            period6 = RsWork("period")
        Case 7
            period7 = RsWork("period")
        Case 8
            period8 = RsWork("period")
        Case 9
            period9 = RsWork("period")
        Case 10
            period10 = RsWork("period")
        Case 11
            period11 = RsWork("period")
        Case 12
            period12 = RsWork("period")
        Case 13
            period13 = RsWork("period")
        Case 14
            period14 = RsWork("period")
        End Select
    
        RsWork.MoveNext
    Loop
End Sub


Public Sub UpdateCorp()
    i = 0
    sSql = "update corpcards2 set period1 = '" & period1 & "', period2 = '" & period2 & "', period3 = '" & period3 & "', period4 = '" & period4 & _
    "', period5 = '" & period5 & "', period6 = '" & period6 & "', period7 = '" & period7 & "', period8 = '" & period8 & _
    "', period9 = '" & period9 & "', period10 = '" & period10 & "', period11 = '" & period11 & "', period12 = '" & period12 & _
    "', period13 = '" & period13 & "', period14 = '" & period14 & "' where charliecard = " & charliecard
    
    Debug.Print sSql
    
    ORAdata.Execute (sSql)
    period1 = ""
    period2 = ""
    period3 = ""
    period4 = ""
    period5 = ""
    period6 = ""
    period7 = ""
    period8 = ""
    period9 = ""
    period10 = ""
    period11 = ""
    period12 = ""
    period13 = ""
    period14 = ""
    
End Sub

Private Sub Cmd_AssignCards_Click()

    If Cbo_Schools.ListIndex = -1 Then
        MsgBox ("You must select a school to assign these CharlieCards to."), vbOKOnly
        Exit Sub
    End If

    SchoolIDX = CLng(Cbo_Schools.ItemData(Cbo_Schools.ListIndex))

    Card_Count = CLng(Txt_NumberCharliecards.Text)
    If Card_Count <= 0 Then
        MsgBox ("You must select enter a qty of CharlieCards to assigh to the school"), vbOKOnly
        Exit Sub
    End If
    If Cbo_Days.ListIndex = -1 Then
        MsgBox ("You must select the number of days the card is valid for."), vbOKOnly
        Exit Sub
    End If
    sSql = "select min(sequence) as lastSequence from schoolcards where assigned is null and daysvalid = " & Cbo_Days.ItemData(Cbo_Days.ListIndex) & " order by sequence"
    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAdata.Execute(sSql)
    Last_Sequence = RsWork("lastsequence")
    RsWork.Close
    Set RsWork = Nothing
    
    sSql = "update schoolcards set schoolIDX = " & SchoolIDX & ", assigned =  to_date('" & Date & "','mm/dd/yyyy') where sequence >= " & Last_Sequence & _
    " and sequence <= " & (Last_Sequence + Card_Count - 1)
        Debug.Print sSql

    ORAdata.Execute (sSql)
    
    sSql = "select sequence, charliecard from schoolcards where sequence in (" & Last_Sequence & _
    "," & (Last_Sequence + Card_Count - 1) & ") order by sequence"
    
    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAdata.Execute(sSql)
    
    Do While RsWork.EOF = False
        Txt_SC1 = RsWork("Charliecard")
        Txt_S1 = RsWork("Sequence")
        
        RsWork.MoveNext
        Txt_SC2 = RsWork("Charliecard")
        Txt_S2 = RsWork("Sequence")
        
        RsWork.MoveNext
    Loop
    
    Call Export_Cards
End Sub

Public Sub Export_Cards()
    'SchoolIDX = 15
    OutPut_File = Environ("USERPROFILE") & "\My Documents\"
    
    sSql = "select * from schools where schoolidx = " & SchoolIDX
    Debug.Print sSql
    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAdata.Execute(sSql)
    Paths = Trim(RsWork("Schoolid")) & "-" & Format(Date, "mm-dd-yyyy") & ".csv"
    OutPut_File = OutPut_File & Paths
        
    sSql = "select * from schoolcards where schoolIDX = " & SchoolIDX & " order by sequence"
    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAdata.Execute(sSql)
    
    Open OutPut_File For Output As #1
        Print #1, "Sequence #,CharlieCard #,Date Assigned,Date Blocked"
    Do While RsWork.EOF = False
        Print #1, RsWork("sequence") & "," & RsWork("CharlieCard") & "," & RsWork("Assigned") & "," & RsWork("blockdate")
        RsWork.MoveNext
    Loop

Close #1

    If ExpOption = 0 Then
        Txt_Output.Text = "My Documents\" & Paths
    Else
        Txt_Output2.Text = "My Documents\" & Paths
    End If
    Txt_NumberCharliecards.Text = ""
    Cbo_Days.ListIndex = -1
    Cbo_Schools.ListIndex = -1
    
End Sub

Private Sub Cmd_Block_Click()
    If Txt_Charliecard_Block.Text = "" Then
        MsgBox ("You must enter a valid CharlieCard to block"), vbOKOnly
        Exit Sub
    End If
    
    If Cbo_Reason.ListIndex = -1 Then
        MsgBox ("You must select a reason for blocking this CharlieCard"), vbOKOnly
        Exit Sub
    End If
    
    sSql = "select * from schoolcards sc, schools s where sc.charliecard = " & Trim(Txt_Charliecard_Block.Text) & "AND s.schoolidx = sc.schoolidx"
    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAdata.Execute(sSql)
    
    If RsWork.EOF = True Then
        MsgBox ("The CharlieCard enter is not in this system.  Please check the card and try again"), vbOKOnly
        Txt_Charliecard_Block.Text = ""
        Cbo_Reason.ListIndex = -1
        Txt_Charliecard_Block.SetFocus
        RsWork.Close
        Set RsWork = Nothing
        Exit Sub
    End If
    
    If RsWork("typeblock") > 1 Then
        MsgBox ("This card has already been blocked, please try again."), vbOKOnly
        Txt_Charliecard_Block.Text = ""
        Cbo_Reason.ListIndex = -1
        Txt_Charliecard_Block.SetFocus
        RsWork.Close
        Set RsWork = Nothing
        Exit Sub
    End If
    
    If MsgBox("Are you sure you want to block the Charliecard # " & Trim(Txt_Charliecard_Block.Text) & " from the " & RsWork("schoolname"), vbYesNo) = vbYes Then

'check card school relationship
    
    sSql = "select * from schoolcards where charliecard = " & Trim(Txt_Charliecard_Block.Text) & " and schoolidx = " & CLng(Cbo_Schools_3.ItemData(Cbo_Schools_3.ListIndex))
    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAdata.Execute(sSql)
    If RsWork.EOF = True Then
        MsgBox (" This card does not belong to this school, please try again."), vbExclamation + vbOKOnly
        
        Exit Sub
    End If
'Update School table showing block




        sSql = "update schoolcards set blockdate = to_date('" & Format(Now, "mm/dd/yyyy hh:mm:ss") & "','mm/dd/yyyy-HH24:MI:SS'), typeblock = " & _
        Cbo_Reason.ItemData(Cbo_Reason.ListIndex) & " where charliecard = " & Trim(Txt_Charliecard_Block.Text)
        
        ORAdata.Execute (sSql)


' Insert into S&B Hotlist

        sSql = "INSERT INTO hotlist(mediatype, serialnumber,xvalidfrom, serialnumberub, sreason, " & _
        "xvaliduntil, status, usernew, timenew, userchange, timechange) " & _
        "VALUES(5," & Trim(Txt_Charliecard_Block.Text) & ", To_Date('" & Format(Now, "mm/dd/yyyy") & "','mm/dd/yyyy'), " & _
        Trim(Txt_Charliecard_Block.Text) & "," & Cbo_Reason.ItemData(Cbo_Reason.ListIndex) & _
        ",To_Date('" & Format(School_Enddate, "mm/dd/yyyy") & "','mm/dd/yyyy'), 1," & _
        "'HOTLIST',to_date('" & Format(Now, "mm/dd/yyyy hh:mm:ss") & "','mm/dd/yyyy-HH24:MI:SS'), " & _
        "'HOTLIST',to_date('" & Format(Now, "mm/dd/yyyy hh:mm:ss") & "','mm/dd/yyyy-HH24:MI:SS'))"
        ORAdata.Execute (sSql)
        
    End If
    RsWork.Close
    Set RsWork = Nothing
    
End Sub

Private Sub Cmd_Export_Click()
    Grd_Cards_Init
    ExpOption = 1
    SchoolIDX = Cbo_Schools_2.ItemData(Cbo_Schools_2.ListIndex)
    Call Export_Cards
    ExpOption = 0
End Sub

Private Sub Cmd_List_Click()
    Call Grd_Cards_Init
    sSql = "select * from schoolcards left outer join carddenialreasons ON typeblock = reason " & _
    "where schoolIDX = " & CLng(Cbo_Schools_2.ItemData(Cbo_Schools_2.ListIndex)) & " order by sequence "

    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAdata.Execute(sSql)
    
    If RsWork.EOF = False Then Cmd_Export.Visible = True

    Do While RsWork.EOF = False
        sline = RsWork("Sequence") & vbTab & _
        RsWork("Charliecard") & vbTab & _
        RsWork("Assigned") & vbTab & _
        Format(RsWork("Blockdate"), "mm/dd/yyyy hh:mm") & vbTab & _
        RsWork("reasondesc")
        
        Grd_Cards.AddItem sline
        RsWork.MoveNext
    Loop

End Sub

Private Sub Cmd_Lookup_Click()
    Txt_School.Text = ""
    If Txt_Cardlookup.Text = "" Then
        MsgBox ("A CharlieCard must be entered"), vbOKOnly
        Exit Sub
    End If
    
    sSql = "select schoolname from schools s, schoolcards sc WHERE s.schoolidx = sc.schoolidx AND sc.charliecard =" & Trim(Txt_Cardlookup.Text)
    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAdata.Execute(sSql)
    If RsWork.EOF = True Then
        MsgBox ("This CharlieCard is not found in the school list.  Please retype and try again"), vbOKOnly
        Exit Sub
    End If
    Txt_School.Text = RsWork("schoolname")
    RsWork.Close
    Set RsWork = Nothing
    
End Sub

Private Sub Cmd_UnBlock_Click()
    If Txt_UnblockCard.Text = "" Then
        MsgBox ("You must enter a valid CharlieCard to unblock"), vbOKOnly
        Exit Sub
    End If
    
    
    sSql = "select * from schoolcards sc, schools s where sc.charliecard = " & Trim(Txt_UnblockCard.Text)
    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAdata.Execute(sSql)
    
    If RsWork.EOF = True Then
        MsgBox ("The CharlieCard enter is not in this system.  Please check the card and try again"), vbOKOnly
        Txt_Charliecard_Block.Text = ""
        Cbo_Reason.ListIndex = -1
        Txt_Charliecard_Block.SetFocus
        RsWork.Close
        Set RsWork = Nothing
        Exit Sub
    End If
    
    
    If MsgBox("Are you sure you want to unblock the Charliecard # " & Trim(Txt_UnblockCard.Text) & " from the " & RsWork("schoolname"), vbYesNo) = vbYes Then

'check card school relationship

        sSql = "update schoolcards set blockdate = '', typeblock = ''" & _
        " where charliecard = " & Trim(Txt_UnblockCard.Text)
        
        ORAdata.Execute (sSql)

' Remove from S&B Hotlist
        sSql = "delete from hotlist where serialnumber = " & Trim(Txt_UnblockCard.Text)
                   ORAdata.Execute (sSql)

    End If
    RsWork.Close
    Set RsWork = Nothing
End Sub

Private Sub Expcheck_Click()
Dim cardstatus As String

    Cmn_Dailog3.ShowOpen

    Filename = Trim(Cmn_Dailog3.Filename)
    If Filename = "" Then Exit Sub
    sSql = "delete from corpexpiration"
    ORAdata.Execute (sSql)

    Set FSO = New FileSystemObject
    Set fileMhs = FSO.GetFile(Filename)
    Set txtsMhs = fileMhs.OpenAsTextStream(ForReading)
        Data = txtsMhs.ReadLine
    Do While Not txtsMhs.AtEndOfStream
    
        Data = txtsMhs.ReadLine
        dataMhs = Split(Data, ",")
        charliecard = dataMhs(0)
        accountname = dataMhs(1)
        cardstatus = dataMhs(2)
        sSql = "insert into corpexpiration (charliecard,companyname, cardstatus) values(" & charliecard & ",'" & Replace(accountname, "'", "''") & "','" & cardstatus & "')"
        Debug.Print sSql
        
        ORAdata.Execute (sSql)
    Loop
    
Skip_Load:
    sSql = "SELECT serialnumber, to_char(cardvaliduntil,'yyyy/mm/dd')as expdate from corpexpiration " & _
    "left outer join card ON serialnumber = charliecard "
    Debug.Print sSql
    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAdata.Execute(sSql)
    
    Do While RsWork.EOF = False
        sSql = "Update corpexpiration set expdate = '" & RsWork("expdate") & "' where charliecard = '" & RsWork("charliecard") & "'"
        ORAdata.Execute (sSql)
    
        RsWork.MoveNext
    Loop

End Sub

Private Sub Form_Load()
    Lbl_User = "User: " & User_Name
    Lbl_Comp = "Workstation: " & Comp_Name
    
    Exit Sub
    
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
    
    
    
    
    SSTab1.Tab = 0
    
    sSql = "select * from schools order by schoolname"
    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAdata.Execute(sSql)
    Do While RsWork.EOF = False
        Data = ""
        Data = RsWork("Schoolid") & "    " & RsWork("SchoolName")
        Cbo_Schools.AddItem (Data)
        Cbo_Schools.ItemData(Cbo_Schools.NewIndex) = RsWork("Schoolidx")
        Cbo_Schools_2.AddItem (Data)
        Cbo_Schools_2.ItemData(Cbo_Schools_2.NewIndex) = RsWork("Schoolidx")
        Cbo_Schools_3.AddItem (Data)
        Cbo_Schools_3.ItemData(Cbo_Schools_3.NewIndex) = RsWork("Schoolidx")
        Cbo_Schools_4.AddItem (Data)
        Cbo_Schools_4.ItemData(Cbo_Schools_4.NewIndex) = RsWork("Schoolidx")
        RsWork.MoveNext
    Loop
    RsWork.Close
    Set RsWork = Nothing
    
    
    Month = Mid(Format(Now, "mm/dd/yyyy"), 1, 2)
    Year = Mid(Format(Now, "mm/dd/yyyy"), 7, 4)
    
    Select Case Month
    Case 7 To 12
        Year = Year + 1
    Case 1 To 6
        Year = Year
    End Select
    
    School_Enddate = "07/01/" & Year
    
End Sub

Private Sub get_usage_Click()

    Set RsWork = New ADODB.Recordset
    Set RsWork2 = New ADODB.Recordset
    sSql = "select * from freepasses"
    Set RsWork = ORAdata.Execute(sSql)
    
    Do While RsWork.EOF = False
    If RsWork("serialnumber") = 0 Then GoTo Skip_This
        sSql = "SELECT ticketserialno, To_Char(creadate,'yyyy/mm') as thedate , Count(ticketserialno) as taps FROM salesdetail " & _
        "WHERE ticketserialno  = " & RsWork("serialnumber") & "GROUP BY ticketserialno, To_Char(creadate,'yyyy/mm')" & _
        " ORDER BY ticketserialno, To_Char(creadate,'yyyy/mm')"
        Set RsWork2 = ORAdata.Execute(sSql)
        
        Do While RsWork2.EOF = False
        
        Select Case RsWork2("TheDate")
        Case "2010/04"
            dperiod1 = RsWork2("taps")
        Case "2010/03"
            dperiod2 = RsWork2("taps")
        Case "2010/02"
            dperiod3 = RsWork2("taps")
        Case "2010/01"
            dperiod4 = RsWork2("taps")
        Case "2009/12"
            dperiod5 = RsWork2("taps")
        Case "2009/11"
            dperiod6 = RsWork2("taps")
        Case "2009/10"
            dperiod7 = RsWork2("taps")
        Case "2009/09"
            dperiod8 = RsWork2("taps")
        Case "2009/08"
            dperiod9 = RsWork2("taps")
        Case "2009/07"
            dperiod10 = RsWork2("taps")
        Case "2009/06"
            dperiod11 = RsWork2("taps")
        Case "2009/05"
            dperiod12 = RsWork2("taps")
        Case "2009/04"
            dperiod13 = RsWork2("taps")
        Case "2009/03"
            dperiod14 = RsWork2("taps")
        End Select
    
        RsWork2.MoveNext
        Loop
        Call Update_Free_Pass
Skip_This:
        RsWork.MoveNext
    Loop
End Sub

Public Sub Update_Free_Pass()

    sSql = "update freepasses set period1 = " & dperiod1 & ", period2 = " & dperiod2 & ", period3 = " & dperiod3 & ", period4 = " & dperiod4 & _
    ", period5 = " & dperiod5 & ", period6 = " & dperiod6 & ", period7 = " & dperiod7 & ", period8 = " & dperiod8 & _
    ", period9 = " & dperiod9 & ", period10 = " & dperiod10 & ", period11 = " & dperiod11 & ", period12 = " & dperiod12 & _
    ", period13 = " & dperiod13 & ", period14 = " & dperiod14 & " where serialnumber = " & RsWork("serialnumber")
    
    Debug.Print sSql
    
    ORAdata.Execute (sSql)
    dperiod1 = 0
    dperiod2 = 0
    dperiod3 = 0
    dperiod4 = 0
    dperiod5 = 0
    dperiod6 = 0
    dperiod7 = 0
    dperiod8 = 0
    dperiod9 = 0
    dperiod10 = 0
    dperiod11 = 0
    dperiod12 = 0
    dperiod13 = 0
    dperiod14 = 0
    
End Sub

Private Sub hotlistexport_Click()

    OutPut_File = Environ("USERPROFILE") & "\My Documents\"

    sSql = "SELECT sc.charliecard, s.schoolname,To_Char(sc.blockdate,'mm/dd/yyyy') AS blockeddate, c.reasondesc " & _
    "FROM schoolcards sc left outer join schools s ON s.schoolidx = sc.schoolidx " & _
    "left outer join carddenialreasons c ON c.reason = sc.typeblock " & _
    "WHERE sc.blockdate IS NOT NULL ORDER BY charliecard"
    
    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAdata.Execute(sSql)
    
    
    Paths = "PoliceHotlist.csv"
    OutPut_File = OutPut_File & Paths
     
    Open OutPut_File For Output As #1
        Print #1, "CharlieCard #,School,Block Date,Reason Blocked"
    Do While RsWork.EOF = False
        Print #1, RsWork("CharlieCard") & "," & RsWork("schoolname") & "," & RsWork("blockeddate") & "," & RsWork("reasondesc")
        RsWork.MoveNext
    Loop

Close #1

    MsgBox ("Export is complete"), vbOKOnly

End Sub

Private Sub LoadBPS_Click()
    sSql = "Update schoolcards set assignedto = null, monthlyusage = null"
    ORAdata.Execute (sSql)
    
    Cmn_Dailog4.ShowOpen
    Filename = Trim(Cmn_Dailog4.Filename)
    If Filename = "" Then Exit Sub

    Set FSO = New FileSystemObject
    Set fileMhs = FSO.GetFile(Filename)
    Set txtsMhs = fileMhs.OpenAsTextStream(ForReading)

    Data = txtsMhs.ReadLine
    Do While Not txtsMhs.AtEndOfStream
    
        Data = txtsMhs.ReadLine
        dataMhs = Split(Data, ",")
        Sequence = CLng(dataMhs(0))
        charliecard = dataMhs(1)
        
        sSql = "update schoolcards set assignedto = 'Y' where charliecard = '" & charliecard & "'"
        
        ORAdata.Execute (sSql)
    Loop

End Sub

Private Sub SSTab1_Click(PreviousTab As Integer)
Dim contrl As Variant

    For Each contrl In Frm_Main.Controls
    If (TypeOf contrl Is TextBox) Then contrl.Text = ""
    Next contrl

    For Each contrl In Frm_Main.Controls
    If (TypeOf contrl Is ComboBox) Then contrl.Text = ""
    Next contrl
    
    For Each contrl In Frm_Main.Controls
    If (TypeOf contrl Is CheckBox) Then contrl.Value = 0
    Next contrl


    Select Case SSTab1.Tab
    Case 0 'HOME
        
    Case 1  ' Part/Assembly Lookup
        
    Case 2
        Grd_Cards_Init
        Cmd_Export.Visible = False
        
    End Select
    
End Sub
Private Sub Import_Click()

    cmdialog1.ShowOpen
    Filename = Trim(cmdialog1.Filename)
    If Filename = "" Then Exit Sub

    Set FSO = New FileSystemObject
    Set fileMhs = FSO.GetFile(Filename)
    Set txtsMhs = fileMhs.OpenAsTextStream(ForReading)

    Do While Not txtsMhs.AtEndOfStream
' Privat School Import
        Data = txtsMhs.ReadLine
        dataMhs = Split(Data, ",")
        Sequence = CLng(dataMhs(2))
        charliecard = dataMhs(3)
        sSql = "insert into schoolcards( sequence, charliecard, daysvalid) values (" & _
        Sequence & ",'" & charliecard & "',5)"
        Debug.Print sSql
        ORAdata.Execute (sSql)
    Loop
    
    Exit Sub

' BPS Import
        Data = txtsMhs.ReadLine
        dataMhs = Split(Data, ",")
        Sequence = CLng(dataMhs(2))
        charliecard = dataMhs(3)
        sSql = "insert into schoolcards( sequence, charliecard, schoolidx,assigned, daysvalid) values (" & _
        Sequence & ",'" & charliecard & "',15,to_date('10/19/2009','mm/dd/yyyy'),5)"
        Debug.Print sSql
        ORAdata.Execute (sSql)


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

