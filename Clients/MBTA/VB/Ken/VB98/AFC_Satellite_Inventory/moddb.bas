Attribute VB_Name = "moddb"
Option Explicit
' recordsets and db connextions
'Public Const SQL_DSN = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=sa;Initial Catalog=dbCCRDSTAGE;Data Source=TESTBED\SQLSVRT1;"
'Public Const SQL_DSN_LOCAL = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=sa;Initial Catalog=MBTA;Data Source=(local);"
'Public Const SQL_DSN_LOCAL = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=mbta;Initial Catalog=MBTA;Data Source=ref14684\mba_test;"
'Public Const SQL_DSN_LIVE = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=mbta;Password=mbtadb;Initial Catalog=mbta2;Data Source=mbtasql\SQLSVR1;"

Public SQLDataTO As ADODB.Connection
Public SQLData As ADODB.Connection
Public RS_Location As ADODB.Recordset
Public RS_Tech As ADODB.Recordset
Public RS_Inventory As ADODB.Recordset
Public RS_LocInventory As ADODB.Recordset
Public RS_Trans As ADODB.Recordset
Public RS_Work As ADODB.Recordset
Public Headclick As Boolean
Public RSWork As ADODB.Recordset
Public RSDis As ADODB.Recordset

'********************************************************
'working storage variables
'varaibles for readit.

Public sSql As String
Public sSql2 As String
Public Current_User_Index As Long
Public Current_User_Id As Long
Public Current_User_Name As String
Public Current_User_Level As Long
Public Current_User_Branch As Long
Public Unit_Modify As Boolean

Public PW_Option As String
Public Pass_Index As Long
Public Report_Name As String
Public Printed As Boolean
Public Vdate As Date
'********************************************************
' reporting varaibles
Public Rpt_Text1 As String
Public Rpt_Text2 As String
Public Rpt_Text3 As String
Public Rpt_Text4 As String
Public Rpt_Text5 As String
Public Rpt_Text6 As String
Public Rpt_Text7 As String
Public Rpt_Text8 As String
Public Rpt_Text9 As String
Public Rpt_Text10 As String
Public Rpt_Text11 As String
Public Rpt_Text12 As String
Public Rpt_Text13 As String
Public Rpt_Text14 As String
Public Loc_String As String
Public Date_String As String
Public ColDate_String As String
Public SentDate_String As String
Public RecDate_String As String
Public Rpt_Location As Long
Public Rpt_Type As String
Public Rpt_Outstanding As String
Public Type_String As String
Public Rpt_sPartno As Long
Public Rpt_ePartno As Long
Public Rpt_Serial As String
Public Rpt_Employee As Long
Public Rpt_TranType As Long
Public Rpt_Sort1 As Long
Public Rpt_Sort2 As Long
Public Rpt_Sort3 As Long
Public Rpt_Group As Long
Public Rpt_Rst As String
Public Rpt_Group1 As Long
Public Rpt_Group2 As Long
Public Rpt_Group3 As Long
Public Rpt_Group4 As Long
Public Rpt_Group1_order As Long
Public Rpt_Group2_order As Long
Public Rpt_Group3_order As Long
Public Rpt_Group4_order As Long

'basic variables.
Public m_NT_UserName As String
Public m_ComputerName As String
Public doncnt As Long
Public updowncount As Long
Public timeon As String
Public myloop As Long
Public hold_keyascii As Long
Public WB_Flag As String
'Public Transdata As Satellite_SQL
Public SandB_Generate As String ' (farebox, Branch=3) or (subway, branch=2)

' Incident Reporting variables
Public Device_String As String
Public Device_IN As String
Public Subway As String
Public Stations As String
Public Maint_Area As Long
Public Created_By As Integer
Public Closed_By As Integer
Public Completed_By As Integer
Public Arival As String
Public Defect As String
Public Action As String
Public Date_Created As String
Public Date_Closed As String
Public Component As Long
Public Techs_Allowed_Qty As Long
Public xlApp As Excel.Application
Public xlBook As Excel.Workbook
Public xlSheet As Excel.Worksheet
Public Scanning As Boolean

' Incident tracking varaibles
Public IT_Incident As Long
Public IT_Partno As Long
Public IT_Serialno As Long
Public IT_Machineno As Long
Public Conditions(5)

Private Declare Function GetComputerName Lib "kernel32" Alias "GetComputerNameA" (ByVal lpbuffer As String, nSize As Long) As Long
Private Declare Function GetUserName Lib "advapi32.dll" Alias "GetUserNameA" (ByVal lpbuffer As String, nSize As Long) As Long
Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
    

Public Sub Main()
Dim checkit As Integer
    Conditions(0) = " "
    Conditions(1) = "Excellent"
    Conditions(2) = "Good"
    Conditions(3) = "Fair"
    Conditions(4) = "Poor"
    Conditions(5) = "Unsatisfactory"
    
    GetComputer_Name
    GetUser_Name

    Set SQLData = New ADODB.Connection
    'SQLData.Open "dsn=MBTA2005c", "mbta", "mbtadb"
    SQLData.Open "dsn=MBTA2005", "mbta", "mbtadb"
    'SQLData.Open "dsn=local2005", "mbta", "mbtadb"
    checkit = PGBLPrevInstance
    If checkit = 1 Then
        PGBLActivatePrevInstance
    End If

    PW_Option = "Login"
    Frm_Login.Show vbModal
    Unload Frm_Login
    If Current_User_Id = 0 Then
        SQLData.Close
        Set SQLData = Nothing
        End
    End If
    'Call Load_Orders
    'Call Load_PackingLists
    'Call Load_Gates
    'Call Load_slaves
    'Call Load_Lights
    'Call Move_DB
    'Call Create_Racks
    'Call update_base
    'Call reset_received
    'Call Update_Settling
    'If Current_User_Id = 6389 Or Current_User_Id = 999999 Then
    '    Report_Name = "Instructions"
    '    Frm_RptViewer.Show vbModal
    'End If
    'Call Load_Farebox_Orders
    'Call Load_Where_Used
    'Call Load_Validator
    'Call Load_FareBoxes
    'Call Update_TestGroup
    'Call Load_Work_Stations
    'Call split_sb
    'Call Load_New_Parts
    'Call Update_Devices
    'Call check_gates
    'Call Check_Cards
    'Form1.Show vbModal
    'Call Yumary_Cashless
    'Call Yumary_Cashless2
    'Call Fix_Fullserve
    'Call Load_Fbox_Repairs
    FRM_Main.Show vbModal
    

End Sub

Public Sub Load_Fbox_Repairs()
Dim Mbta_Number As String
Dim Serial_Number As String
Dim Date_Installed As Date
      Set RS_Work = New ADODB.Recordset
      Dim sconn As String

      RS_Work.CursorLocation = adUseClient
      RS_Work.CursorType = adOpenKeyset
      RS_Work.LockType = adLockBatchOptimistic

      sconn = "DRIVER=Microsoft Excel Driver (*.xls);" & "DBQ=" & "C:\downloads\outstanding components.xls"
      RS_Work.Open "SELECT * FROM [Sheet1$]", sconn
fix_err:
      Debug.Print Err.Description + " " + _
                  Err.Source, vbCritical, "Import"
      Err.Clear

    Do While RS_Work.EOF = False
        If Trim(RS_Work("Back")) <> "" Then
        sSql = "insert into afc_workbench(awb_partno, awb_serialno, awb_location, awb_date_collected, awb_verified, " & _
        " awb_date_sent, awb_date_back, awb_work_branch, awb_notes) values(" & RS_Work("part") & ",'" & RS_Work("Serial") & _
        "',166,'" & RS_Work("Sent") & "','Y','" & RS_Work("Sent") & "','" & RS_Work("Back") & "',3,'" & Replace(RS_Work("description"), "'", "''") & "')"
        Else
        sSql = "insert into afc_workbench(awb_partno, awb_serialno, awb_location, awb_date_collected, awb_verified, " & _
        " awb_date_sent, awb_work_branch, awb_notes) values(" & RS_Work("part") & ",'" & RS_Work("Serial") & _
        "',166,'" & RS_Work("Sent") & "','Y','" & RS_Work("Sent") & "',3,'" & Replace(RS_Work("description"), "'", "''") & "')"
        End If
        
        SQLData.Execute (sSql)
        
        RS_Work.MoveNext
    Loop
    RS_Work.Close
    Set RSWork = Nothing
End Sub
Public Sub Fix_Fullserve()
Dim mbtano As String
Dim Ipol As String
Dim mbta_found As String
Dim ipol_found As String
Dim device As String
    sSql = "select * from fullservice"
    Call Get_Trans("Read")
    
    'GoTo skipit
    
    Do While RS_Trans.EOF = False
'check mbta
        mbtano = ""
        Ipol = ""
        mbta_found = ""
        ipol_found = ""
        sSql = "select i_device,au_mbtano from incident left outer join afc_unittable on au_index = i_device where i_incidentno = '" & RS_Trans("mbta_number") & "'"
        Call Get_Work("Read")
        If RS_Work.EOF = True Then
            mbta_found = "N"
            Call Get_Work("Close")
            GoTo Nextone
        End If
        device = RS_Work("au_mbtano")
        Call Get_Work("Close")
        GoTo haveit
        
Nextone:
'Check Ipol
        sSql = "select i_device,au_mbtano from incident left outer join afc_unittable on au_index = i_device where i_ipol = '" & RS_Trans("i_ipol_number") & "'"
        Call Get_Work("Read")
        If RS_Work.EOF = True Then
            ipol_found = "N"
            Call Get_Work("Close")
            GoTo Nexttwo
        End If
        device = RS_Work("au_mbtano")
        Call Get_Work("Close")

haveit:
        sSql = "Update fullservice set device = '" & device & "' where fs_index = " & RS_Trans("fs_index")
        SQLData.Execute (sSql)
        
Nexttwo:
        RS_Trans.MoveNext
        
    Loop
    Call Get_Trans("Close")
End Sub

Public Sub Yumary_Cashless()
Dim mbtano As String
Dim Ipol As String
Dim mbta_found As String
Dim ipol_found As String

    sSql = "select * from fullservice"
    Call Get_Trans("Read")
    
    'GoTo skipit
    
    Do While RS_Trans.EOF = False
'check mbta
        mbtano = ""
        Ipol = ""
        mbta_found = ""
        ipol_found = ""
        sSql = "select * from incident where i_incidentno = '" & RS_Trans("mbta_number") & "'"
        Call Get_Work("Read")
        If RS_Work.EOF = True Then
            mbta_found = "N"
            Call Get_Work("Close")
            GoTo Nextone
        End If
        If Trim(RS_Work("i_ipol")) <> Trim(RS_Trans("i_ipol_number")) Then Ipol = Trim(RS_Work("i_ipol"))
        Call Get_Work("Close")

Nextone:
'Check Ipol
        sSql = "select * from incident where i_ipol = '" & RS_Trans("i_ipol_number") & "'"
        Call Get_Work("Read")
        If RS_Work.EOF = True Then
            ipol_found = "N"
            Call Get_Work("Close")
            GoTo Nexttwo
        End If
        If Trim(RS_Work("i_incidentno")) <> Trim(RS_Trans("mbta_number")) Then mbtano = Trim(RS_Work("i_incidentno"))
        Call Get_Work("Close")
Nexttwo:
        sSql = "Update fullservice set mbta_by_ipol ='" & mbtano & "', ipol_by_mbta = '" & Ipol & "', ipol_notfound = '" & ipol_found & "', mbta_notfound = '" & mbta_found & "' where fs_index = " & RS_Trans("fs_index")
        SQLData.Execute (sSql)
        RS_Trans.MoveNext
        
    Loop
    Call Get_Trans("Close")
SkipIT:

' 720 fullservice
' 721 cashless
    sSql = "SELECT Incident.I_ID, Incident.I_Incidentno,Incident.i_ipol,afc_unittable.au_mbtano FROM Incident INNER JOIN" & _
    " AFC_UnitTable ON Incident.I_Device = AFC_UnitTable.AU_Index" & _
    " WHERE (CAST(FLOOR(CAST(Incident.I_DT_Reported AS float)) AS datetime) >= '05/01/2007') AND (CAST(FLOOR(CAST(Incident.I_DT_Reported AS float))" & _
    " AS datetime) <= '06/30/2007') AND (AFC_UnitTable.AU_Partno = 720) AND (AFC_UnitTable.AU_RST = 'Y')"
    
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        sSql = "select * from fullservice where mbta_number = '" & RS_Trans("i_incidentno") & "'"
        Call Get_Work("Read")
        If RS_Work.EOF = True Then
            sSql = "insert into fullservice (i_ipol_number, mbta_number, device, mbta_by_ipol) values ('" & _
             Trim(RS_Trans("I_Ipol")) & "','" & Trim(RS_Trans("i_incidentno")) & "','" & Trim(RS_Trans("au_mbtano")) & _
            "','Mis')"
            SQLData.Execute (sSql)
        End If
        RS_Trans.MoveNext
    Loop
    
    sSql = "select * from fullservice"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        sSql = "select au_rst from afc_unittable where au_mbtano = '" & Trim(RS_Trans("device")) & "'"
        Call Get_Work("Read")
        If RS_Work("au_rst") <> "Y" Then
            sSql = "update cashless set not_in_rst = 'Y' where cl_index = " & RS_Trans("fl_index")
            SQLData.Execute (sSql)
        End If
        RS_Trans.MoveNext
    Loop
End Sub
Public Sub Check_Cards()

Dim New_File As String
Dim Mbta_Number As String
Dim SB_No As String
Dim row As Long
Dim count As Long

    New_File = "F:\RST Gates\Rst Gates Compared.xls"

    Screen.MousePointer = vbHourglass
    DoEvents

    Set xlApp = CreateObject("Excel.Application")
    Set xlBook = xlApp.Workbooks.Add
    Set xlSheet = xlBook.Worksheets(1)

    ' Uncomment this line to make Excel visible.
    xlApp.Visible = False
    ' Create a new spreadsheet.

    ' Insert data into Excel.
    
    With xlSheet 'excel_app

        .Columns("A:A").ColumnWidth = 20
        .Cells(2, 1).Value = "ORig Ipol"
        .Cells.ColumnWidth = 10
        
        .Columns("B:B").ColumnWidth = 20
        .Cells(2, 2).HorizontalAlignment = xlCenter
        .Cells(2, 2).Value = "Orig Incident"
        
        .Columns("C:C").ColumnWidth = 20
        .Cells(2, 3).HorizontalAlignment = xlCenter
        .Cells(2, 3).Value = "Status"
        
        .Columns("D:D").ColumnWidth = 20
        .Cells(2, 4).HorizontalAlignment = xlCenter
        .Cells(2, 4).Value = "Actual Ipol"
        
        .Columns("E:E").ColumnWidth = 20
        .Cells(2, 5).HorizontalAlignment = xlCenter
        .Cells(2, 5).Value = "Actual Incident"
        
        .Columns("F:F").ColumnWidth = 20
        .Cells(2, 5).HorizontalAlignment = xlCenter
        .Cells(2, 5).Value = "Descrepancy Message"
    End With
    
      Set RS_Work = New ADODB.Recordset
Dim sconn As String

      RS_Work.CursorLocation = adUseClient
      RS_Work.CursorType = adOpenKeyset
      RS_Work.LockType = adLockBatchOptimistic

      sconn = "DRIVER=Microsoft Excel Driver (*.xls);" & "DBQ=" & "F:\RST Gates\RST Incidents Gate Check.xls"
      RS_Work.Open "SELECT * FROM [Sheet1$]", sconn
fix_err:
      Debug.Print Err.Description + " " + _
                  Err.Source, vbCritical, "Import"
      Err.Clear
    
    row = 3
    
    Do While RS_Work.EOF = False
        xlSheet.Cells(row, 1).Value = RS_Work("sb_no")
        xlSheet.Cells(row, 2).Value = RS_Work("mbta_no")

        If Trim(RS_Work("sb_no")) <> "" Then
            
            sSql = "select * from incident where i_ipol = '" & Trim(RS_Work("sb_no")) & "'"
            Call Get_Trans("Read")
                If RS_Trans.EOF = False Then
                    If Trim(RS_Work("mbta_no")) = RS_Trans("Incident") Then
                        xlSheet.Cells(row, 3).Value = "Match"
                        Call Get_Trans("Close")
                        GoTo Next_Record
                    Else
                        xlSheet.Cells(row, 3).Value = "No Match"
                        Call Get_Trans("Close")
                        sSql = "Select i_ipol from incident where I_Incidentno = '" & RTrim(RSWork("mbta_no")) & "'"
                        Call Get_Trans("Read")
                            If RS_Trans.EOF = False Then
                                xlSheet.Cells(row, 4).Value = RTrim(RS_Trans("I_Ipol"))
                                xlSheet.Cells(row, 6).Value = "Discrepancy New I_Pol"
                                Call Get_Trans("Close")
                                GoTo Next_Record
                            Else
                                xlSheet.Cells(row, 6).Value = "I_Pol Not Found"
                                Call Get_Trans("Close")
                                GoTo Next_Record
                            End If
                    End If
                Else
                    sSql = "Select i_ipol from incident where I_Incidentno = '" & RTrim(RSWork("mbta_no")) & "'"
                    Call Get_Trans("Read")
                        If RS_Trans.EOF = False Then
                            xlSheet.Cells(row, 4).Value = RTrim(RS_Trans("I_Ipol"))
                            xlSheet.Cells(row, 6).Value = "Discrepancy New I_Pol"
                            Call Get_Trans("Close")
                            GoTo Next_Record
                        Else
                            xlSheet.Cells(row, 6).Value = "I_Pol Not Found"
                            Call Get_Trans("Close")
                            GoTo Next_Record
                        End If
                End If
        End If
        row = row + 1
Next_Record:
        RS_Work.MoveNext
    Loop
    RS_Work.Close
    Set RSWork = Nothing
    
End Sub

Public Sub Update_Devices()
Dim Mbta_Number As String
Dim Serial_Number As String
Dim Date_Installed As Date
      Set RS_Work = New ADODB.Recordset
      Dim sconn As String

      RS_Work.CursorLocation = adUseClient
      RS_Work.CursorType = adOpenKeyset
      RS_Work.LockType = adLockBatchOptimistic

      sconn = "DRIVER=Microsoft Excel Driver (*.xls);" & "DBQ=" & "F:\AFC_Data\AFC Equipment IDs_Lynk Merchant Terminal Numbers_and Revenue Service Dates 060107.xls"
      RS_Work.Open "SELECT * FROM [Devices$]", sconn
fix_err:
      Debug.Print Err.Description + " " + _
                  Err.Source, vbCritical, "Import"
      Err.Clear

    Do While RS_Work.EOF = False
    

        If RS_Work("eqptid") <> "end" And RS_Work("eqptid") <> "N/A" And RS_Work("eqptid") <> "gate" Then
            Mbta_Number = RS_Work("eqptid")
            Serial_Number = IIf(IsNull(RS_Work("serial")) = True, "", RS_Work("serial"))
            Date_Installed = IIf(IsNull(RS_Work("service_date")) = True, 0, RS_Work("service_date"))
            'Date_Installed = RS_Work("service_date")
            If Serial_Number = "?????????" Then Serial_Number = ""
            sSql = "select * from afc_unittable where au_mbtano = '" & Mbta_Number & "'"
            Call Get_Trans("Read")
'
            sSql = "update afc_unittable set"
            If RTrim(RS_Trans("au_serialno")) = "" And Serial_Number <> "" Then sSql = sSql & " au_serialno = '" & Serial_Number & "',"
            sSql = sSql & " au_daterolledout = '" & Date_Installed & "' where au_mbtano = '" & Mbta_Number & "'"
            Call Get_Trans("Close")
            SQLData.Execute (sSql)
        End If
        
        RS_Work.MoveNext
    Loop
    RS_Work.Close
    Set RSWork = Nothing
End Sub


Public Sub Load_New_Parts()
Dim part As String
Dim desc As String
Dim Inst As Date

      
      Set RS_Work = New ADODB.Recordset
      Dim sconn As String

      RS_Work.CursorLocation = adUseClient
      RS_Work.CursorType = adOpenKeyset
      RS_Work.LockType = adLockBatchOptimistic

      sconn = "DRIVER=Microsoft Excel Driver (*.xls);" & "DBQ=" & "C:\Documents and Settings\ken\My Documents\cables.xls"
      RS_Work.Open "SELECT * FROM [Cables$]", sconn
fix_err:
      Debug.Print Err.Description + " " + _
                  Err.Source, vbCritical, "Import"
      Err.Clear

    Do While RS_Work.EOF = False
        part = RS_Work("part")
        desc = RS_Work("desc")
        sSql = "insert into afc_inventory(ai_partno, ai_description, ai_parttype, ai_satellite, ai_required)" & _
        " values ('" & part & "','" & desc & "','FRC','F',3)"
        SQLData.Execute (sSql)
        
        sSql = "select ai_index from afc_inventory where ai_partno = '" & part & "'"
        Call Get_Trans("Read")
        
        sSql = "Insert into afc_where_used(awu_partno, awu_equiptype) values(" & RS_Trans("ai_index") & ",1)"
        SQLData.Execute (sSql)
        
        Call Get_Trans("Close")
        
        RS_Work.MoveNext
        
    Loop
    RS_Work.Close
    Set RSWork = Nothing
End Sub
Public Sub split_sb()
Dim Pos As Integer
Dim KeyAscii As Integer
Dim item As String
Dim label_part As String
Dim Label_serial As String
Dim splitter As String
    sSql = "select * from sb_workbench"
    Call Get_Work("Read")
    Do While RS_Work.EOF = False
        
        item = RS_Work("Part")
        Pos = InStr(1, Trim(item), " ")
        If Pos = 0 Then
            GoTo SkipIT
        End If

        label_part = CLng(Trim(Mid(item, 1, Pos)))
        sSql = "select ai_index from afc_inventory where ai_partno='" & label_part & "'"
        Call Get_Trans("Read")
            If RS_Trans.EOF = True Then
                label_part = CLng(Trim(Mid(item, 1, Pos - 2)))
                sSql = "select ai_index from afc_inventory where ai_partno='" & label_part & "'"
                Call Get_Trans("Read")
            End If
        splitter = Trim(Mid(item, Pos, Len(item)))
        If Mid(splitter, 1, 1) > 9 Then
            splitter = Mid(splitter, 2, Len(splitter))
        End If
        Label_serial = splitter
    
        RS_Trans.Close
        Set RS_Trans = Nothing
        sSql = "update sb_workbench set part = '" & label_part & "',serial = '" & Label_serial & "' where id = " & RS_Work("ID")
        SQLData.Execute (sSql)
SkipIT:
        RS_Work.MoveNext
    Loop
    


End Sub

Public Sub Load_Work_Stations()
Dim Name As String
Dim loc As Integer
Dim Inst As Date

      
      Set RS_Work = New ADODB.Recordset
      Dim sconn As String

      RS_Work.CursorLocation = adUseClient
      RS_Work.CursorType = adOpenKeyset
      RS_Work.LockType = adLockBatchOptimistic

      sconn = "DRIVER=Microsoft Excel Driver (*.xls);" & "DBQ=" & "C:/workstn_New.xls"
      RS_Work.Open "SELECT * FROM [Station Controller$]", sconn
fix_err:
      Debug.Print Err.Description + " " + _
                  Err.Source, vbCritical, "Import"
      Err.Clear

    Do While RS_Work.EOF = False
        Name = RS_Work("station_id")
        loc = RS_Work("Location")
        Inst = Format(RS_Work("date_installed"), "mm/dd/yyyy")
        sSql = "insert into afc_unittable (au_partno, au_mbtano, au_serialno,au_daterolledout, au_location) values(98,'" & Name & "',' ','" & Inst & "'," & loc & ")"
        SQLData.Execute (sSql)
        RS_Work.MoveNext
        
    Loop
    RS_Work.Close
    Set RSWork = Nothing
End Sub
Public Sub Update_TestGroup()
    sSql = "select * from fareboxtestgroup"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        sSql = "Update afc_unittable set AU_RST='Y' where au_mbtano='" & RTrim(RS_Trans("car")) & "'"
        SQLData.Execute (sSql)
        RS_Trans.MoveNext
    Loop
End Sub
Public Sub Load_FareBoxes()
Dim Counter As Long
Dim my_box As String
    sSql = "select * from buses"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        sSql = "insert into AFC_Unittable (au_partno, au_mbtano, au_serialno, au_daterolledout,au_location) values(779,'" & RS_Trans("bus") & "',' ','3/20/2007',518)"
        SQLData.Execute (sSql)

        RS_Trans.MoveNext
    Loop
    Call Get_Trans("Close")
End Sub

Public Sub Load_Validator()

    sSql = "SELECT Validator.Description, Validator.PartType, Validator.Cost, ISNULL(Validator.Ordered, 0) AS ordered, ISNULL(AFC_Inventory.AI_Index, 0) AS ai_index, Validator.Partno FROM Validator LEFT OUTER JOIN " & _
            "AFC_Inventory ON Validator.Partno = AFC_Inventory.AI_Partno"
            
    Call Get_Trans("Read")
    
    Do While RS_Trans.EOF = False
        If RS_Trans("ai_index") <> 0 Then
            sSql = "update afc_inventory set ai_fmv_order = " & RS_Trans("Ordered") & " where ai_index = " & RS_Trans("ai_index")
            SQLData.Execute (sSql)
            sSql = "insert into afc_where_used (awu_partno,awu_equiptype) values(" & RS_Trans("ai_index") & ",9)"
            SQLData.Execute (sSql)
        Else
            sSql = "Insert into afc_inventory(ai_description,ai_partno, AI_Parttype, ai_currentcost,ai_fmv_order,ai_received, ai_settelingsb, ai_usage) values(" & _
            "'" & Trim(RS_Trans("description")) & "','" & RS_Trans("Partno") & "','" & Trim(RS_Trans("parttype")) & "'," & RS_Trans("Cost") & "'" & RS_Trans("ORDERED") & ",0,0,0)"
            SQLData.Execute (sSql)
            sSql = "select ai_index from afc_inventory where ai_partno = '" & Trim("partno") & "'"
            Call Get_Work("Read")
            sSql = "insert into afc_where_used (awu_partno,awu_equiptype) values(" & RSWork("(ai_index") & ",9)"
            SQLData.Execute (sSql)
            Call Get_Work("Close")
        End If
        
        RS_Trans.MoveNext
    Loop
    Call Get_Trans("close")
    
End Sub


Public Sub Load_Where_Used()
    
    sSql = "SELECT PartType.Part, PartType.Equip, AFC_Inventory.AI_Index FROM PartType LEFT OUTER JOIN AFC_Inventory ON PartType.Part = AFC_Inventory.AI_Partno"
    Call Get_Trans("Read")
    
    Do While RS_Trans.EOF = False
        sSql = "Insert into AFC_Where_Used(AWU_Partno, AWU_Equiptype) values(" & RS_Trans("AI_Index") & "," & RS_Trans("Equip") & ")"
        SQLData.Execute (sSql)
        RS_Trans.MoveNext
    Loop
    Call Get_Trans("Close")

End Sub
Public Sub Load_Farebox_Orders()
    sSql = "select * from farebox1"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        sSql = "update afc_inventory set ai_Farebox_order1 = " & RS_Trans("Qty") & " where ai_partno = " & RS_Trans("part")
        SQLData.Execute (sSql)
        RS_Trans.MoveNext
    Loop
    Call Get_Trans("Close")
    
End Sub
Public Sub Update_Settling()
    sSql = "select * from settleing"
    Call Get_Trans("Read")
    Do Until RS_Trans.EOF = True
        sSql = "Update afc_inventory set ai_settelingsb = ai_settelingsb + " & RS_Trans("settle_amount") & " where ai_partno=" & RS_Trans("Unit")
        SQLData.Execute (sSql)
        RS_Trans.MoveNext
    Loop
End Sub
Public Sub reset_received()

    sSql = "SELECT AFC_Transaction_History.ATH_Qty, AFC_Transaction_History.ATH_Tran_Date, AFC_Transaction_History.ATH_PackList, " & _
                "AFC_Transaction_History.ATH_Comments , AFC_Inventory.AI_Partno, AFC_Inventory.AI_Description, AFC_Inventory.AI_PartType, " & _
                "AFC_Inventory.AI_Received , AFC_Inventory.AI_Order1, AFC_Inventory.AI_Order2, AFC_Inventory.AI_Order3, " & _
                "AFC_Inventory.AI_Order4, ISNULL(AFC_Inventory.AI_SettelingSB, 0) AS AI_SettelingSB, ai_index " & _
                "FROM AFC_Transaction_History LEFT OUTER JOIN " & _
                "AFC_Inventory ON AFC_Transaction_History.ATH_Partno = AFC_Inventory.AI_Index " & _
                "WHERE     (AFC_Transaction_History.ATH_First4 = 'Y') order by ai_index"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        
        sSql = "update afc_inventory set ai_received = ai_received + " & RS_Trans("ATH_Qty") & " where ai_index = " & RS_Trans("ai_index")
        SQLData.Execute (sSql)
        
        RS_Trans.MoveNext
    Loop

End Sub

Public Sub update_base()

    sSql = "SELECT * From AFC_WorkBench WHERE AWB_Date_Back = '02/14/2007'"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        sSql = "Update afc_locbalance set alb_onhand = alb_onhand + 1 where alb_location=1 and alb_partno = " & RS_Trans("awb_partno")
        SQLData.Execute (sSql)
        RS_Trans.MoveNext
    Loop
End Sub

Public Sub Create_Racks()
Dim Rack As String
Dim Rack_desc As String
Dim index As Integer

    For index = 1 To 80
        Rack = "RR-" & CStr(index)
        Rack_desc = "Rolling Rack " & Rack
        sSql = "insert into afc_location(al_abrv,al_location_name,al_location_type,al_line) values('" & Rack & "','" & Rack_desc & "',3,0)"
        SQLData.Execute (sSql)
'        Rack = CStr(index) & "-B"
'        Rack_desc = "Rack " & CStr(index) & "-B"
'        sSql = "insert into afc_location(al_abrv,al_location_name,al_location_type,al_line) values('" & Rack & "','" & Rack_desc & "',3,0)"
'        SQLData.Execute (sSql)
'        Rack = CStr(index) & "-C"
'        Rack_desc = "Rack " & CStr(index) & "-C"
'        sSql = "insert into afc_location(al_abrv,al_location_name,al_location_type,al_line) values('" & Rack & "','" & Rack_desc & "',3,0)"
'        SQLData.Execute (sSql)
'        Rack = CStr(index) & "-D"
'        Rack_desc = "Rack " & CStr(index) & "-D"
'        sSql = "insert into afc_location(al_abrv,al_location_name,al_location_type,al_line) values('" & Rack & "','" & Rack_desc & "',3,0)"
'        SQLData.Execute (sSql)
'        Rack = CStr(index) & "-E"
'        Rack_desc = "Rack " & CStr(index) & "-E"
'        sSql = "insert into afc_location(al_abrv,al_location_name,al_location_type,al_line) values('" & Rack & "','" & Rack_desc & "',3,0)"
'        SQLData.Execute (sSql)
    Next
    
End Sub
Public Sub Move_DB()
    Set SQLDataTO = New ADODB.Connection
    SQLDataTO.Open "dsn=MBTA2005", "MBTA", "mbtadb"

' Move AFC_Inventory
    sSql = "Select * from afc_inventory"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
    
        Call PGBLRecToTemp_afc_inventory(RS_Trans)
        sSql = "Insert into AFC_Inventory(AI_Index, AI_Partno,AI_Description,AI_PartType,AI_OEMPartno,AI_CurrentCost,AI_AltPartno,AI_Satellite,AI_Required,AI_Onhand,AI_Damaged," & _
            "AI_MinROP,AI_MaxROP,AI_RLBase,AI_RLSatellite,AI_rolledout,AI_Order1,AI_Order2,AI_Order3,AI_Order4,AI_Received,AI_Usage,AI_Notes) " & _
            " Values (" & tAI_Index & ",'" & tAI_Partno & "','" & tAI_Description & "','" & tAI_PartType & "','" & tAI_OEMPartno & "'," & tAI_CurrentCost & ",'" & tAI_AltPartno & "','" & tAI_Satellite & "'," & _
            tAI_Required & "," & tAI_Onhand & "," & tAI_Damaged & "," & tAI_MinROP & "," & tAI_MaxROP & "," & tAI_RLBase & "," & tAI_RLSatellite & ",'" & tAI_rolledout & "'," & _
            tAI_Order1 & "," & tAI_Order2 & "," & tAI_Order3 & "," & tAI_Order4 & "," & tAI_Received & "," & tAI_Usage & ",'" & tAI_Notes & "')"

            SQLDataTO.Execute (sSql)
        RS_Trans.MoveNext
    Loop
    RS_Trans.Close
    Set RS_Trans = Nothing

' Move AFC_Location
    sSql = "Select * from afc_location"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        Call PGBLRecToTemp_AFC_Location(RS_Trans)
        sSql = "Insert into AFC_Location (AL_ID, AL_Abrv,AL_Location_Name,AL_Location_type,AL_Line)" & _
         "Values (" & tAL_ID & ",'" & tAL_Abrv & "','" & tAL_Location_Name & "'," & tAL_Location_type & "," & tAL_Line & ")"
        SQLDataTO.Execute (sSql)
        RS_Trans.MoveNext
    Loop
    RS_Trans.Close
    Set RS_Trans = Nothing
    
' Move AFC_Location_type
    sSql = "Select * from afc_locationtype"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        sSql = "Insert into afc_locationtype(alt_index,alt_description,alt_line) " & _
        " values(" & RS_Trans("alt_index") & ",'" & RS_Trans("alt_description") & "','" & RS_Trans("alt_line") & "')"
        SQLDataTO.Execute (sSql)
        RS_Trans.MoveNext
    Loop
    RS_Trans.Close
    Set RS_Trans = Nothing
    
' Move AFC_technicians
    sSql = "Select * from afc_technicians"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        sSql = "Insert into afc_technicians (at_id,at_empno, at_password, AT_emplname, at_empFname, AT_Access_level, AT_CellPhone)" & _
        " values(" & RS_Trans("at_ID") & ",'" & RS_Trans("at_empno") & "',' ','" & Replace(RS_Trans("at_emplname"), "'", "''") & "','" & RS_Trans("at_empfname") & "'," & RS_Trans("at_access_level") & ",'" & RS_Trans("at_cellphone") & "')"
        SQLDataTO.Execute (sSql)
        RS_Trans.MoveNext
    Loop
    RS_Trans.Close
    Set RS_Trans = Nothing
    
' Move AFC_transaction_history
    sSql = "Select * from afc_transaction_history"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        Call PGBLRecToTemp_AFC_Transaction_History(RS_Trans)
        Call PGBLinsertintoAFC_Transaction_History
        SQLDataTO.Execute (sSql)
        RS_Trans.MoveNext
    Loop
    RS_Trans.Close
    Set RS_Trans = Nothing
    
' Move AFC_transType
    sSql = "Select * from afc_transtype "
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        sSql = "Insert into AFC_TransType(ATT_Code, ATT_Description) Values('" & RS_Trans("att_code") & "','" & RS_Trans("att_description") & "')"
        'Call PGBLRecToTemp_AFC_Transaction_History(RS_Trans)
        'Call PGBLinsertintoAFC_Transaction_History
        SQLDataTO.Execute (sSql)
        RS_Trans.MoveNext
    Loop
    RS_Trans.Close
    Set RS_Trans = Nothing
    
' Move AFC_UnitTable

    sSql = "Select * from afc_UnitTable"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        Call PGBLRecToTemp_afc_unittable(RS_Trans)
        Call PGBLinsertintoafc_unittable
        SQLDataTO.Execute (sSql)
        RS_Trans.MoveNext
    Loop
    RS_Trans.Close
    Set RS_Trans = Nothing

' Move Incident_Codes

    sSql = "Select * from Incident_Codes"
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        sSql = "insert into incident_Codes(IC_Type, IC_Abrv,IC_Description) values(" & RS_Trans("ic_type") & ",'" & RS_Trans("IC_Abrv") & "','" & RS_Trans("ic_description") & "')"
        SQLDataTO.Execute (sSql)
        RS_Trans.MoveNext
    Loop
    RS_Trans.Close
    Set RS_Trans = Nothing
    
End Sub

Public Sub Load_Gates()
    sSql = "select isnull(fg.id,' ') AS id, isnull(fg.serial,' ') AS serial, fg.installed AS daterolledout, ai.AI_Index AS AI_Index, al.AL_ID AS AL_ID " & _
        "FROM  fvmgate fg " & _
        "LEFT OUTER JOIN AFC_Location al ON fg.location = al.AL_Abrv " & _
        "LEFT OUTER JOIN AFC_Inventory ai ON fg.partno = ai.AI_Partno " & _
        "where isnull(fg.partno,'') <>''"
    Call Get_Trans("Read")
    
    Do While RS_Trans.EOF = False
        If RS_Trans("id") = "111111" Or RS_Trans("id") = "222222" Then GoTo SkipIT
        sSql = "SELECT * FROM AFC_UNITTABLE WHERE AU_MBTAno = " & RS_Trans("ID")
        Call Get_Inventory("Read")
        If RS_Inventory.EOF = False Then
            sSql = "update afc_unittable set au_serialno='" & RS_Trans("serial") & "', au_daterolledout='" & RS_Trans("daterolledout") & "' where au_mbtano= '" & Trim(RS_Trans("id")) & "'"
            SQLData.Execute (sSql)
        Else
    
            sSql = "insert into afc_unittable (AU_Partno, AU_Mbtano, AU_Serialno, AU_Daterolledout, AU_Location)" & _
            " values(" & RS_Trans("AI_Index") & ",'" & RS_Trans("id") & "','" & RS_Trans("serial") & "','" & RS_Trans("daterolledout") & "'," & RS_Trans("al_id") & ")"
            SQLData.Execute (sSql)
        End If
        RS_Inventory.Close
        Set RS_Inventory = Nothing

SkipIT:
        RS_Trans.MoveNext
    Loop
    RS_Trans.Close
    Set RS_Trans = Nothing

End Sub
Public Sub Load_slaves()
    sSql = "select isnull(fg.id,' ') AS id, isnull(fg.serial,' ') AS serial, fg.installed AS daterolledout, ai.AI_Index AS AI_Index, al.AL_ID AS AL_ID " & _
        "FROM  fvmgate fg " & _
        "LEFT OUTER JOIN AFC_Location al ON fg.location = al.AL_Abrv " & _
        "LEFT OUTER JOIN AFC_Inventory ai ON fg.partno = ai.AI_Partno " & _
        "where fg.id = '111111'"
    Call Get_Trans("Read")
    
    Do While RS_Trans.EOF = False
        sSql = "SELECT * FROM AFC_UNITTABLE WHERE AU_serialno = " & RS_Trans("serial")
        Call Get_Inventory("Read")
        If RS_Inventory.EOF = False Then
            RS_Inventory.Close
            Set RS_Inventory = Nothing
            GoTo SkipIT
        End If
        
        sSql = "select * from afc_unittable where au_location = " & RS_Trans("al_id") & " and au_partno in (724,725,738,740,739) and isnull(au_serialno,'')=''"
        Call Get_Inventory("Read")
        If RS_Inventory.EOF = True Then
            RS_Inventory.Close
            Set RS_Inventory = Nothing
        Else
            sSql = "update afc_unittable set au_serialno='" & Trim(RS_Trans("serial")) & "', au_daterolledout='" & RS_Trans("daterolledout") & "' where au_index = " & RS_Inventory("au_index")
            SQLData.Execute (sSql)
            RS_Inventory.Close
            Set RS_Inventory = Nothing
            GoTo SkipIT
        End If

        sSql = "insert into afc_unittable (AU_Partno, AU_Mbtano, AU_Serialno, AU_Daterolledout, AU_Location)" & _
        " values(" & RS_Trans("AI_Index") & ",'end','" & RS_Trans("serial") & "','" & RS_Trans("daterolledout") & "'," & RS_Trans("al_id") & ")"
        SQLData.Execute (sSql)

SkipIT:
        
        RS_Trans.MoveNext
    Loop
    RS_Trans.Close
    Set RS_Trans = Nothing

End Sub
Public Sub Load_Lights()
    sSql = "select isnull(fg.id,' ') AS id, isnull(fg.serial,' ') AS serial, fg.installed AS daterolledout, ai.AI_Index AS AI_Index, al.AL_ID AS AL_ID " & _
        "FROM  fvmgate fg " & _
        "LEFT OUTER JOIN AFC_Location al ON fg.location = al.AL_Abrv " & _
        "LEFT OUTER JOIN AFC_Inventory ai ON fg.partno = ai.AI_Partno " & _
        "where fg.id = '222222'"
    Call Get_Trans("Read")
    
    Do While RS_Trans.EOF = False
        sSql = "SELECT * FROM AFC_UNITTABLE WHERE AU_serialno = " & RS_Trans("serial")
        Call Get_Inventory("Read")
        If RS_Inventory.EOF = False Then
            RS_Inventory.Close
            Set RS_Inventory = Nothing
            GoTo SkipIT
        End If
        
        sSql = "select * from afc_unittable where au_location = " & RS_Trans("al_id") & " and au_partno = 565 and isnull(au_serialno,'0')='0'"
        Call Get_Inventory("Read")
        If RS_Inventory.EOF = True Then
            RS_Inventory.Close
            Set RS_Inventory = Nothing
        Else
            sSql = "update afc_unittable set au_serialno='" & Trim(RS_Trans("serial")) & "', au_daterolledout='" & RS_Trans("daterolledout") & "' where au_index = " & RS_Inventory("au_index")
            SQLData.Execute (sSql)
            RS_Inventory.Close
            Set RS_Inventory = Nothing
            GoTo SkipIT
        End If

        sSql = "insert into afc_unittable (AU_Partno, AU_Mbtano, AU_Serialno, AU_Daterolledout, AU_Location)" & _
        " values(" & RS_Trans("AI_Index") & ",'end','" & RS_Trans("serial") & "','" & RS_Trans("daterolledout") & "'," & RS_Trans("al_id") & ")"
        SQLData.Execute (sSql)

SkipIT:
        
        RS_Trans.MoveNext
    Loop
    RS_Trans.Close
    Set RS_Trans = Nothing

End Sub
Public Sub Load_PackingLists()

sSql = "SELECT r.Received as received, r.Packlist as packlist, r.ShipDate as shipdate, r.Orderno as orderno , isnull(r.Backorder,0) as backorder, ai.AI_Index as ai_index FROM  receipt r left outer join AFC_Inventory ai on r.Partno = ai.AI_Partno "
    
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
    
        tATH_Partno = RS_Trans("AI_Index")
        tATH_Part_Serialno = ""
        tATH_Empno = 35
        tATH_Machine = "Kens LT"
        tATH_Tran_type = 5
        tATH_Qty = RS_Trans("received")
        tATH_Location = 1
        tATH_Tran_Location = 0
        tATH_Tran_Date = RS_Trans("shipDate")
        tATH_Time = Now
        tATH_First4 = "Y"
        tATH_PackList = RS_Trans("PackList")
        If RS_Trans("backorder") <> 0 Then
            tATH_Comments = RS_Trans("backorder") & " Backorders on the Packing list fir this item"
        Else
            tATH_Comments = ""
        End If
        Call PGBLinsertintoAFC_Transaction_History
        SQLData.Execute (sSql)
        RS_Trans.MoveNext
    Loop
    Call Get_Trans("Close")

End Sub
Public Sub Load_Orders()
    sSql = "select * from all_orders"
    Call Get_Trans("Read")
    
    Do While RS_Trans.EOF = False
        sSql = "Update AFC_inventory set ai_order1 = ai_order1 + " & RS_Trans("order1") & _
        ", ai_order2 = ai_order2 + " & RS_Trans("order2") & _
        ", ai_order3 = ai_order3 + " & RS_Trans("order3") & _
        ", ai_order4 = ai_order4 + " & RS_Trans("order4") & _
        ", ai_received= ai_received + " & RS_Trans("received") & _
        " where ai_partno = " & RS_Trans("Part")
        SQLData.Execute (sSql)
        RS_Trans.MoveNext
    Loop
Call Get_Trans("Close")
End Sub
Function GetUser_Name() As String
Dim lSize As Long
    

  m_NT_UserName = Space$(255)
  lSize = Len(m_NT_UserName)
  Call GetUserName(m_NT_UserName, lSize)
  If lSize > 0 Then
     m_NT_UserName = Left$(m_NT_UserName, lSize - 1)
  Else
     m_NT_UserName = vbNullString
  End If
  GetUser_Name = m_NT_UserName
End Function


Function GetComputer_Name() As String
Dim lSize As Long

  m_ComputerName = Space$(255)
  lSize = Len(m_ComputerName)
  Call GetComputerName(m_ComputerName, lSize)
  If lSize > 0 Then
     m_ComputerName = Left$(m_ComputerName, lSize)
  Else
     m_ComputerName = vbNullString
  End If
    
  GetComputer_Name = m_ComputerName
    
End Function


Public Sub Get_Trans(ByVal command As String)
    If command = "Read" Then
        Set RS_Trans = New ADODB.Recordset
        Debug.Print sSql
        
        Set RS_Trans = SQLData.Execute(sSql)
    Else
        On Error Resume Next
        RS_Trans.Close
        Set RS_Trans = Nothing
        On Error GoTo 0
    End If
End Sub

Public Sub Get_Inventory(ByVal command As String)
    If command = "Read" Then
        Set RS_Inventory = New ADODB.Recordset
        Set RS_Inventory = SQLData.Execute(sSql)
    Else
        On Error Resume Next
        RS_Inventory.Close
        Set RS_Inventory = Nothing
        On Error GoTo 0
    End If
    
End Sub
Public Sub Get_LocInventory(ByVal command As String)
    If command = "Read" Then
        Set RS_LocInventory = New ADODB.Recordset
        Set RS_LocInventory = SQLData.Execute(sSql)
    Else
        On Error Resume Next
        RS_LocInventory.Close
        Set RS_LocInventory = Nothing
        On Error GoTo 0
    End If
    
End Sub
Public Sub Get_Work(ByVal command As String)
    If command = "Read" Then
        Set RS_Work = New ADODB.Recordset
        Set RS_Work = SQLData.Execute(sSql)
    Else
        On Error Resume Next
        RS_Work.Close
        Set RS_Work = Nothing
        On Error GoTo 0
    End If
    
End Sub

Public Sub Get_Location(ByVal command As String)
    If command = "Read" Then
        Set RS_Location = New ADODB.Recordset
        Set RS_Location = SQLData.Execute(sSql)
    Else
        On Error Resume Next
        RS_Location.Close
        Set RS_Location = Nothing
        On Error GoTo 0
    End If
End Sub

Public Sub Get_Tech(ByVal command As String)
    If command = "Read" Then
        Set RS_Tech = New Recordset
        Set RS_Tech = SQLData.Execute(sSql)
    Else
        On Error Resume Next
        RS_Tech.Close
        Set RS_Tech = Nothing
        On Error GoTo 0
    End If

End Sub

Public Function Tran_Status(check_type As String, location As Long) As Boolean
' function to see if the current user either reserved a part or took
' that part with in the last couple of days.

    If check_type = "Check Reserve" Then
        sSql = "select * from afc_transaction_history where ath_empno = " & Current_User_Index & _
            " and ath_tran_date >= '" & Format(Now - 1, "mm/dd/yyyy") & _
            "' and ath_partno = " & tAI_Index & _
            " and ath_tran_type = 1 and ath_location = " & location & _
            " and isnull(ath_canDate,0) = 0"
        
        Call Get_Trans("Read")
        
        If RS_Trans.EOF = True Then
            Tran_Status = False
        Else
            Tran_Status = True
            sSql = "Update afc_transaction_history set ATH_candate = '" & Now & "', ath_closed=1 where ath_index = " & RS_Trans("ath_index")
            SQLData.Execute (sSql)
        End If
    End If
    If check_type = "Check Take" Then
        sSql = "select * from afc_transaction_history where ath_empno = " & Current_User_Index & _
            " and ath_tran_date >= '" & Format(Now - 1, "mm/dd/yyyy") & _
            "' and ath_partno = " & tAI_Index & _
            " and ath_tran_type = 2 and ath_location = " & location & _
            " and isnull(ath_canDate,0) = 0"
        Call Get_Trans("Read")
        
        If RS_Trans.EOF = True Then
            MsgBox ("The system does not show that you have took this part with in the last day")
            Tran_Status = False
        Else
            Tran_Status = True
            sSql = "Update afc_transaction_history set ATH_candate = '" & Now & "', ath_closed=1 where ath_index = " & RS_Trans("ath_index")
            SQLData.Execute (sSql)
        End If
        
    End If
    If check_type = "Check Location" Then
        sSql = "select * from afc_locbalance where alb_location = " & location & _
        " and alb_partno = " & tAI_Index
        Call Get_Trans("Read")
        
        If RS_Trans.EOF = True Then
            Tran_Status = False
        Else
            Tran_Status = True
        End If
    End If

    Call Get_Trans("Close")
End Function

Public Function Header_Query() As ADODB.Recordset
Dim Rec_Count As Long
Dim index As Long
Dim aindex As String
Dim apartno As String
Dim adesc As String

    sSql = "select count(ai_index) as rec_Count from AFC_Inventory where AI_Rolledout='Y'"
    Set RSWork = New ADODB.Recordset
    Set RSWork = SQLData.Execute(sSql)
    Rec_Count = RSWork("rec_count")
    
    RSWork.Close
    Set RSWork = Nothing
    
    Set RSDis = New ADODB.Recordset
    For index = 1 To Rec_Count
        aindex = "Index_" & index
        apartno = "Partno_" & index
        adesc = "Desc_" & index
        RSDis.Fields.Append aindex, adBigInt
        RSDis.Fields.Append apartno, adVarChar, 15
        RSDis.Fields.Append adesc, adVarChar, 45
    Next
    RSDis.Open
    
    Set RSWork = New ADODB.Recordset
    sSql = "select ai_index, ai_partno, Ai_description from afc_inventory where ai_rolledout='Y' order by ai_description"
    Set RSWork = SQLData.Execute(sSql)
    
    index = 0
    Do While RSWork.EOF = False
        RSDis.AddNew

        index = index + 1

        aindex = "Index_" & index
        apartno = "Partno_" & index
        adesc = "Desc_" & index

        RSDis(aindex).Value = RSWork("ai_index")
        RSDis(apartno).Value = RSWork("ai_partno")
        RSDis(adesc).Value = Trim(RSWork("ai_description"))
        RSWork.MoveNext
    Loop
    Set Header_Query = RSDis
    RSWork.Close
    Set RSWork = Nothing
    
End Function

Public Function Calendar_date(Pass_Date As String) As Date

    If Not IsDate(Pass_Date) Then
        Vdate = Date - 1
    Else
        Vdate = Pass_Date
    End If
    Call Frm_Calendar.SetStartDate(Vdate)
startit:
    Frm_Calendar.Show vbModal
    Vdate = Frm_Calendar.GetDate
    If IsDate(Vdate) = True Then
        If Vdate > Date Then
            If (MsgBox("Date Cannot be greater than Todays date", vbRetryCancel) = vbRetry) Then
                GoTo startit
            Else
                Exit Function
            End If
        End If
        Calendar_date = Format(Vdate, "MM/DD/YYYY")
    End If

End Function


