VERSION 5.00
Object = "{FB992564-9055-42B5-B433-FEA84CEA93C4}#11.0#0"; "crviewer.dll"
Begin VB.Form Frm_RptViewer 
   Caption         =   "Report Viewer"
   ClientHeight    =   8385
   ClientLeft      =   570
   ClientTop       =   900
   ClientWidth     =   12150
   LinkTopic       =   "Form1"
   ScaleHeight     =   8385
   ScaleWidth      =   12150
   Begin VB.CommandButton Cmd_GenTrans 
      BackColor       =   &H000000FF&
      Caption         =   "Generate Transfer Transactions"
      Height          =   375
      Left            =   7080
      Style           =   1  'Graphical
      TabIndex        =   1
      Top             =   240
      Width           =   3375
   End
   Begin CrystalActiveXReportViewerLib11Ctl.CrystalActiveXReportViewer CRViewer1 
      Height          =   7485
      Left            =   120
      TabIndex        =   0
      Top             =   360
      Width           =   11475
      _cx             =   20241
      _cy             =   13203
      DisplayGroupTree=   -1  'True
      DisplayToolbar  =   -1  'True
      EnableGroupTree =   0   'False
      EnableNavigationControls=   -1  'True
      EnableStopButton=   -1  'True
      EnablePrintButton=   -1  'True
      EnableZoomControl=   -1  'True
      EnableCloseButton=   -1  'True
      EnableProgressControl=   -1  'True
      EnableSearchControl=   -1  'True
      EnableRefreshButton=   0   'False
      EnableDrillDown =   -1  'True
      EnableAnimationControl=   0   'False
      EnableSelectExpertButton=   0   'False
      EnableToolbar   =   -1  'True
      DisplayBorder   =   0   'False
      DisplayTabs     =   -1  'True
      DisplayBackgroundEdge=   -1  'True
      SelectionFormula=   ""
      EnablePopupMenu =   -1  'True
      EnableExportButton=   -1  'True
      EnableSearchExpertButton=   0   'False
      EnableHelpButton=   0   'False
      LaunchHTTPHyperlinksInNewBrowser=   -1  'True
      EnableLogonPrompts=   -1  'True
      LocaleID        =   1033
   End
End
Attribute VB_Name = "Frm_RptViewer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Option Explicit

Dim Application As New CRAXDRT.Application
Dim Outside_report As New CRAXDRT.Report

Dim crxDatabaseField1 As CRAXDRT.DatabaseFieldDefinition
Dim crxDatabaseField2 As CRAXDRT.DatabaseFieldDefinition
Dim crxDatabaseField3 As CRAXDRT.DatabaseFieldDefinition

Dim CRXParamDefs As CRAXDRT.ParameterFieldDefinitions
Dim CRXParamDef As CRAXDRT.ParameterFieldDefinition
Dim CRXSubreport As CRAXDRT.Report

'Parameter fields


Private Sub Cmd_GenTrans_Click()
Dim topick As Long
    If MsgBox("By clicking this you are starting the inventory transfer process." & vbCrLf & "  Are you sure you wish to continue", vbYesNo + vbQuestion) = vbNo Then
        Exit Sub
    End If
    If Printed = False Then
        MsgBox ("You should Print the reports befrore proceding with this step."), vbOKCancel + vbCritical
        Exit Sub
    End If
    sSql = "exec satellite_requirements " & Rpt_Location & "," & Rpt_Type
    Call Get_Trans("Read")
    Do While RS_Trans.EOF = False
        If RS_Trans("Type") = "Fill" Then
            topick = RS_Trans("ai_required") - RS_Trans("alb_onhand")
            If topick > RS_Trans("Base_Avail") Then
                topick = RS_Trans("Base_Avail")
            End If
            If topick > 0 Then
                sSql = "insert into AFC_Inventory_Trans(AIT_Partno, AIT_Trantype, AIT_Location, AIT_Qty)" & _
                    " Values (" & RS_Trans("ai_index") & ",1 ," & RS_Trans("AL_ID") & ", " & topick & ")"
                SQLData.Execute (sSql)
            End If
        Else
            sSql = "insert into AFC_Inventory_Trans(AIT_Partno, AIT_Trantype, AIT_Location, AIT_Qty)" & _
                    " Values (" & RS_Trans("ai_index") & ",2 ," & RS_Trans("AL_ID") & ", " & RS_Trans("alb_onhand") & ")"
            SQLData.Execute (sSql)
        End If
        RS_Trans.MoveNext
    Loop
    
    Call Get_Trans("Close")
    
    Set Report = Nothing
    Unload Me

End Sub

Private Sub CRViewer1_PrintButtonClicked(UseDefault As Boolean)
    Printed = True
End Sub


Private Sub Form_Load()
    Cmd_GenTrans.Visible = False
    Screen.MousePointer = vbHourglass

    Select Case Report_Name
    Case "Master_Component_Report" 'Master Inventory Listing
        Call Master_component_list
    
    Case "Inventory_Request"    'Inventory fullfillment request
        Call Inventory_Request_rpt

    Case "Technicians"          'Technician list # Name, Phone, access level
        Call Technician_rpt

    Case "Send to Burlington"   'Damages to send to S&B Burlington
        Call SendToBurlington
    
    Case "Tran History" ' Inventory Transaction History
        Call Tran_History_rpt

    Case "Work Bench"
        Call Work_Bench
    
    Case "FVM Gate"
        Call FVM_Gate_Report
     
    Case "FVM Gate Detail"
        Call FVM_Gate_Detail
    
    Case "First 4"
        Call First_4
        
    Case "INV Reconcile"
        Call INV_Reconcile
    
    Case "S&B Receipts"
        Call SB_Receipts_rpt

    Case "Open Damages"
        Call Open_Damages_Rpt
    
    Case "Location Rpt"
        Call Location_Rpt
    
    Case "Instructions"
        Call Chris_Instruct
        
    Case "Receipts"
        Call Receipts
    
    Case "Physical Rpt"
        Call Physical_List
    
    Case "Incident Detail"
        Call Incident_Detail_rpt
    
    Case "Incident Totals"
        Call Incident_Totals_Rpt
    
    Case "Mean Time"
        Call Mean_Time_Rpt
    Case "CRS Status"
        Call CRS_Rpt
    End Select
    
    Screen.MousePointer = vbDefault
    
End Sub
Public Sub Master_component_list()
Dim Report2 As New Master_Loc_Report
        
        Master_Loc_Report.Database.SetDataSource SQLData
        Master_Loc_Report.Database.Tables(1).SetLogOnInfo "mbta2005", "", "mbta", "mbtadb"
        CRViewer1.EnableExportButton = True
        CRViewer1.ReportSource = Report2
        CRViewer1.ViewReport

End Sub
Public Sub Inventory_Request_rpt()
Dim Report As New Inventory_Request

    Cmd_GenTrans.Visible = True
    Printed = False
             
'Go through each section in the main report...

    Inventory_Request.Database.SetDataSource SQLData
    Inventory_Request.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
        
    Set CRXParamDefs = Report.ParameterFields
    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef
                    
        Select Case .ParameterFieldName
            Case "@Location"
                .AddCurrentValue (CLng(Rpt_Location))
            Case "@type"
                .AddCurrentValue Rpt_Type
                '----------------
            End Select
        End With
    Next
    Report.EnableParameterPrompting = False

    CRViewer1.ReportSource = Report
    CRViewer1.ViewReport

End Sub
Public Sub Technician_rpt()
Dim Report3 As New Technicians

    Technicians.Database.SetDataSource SQLData
    Technicians.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
    CRViewer1.EnableExportButton = True
    CRViewer1.ReportSource = Report3
    CRViewer1.ViewReport

End Sub
Public Sub SendToBurlington()
Dim Report4 As New Send_SBList

    Printed = False
    Send_SBList.Database.SetDataSource SQLData
    Send_SBList.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
    
    Set CRXParamDefs = Report4.ParameterFields

    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef

        Select Case .ParameterFieldName
'It finds and sets the appropriate Crystal parameter.
'Now it finds and sets the appropriate stored procedure parameter.

        Case "Branch"
            .AddCurrentValue (Val(Current_User_Branch))
        Case "Location"
            .AddCurrentValue (Val(166))
        End Select
        End With
    Next
    
    
    CRViewer1.EnableExportButton = True
    CRViewer1.ReportSource = Report4
    CRViewer1.ViewReport

End Sub

Public Sub Tran_History_rpt()
Dim Report5 As New Tran_History

    Printed = False
' change the report grouping to be the first of the sorted items
    If Rpt_Sort1 <> 0 Then
        Report5.Areas("GH").GroupConditionField = Report5.Database.Tables(1).Fields(Rpt_Sort1)
    End If
    If Rpt_Sort2 <> 0 Then
        Set crxDatabaseField1 = Report5.Database.Tables.item(1).Fields.item(Val(Rpt_Sort1))
        'Set the field to crxDatabaseField
        Report5.RecordSortFields.item(1).Field = crxDatabaseField1
        'Set the SortField direction
        Report5.RecordSortFields.item(1).SortDirection = crAscendingOrder
    End If
    If Rpt_Sort3 <> 0 Then
        Set crxDatabaseField2 = Report5.Database.Tables.item(1).Fields.item(Val(Rpt_Sort2))
        'Set the field to crxDatabaseField
        Report5.RecordSortFields.item(2).Field = crxDatabaseField2
        'Set the SortField direction
        Report5.RecordSortFields.item(2).SortDirection = crAscendingOrder
    End If

    Tran_History.Database.SetDataSource SQLData
    Tran_History.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
        
    Set CRXParamDefs = Report5.ParameterFields

    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef

        Select Case .ParameterFieldName
'It finds and sets the appropriate Crystal parameter.
'Now it finds and sets the appropriate stored procedure parameter.

        Case "@STPartno"
            .AddCurrentValue (Val(Rpt_sPartno))
        Case "@EndPartno"
            .AddCurrentValue (Val(Rpt_ePartno))
        Case "@Serialno"
            .AddCurrentValue (Rpt_Serial)
        Case "@Employee"
            .AddCurrentValue (Val(Rpt_Employee))
        Case "@TranType"
            .AddCurrentValue (Type_String)
        Case "@Location"
            .AddCurrentValue (Loc_String)
        Case "@datestring"
            .AddCurrentValue (Date_String)
        End Select
        End With
    Next
        
    Report5.EnableParameterPrompting = False

    Report5.Crt1.SetText Rpt_Text1
    Report5.Crt2.SetText Rpt_Text2
    Report5.Crt3.SetText Rpt_Text3
    Report5.Crt4.SetText Rpt_Text4
    Report5.Crt5.SetText Rpt_Text5
    Report5.Crt6.SetText Rpt_Text6
    Report5.Text18.SetText Rpt_Text7
    CRViewer1.ReportSource = Report5
    CRViewer1.ViewReport

End Sub
Public Sub Work_Bench()
Dim Report6 As New workbench_report

    ' change the report grouping to be the first of the sorted items
        If Rpt_Sort1 <> 0 Then
            Report6.Areas("GH").GroupConditionField = Report6.Database.Tables(1).Fields(Rpt_Sort1)
        End If
        Printed = False
        If Rpt_Sort1 <> 0 Then
            Set crxDatabaseField1 = Report6.Database.Tables.item(1).Fields.item(Val(Rpt_Sort1))
            'Set the field to crxDatabaseField
            Report6.RecordSortFields.item(1).Field = crxDatabaseField1
            'Set the SortField direction
            Report6.RecordSortFields.item(1).SortDirection = crAscendingOrder
        End If
        If Rpt_Sort2 <> 0 Then
            Set crxDatabaseField2 = Report6.Database.Tables.item(1).Fields.item(Val(Rpt_Sort2))
            'Set the field to crxDatabaseField
            Report6.RecordSortFields.item(2).Field = crxDatabaseField2
            'Set the SortField direction
            Report6.RecordSortFields.item(2).SortDirection = crAscendingOrder
        End If
        If Rpt_Sort3 <> 0 Then
            Set crxDatabaseField3 = Report6.Database.Tables.item(1).Fields.item(Val(Rpt_Sort3))
            'Set the field to crxDatabaseField
            Report6.RecordSortFields.item(3).Field = crxDatabaseField3
            'Set the SortField direction
            Report6.RecordSortFields.item(3).SortDirection = crAscendingOrder
        End If

        'workbench_rpt.Database.SetDataSource SQLData
        workbench_report.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
        
        
        Set CRXParamDefs = Report6.ParameterFields

        For Each CRXParamDef In CRXParamDefs
        With CRXParamDef

        Select Case .ParameterFieldName
        'It finds and sets the appropriate Crystal parameter.
'Now it finds and sets the appropriate stored procedure parameter.

        Case "@STPartno"
            .AddCurrentValue (Val(Rpt_sPartno))
        Case "@EndPartno"
            .AddCurrentValue (Val(Rpt_ePartno))
        Case "@Serialno"
            .AddCurrentValue (Rpt_Serial)
        Case "@Location"
            .AddCurrentValue (Loc_String)
        Case "@Coldatestring"
            .AddCurrentValue (ColDate_String)
        Case "@Sentdatestring"
            .AddCurrentValue (SentDate_String)
        Case "@Recdatestring"
            .AddCurrentValue (RecDate_String)
        Case "@Outstanding"
            .AddCurrentValue (Rpt_Outstanding)
        Case "@ExtraSql"
            .AddCurrentValue (" awb.AWB_work_Branch ='" & Current_User_Branch & "'")
        End Select
        End With
        Next

        Report6.EnableParameterPrompting = False
        
        Report6.Crt1.SetText Rpt_Text1
        Report6.Crt2.SetText Rpt_Text2
        Report6.Crt3.SetText Rpt_Text3
        Report6.Crt4.SetText Rpt_Text4
        Report6.Crt5.SetText Rpt_Text5
        Report6.Crt6.SetText Rpt_Text6
        Report6.Crt7.SetText Rpt_Text7
        CRViewer1.ReportSource = Report6

        CRViewer1.ViewReport
End Sub

Public Sub FVM_Gate_Report()
Dim Report7 As New FVM_Gate

    FVM_Gate.Database.SetDataSource SQLData
    FVM_Gate.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
         
    FVM_Gate.ReadRecords
'Get the sections from the Main report
'Report.DiscardSavedData
'Dim section As CRAXDDRT.Report
     Set Sections = Report7.Sections
     
'Go through each section in the main report...
     
     For Each Section In Sections
         
         'Get all the objects in this section...
         Set ReportObjects = Section.ReportObjects
         
         'Go through each object in the reportobjects for this section...
         For Each ReportObject In ReportObjects
             
             'Find the object which is the SubreportObject
             If ReportObject.Kind = crSubreportObject Then
                 
                 'Found a subreport, now get a hold of it
                 Set SubreportObject = ReportObject
                 
                 'Open the subreport and treat it as any other report
                 Set subreport = SubreportObject.OpenSubreport
             
             '----------------
                    subreport.Database.SetDataSource SQLData
                    subreport.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
                    If subreport.Database.Tables(1).location = "AFC_UnitTable" Then
                        subreport.Database.Tables(2).SetLogOnInfo "", "", "", "mbtadb"
                        subreport.Database.Tables(3).SetLogOnInfo "", "", "", "mbtadb"
                    End If
             '----------------
                 
             End If
         Next ReportObject
     Next Section
    CRViewer1.ReportSource = Report7
    CRViewer1.ViewReport

End Sub
Public Sub FVM_Gate_Detail()
Dim Report10 As New Equipment_Detail

    Equipment_Detail.Database.SetDataSource SQLData
    Equipment_Detail.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
    
    If Rpt_Group <> 0 Then
        Report10.Areas("GH").GroupConditionField = Report10.Database.Tables(1).Fields(Rpt_Group)
    End If
    If Rpt_Sort1 <> 0 Then
        Set crxDatabaseField1 = Report10.Database.Tables.item(1).Fields.item(Val(Rpt_Sort1))
        'Set the field to crxDatabaseField
        Report10.RecordSortFields.item(1).Field = crxDatabaseField1
        'Set the SortField direction
        Report10.RecordSortFields.item(1).SortDirection = crAscendingOrder
    End If
    If Rpt_Sort2 <> 0 Then
        Set crxDatabaseField2 = Report10.Database.Tables.item(1).Fields.item(Val(Rpt_Sort2))
        'Set the field to crxDatabaseField
        Report10.RecordSortFields.item(2).Field = crxDatabaseField2
        'Set the SortField direction
        Report10.RecordSortFields.item(2).SortDirection = crAscendingOrder
    End If

    Set CRXParamDefs = Report10.ParameterFields

        For Each CRXParamDef In CRXParamDefs
        With CRXParamDef

        Select Case .ParameterFieldName
        'It finds and sets the appropriate Crystal parameter.
'Now it finds and sets the appropriate stored procedure parameter.

        Case "@Device_String"
            .AddCurrentValue (Device_String)
        Case "@Rst"
            .AddCurrentValue (Rpt_Rst)
        Case "@Location"
            .AddCurrentValue (Subway)
        Case "Access_level"
            .AddCurrentValue Val(Current_User_Level)
        End Select
        End With
        Next
        Report10.EnableParameterPrompting = False
        

        Report10.Text3.SetText Rpt_Text1
        Report10.Text8.SetText Rpt_Text2
        Report10.Text9.SetText Rpt_Text3

    CRViewer1.EnableExportButton = True
    CRViewer1.ReportSource = Report10
    CRViewer1.ViewReport

End Sub
Public Sub First_4()
Dim Report8 As New First4_Orders

    First4_Orders.Database.SetDataSource SQLData
    First4_Orders.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"

    CRViewer1.EnableExportButton = True
    CRViewer1.ReportSource = Report8
    CRViewer1.ViewReport

End Sub
Public Sub INV_Reconcile()
Dim Report9 As New Inv_receipts_Reconcile

    Inv_receipts_Reconcile.Database.SetDataSource SQLData
    Inv_receipts_Reconcile.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
    
    Set CRXParamDefs = Report9.ParameterFields

    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef

        Select Case .ParameterFieldName
    'It finds and sets the appropriate Crystal parameter.
    'Now it finds and sets the appropriate stored procedure parameter.
        Case "Outstanding"
            .AddCurrentValue (Rpt_Outstanding)
        End Select
        End With
        Next

    CRViewer1.EnableExportButton = True
    CRViewer1.ReportSource = Report9
    CRViewer1.ViewReport

End Sub
Public Sub SB_Receipts_rpt()
Dim Report11 As New SB_Receipts
Dim Mine As Date

    SB_Receipts.Database.SetDataSource SQLData
    SB_Receipts.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
        
    Set CRXParamDefs = Report11.ParameterFields

    Mine = Format(Now, "short date")
    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef

        Select Case .ParameterFieldName
    'It finds and sets the appropriate Crystal parameter.
'Now it finds and sets the appropriate stored procedure parameter.
        Case "receiptdate"
            .AddCurrentValue Mine
        Case "Branch"
            .AddCurrentValue (Val(Current_User_Branch))
        End Select
        End With
        Next

    Report11.EnableParameterPrompting = False

    CRViewer1.EnableExportButton = True
    CRViewer1.ReportSource = Report11
    CRViewer1.ViewReport

End Sub
Public Sub Open_Damages_Rpt()
'Dim Report12 As New Open_Damages
    Set Outside_report = Application.OpenReport("\\Mbtasql\Sharing and Apps\Crystal_Reports\open_damages.rpt")
    Outside_report.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
    CRViewer1.ReportSource = Outside_report
    CRViewer1.ViewReport

    'Open_Damages.Database.SetDataSource SQLData
    'Report12.Database.Tables(1).SetLogOnInfo "", "", "mbta", "mbtadb"
    'Report12.Database.Tables(2).SetLogOnInfo "", "", "mbta", "mbtadb"
    'Report12.Database.Tables(3).SetLogOnInfo "", "", "mbta", "mbtadb"

    'CRViewer1.EnableExportButton = True
    'CRViewer1.ReportSource = Report12
    'CRViewer1.ViewReport
    
End Sub
Public Sub Location_Rpt()
Dim Report15 As New Inventory_By_Location

    'Inventory_By_Location.Database.SetDataSource SQLData
    Inventory_By_Location.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
    Inventory_By_Location.Database.Tables(2).SetLogOnInfo "", "", "", "mbtadb"
    Inventory_By_Location.Database.Tables(3).SetLogOnInfo "", "", "", "mbtadb"
        
    Set CRXParamDefs = Report15.ParameterFields

    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef

        Select Case .ParameterFieldName
        'It finds and sets the appropriate Crystal parameter.
'Now it finds and sets the appropriate stored procedure parameter.
        Case "LocationId"
            .AddCurrentValue Val(Rpt_Location)

        End Select
        End With
    Next

        Inventory_By_Location.EnableParameterPrompting = False

        'CRViewer1.EnableExportButton = True
        CRViewer1.ReportSource = Report15
        CRViewer1.ViewReport

End Sub
Public Sub Chris_Instruct()
Dim Report14 As New instructions

    CRViewer1.EnableExportButton = True
    CRViewer1.ReportSource = Report14
    CRViewer1.ViewReport

End Sub
Public Sub Receipts()
    Set Outside_report = Application.OpenReport("\\Mbtasql\Sharing and Apps\Crystal_Reports\receipt_register.rpt")
    Outside_report.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
    CRViewer1.ReportSource = Outside_report
    CRViewer1.ViewReport

End Sub

Public Sub CRS_Rpt()
    Set Outside_report = Application.OpenReport("\\Mbtasql\Sharing and Apps\Crystal_Reports\crs_status.rpt")
    Outside_report.Database.Tables(1).SetLogOnInfo "mbta_nwcd", "mbta", "mbta", "hallo"
    CRViewer1.ReportSource = Outside_report
    CRViewer1.ViewReport

End Sub
Public Sub Physical_List()
    Set Outside_report = Application.OpenReport("\\Mbtasql\Sharing and Apps\Crystal_Reports\physical.rpt")
    Outside_report.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"

    Set CRXParamDefs = Outside_report.ParameterFields

    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef

        Select Case .ParameterFieldName
        'It finds and sets the appropriate Crystal parameter.
        'Now it finds and sets the appropriate stored procedure parameter.

        Case "MyParameter"
            .AddCurrentValue (Val(Rpt_Location))
        End Select
        End With
    Next
        
    Outside_report.EnableParameterPrompting = False

    CRViewer1.ReportSource = Outside_report
    CRViewer1.ViewReport

End Sub
Public Sub Incident_Detail_rpt()
Dim Report16 As New Inc_Report
    If Rpt_Group <> 0 Then
        Report16.Areas("GH").GroupConditionField = Report16.Database.Tables(1).Fields(Rpt_Group)
        'Report16.Areas("GH").GroupConditionField = Report16.Database.Tables(1).Fields(65)
    End If
    If Rpt_Sort1 <> 0 Then
        Set crxDatabaseField1 = Report16.Database.Tables.item(1).Fields.item(Val(Rpt_Sort1))
        'Set the field to crxDatabaseField
        Report16.RecordSortFields.item(1).Field = crxDatabaseField1
        'Set the SortField direction
        Report16.RecordSortFields.item(1).SortDirection = crAscendingOrder
    End If
    If Rpt_Sort2 <> 0 Then
        Set crxDatabaseField2 = Report16.Database.Tables.item(1).Fields.item(Val(Rpt_Sort2))
        'Set the field to crxDatabaseField
        Report16.RecordSortFields.item(2).Field = crxDatabaseField2
        'Set the SortField direction
        Report16.RecordSortFields.item(2).SortDirection = crAscendingOrder
    End If

    'Set Outside_report = Application.OpenReport("\\Mbtasql\Sharing and Apps\Crystal_Reports\report3.rpt")
    Report16.Database.Tables(1).ConnectionProperties("Password") = "mbtadb"
    'Outside_report.Database.Tables(1).ConnectionProperties("Password") = "mbtadb"
        
    Set CRXParamDefs = Report16.ParameterFields
    'Set CRXParamDefs = Outside_report.ParameterFields

    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef

        Select Case .ParameterFieldName
        'It finds and sets the appropriate Crystal parameter.
        'Now it finds and sets the appropriate stored procedure parameter.

        Case "@Device_string"
            .AddCurrentValue (Device_String)
        Case "@Subway"
            .AddCurrentValue (Subway)
        Case "@Completed_by"
            .AddCurrentValue (Val(Completed_By))
        Case "@Created_by"
            .AddCurrentValue (Val(Created_By))
        Case "@Closed_by"
            .AddCurrentValue (Val(Closed_By))
        Case "@Arival"
            .AddCurrentValue (Arival)
        Case "@Defect"
            .AddCurrentValue (Defect)
        Case "@Action"
            .AddCurrentValue (Action)
        Case "@Date_created"
            .AddCurrentValue (Date_Created)
        Case "@Date_closed"
            .AddCurrentValue (Date_Closed)
        Case "@Replaced_Part"
            .AddCurrentValue (Val(Rpt_sPartno))
        Case "Summary"
            .AddCurrentValue (" ")
        End Select
        End With
    Next
    Report16.EnableParameterPrompting = False
    Report16.Text15.SetText Rpt_Text1
    Report16.Text22.SetText Rpt_Text2
    Report16.Text23.SetText Rpt_Text3
    Report16.Text24.SetText Rpt_Text4
    Report16.Text25.SetText Rpt_Text5
    Report16.Text16.SetText Rpt_Text6
    Report16.Text20.SetText Rpt_Text7
    Report16.Text51.SetText Rpt_Text11
    Report16.Text52.SetText Rpt_Text12
    Report16.Text58.SetText Rpt_Text13
    Report16.Text65.SetText Current_User_Id & " " & Current_User_Name
    If Current_User_Level = 9 Then
        Report16.Text40.SetText Rpt_Text8
        Report16.Text41.SetText Rpt_Text9
        Report16.Text42.SetText Rpt_Text10
    End If

    CRViewer1.ReportSource = Report16
    CRViewer1.ViewReport

End Sub

Public Sub Mean_Time_Rpt()

Dim Report17 As New Mean_Time
    If Rpt_Group <> 0 Then
        Report17.Areas("GH").GroupConditionField = Report16.Database.Tables(1).Fields(Rpt_Group)
        'Report16.Areas("GH").GroupConditionField = Report16.Database.Tables(1).Fields(65)
    End If
    If Rpt_Sort1 <> 0 Then
        Set crxDatabaseField1 = Report16.Database.Tables.item(1).Fields.item(Val(Rpt_Sort1))
        'Set the field to crxDatabaseField
        Report16.RecordSortFields.item(1).Field = crxDatabaseField1
        'Set the SortField direction
        Report16.RecordSortFields.item(1).SortDirection = crAscendingOrder
    End If
    If Rpt_Sort2 <> 0 Then
        Set crxDatabaseField2 = Report16.Database.Tables.item(1).Fields.item(Val(Rpt_Sort2))
        'Set the field to crxDatabaseField
        Report16.RecordSortFields.item(2).Field = crxDatabaseField2
        'Set the SortField direction
        Report16.RecordSortFields.item(2).SortDirection = crAscendingOrder
    End If

    Report16.Database.Tables(1).ConnectionProperties("Password") = "mbtadb"
        
    Set CRXParamDefs = Report16.ParameterFields

    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef

        Select Case .ParameterFieldName

        Case "@Device_string"
            .AddCurrentValue (Device_String)
        Case "@Subway"
            .AddCurrentValue (Subway)
        Case "@Completed_by"
            .AddCurrentValue (Val(Completed_By))
        Case "@Created_by"
            .AddCurrentValue (Val(Created_By))
        Case "@Closed_by"
            .AddCurrentValue (Val(Closed_By))
        Case "@Date_created"
            .AddCurrentValue (Date_Created)
        Case "@Date_closed"
            .AddCurrentValue (Date_Closed)
        Case "@Replaced_Part"
            .AddCurrentValue (Val(Rpt_sPartno))
        Case "Summary"
            .AddCurrentValue (" ")
        End Select
        End With
    Next
    Report16.EnableParameterPrompting = False
    Report16.Text15.SetText Rpt_Text1
    Report16.Text22.SetText Rpt_Text2
    Report16.Text23.SetText Rpt_Text3
    Report16.Text24.SetText Rpt_Text4
    Report16.Text25.SetText Rpt_Text5
    Report16.Text16.SetText Rpt_Text6
    Report16.Text20.SetText Rpt_Text7
    Report16.Text51.SetText Rpt_Text11
    Report16.Text52.SetText Rpt_Text12
    Report16.Text58.SetText Rpt_Text13
    Report16.Text65.SetText Current_User_Id & " " & Current_User_Name
    If Current_User_Level = 9 Then
        Report16.Text40.SetText Rpt_Text8
        Report16.Text41.SetText Rpt_Text9
        Report16.Text42.SetText Rpt_Text10
    End If

    CRViewer1.ReportSource = Report16
    CRViewer1.ViewReport
End Sub
Public Sub Incident_Totals_Rpt()
'Dim Report17 As New Incident_Counts


    Set Outside_report = Application.OpenReport("\\Mbtasql\Sharing and Apps\Crystal_Reports\Incident_Counts.rpt")
    'Report17.Database.Tables(1).ConnectionProperties("Password") = "mbtadb"
    Outside_report.Database.Tables(1).ConnectionProperties("Password") = "mbtadb"
        
    'Set CRXParamDefs = Report17.ParameterFields
    Set CRXParamDefs = Outside_report.ParameterFields

    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef

        Select Case .ParameterFieldName
        'It finds and sets the appropriate Crystal parameter.
        'Now it finds and sets the appropriate stored procedure parameter.

        Case "@Device_string"
            .AddCurrentValue (Device_String)
        Case "@Subway"
            .AddCurrentValue (Subway)
        Case "@Completed_by"
            .AddCurrentValue (Val(Completed_By))
        Case "@Created_by"
            .AddCurrentValue (Val(Created_By))
        Case "@Closed_by"
            .AddCurrentValue (Val(Closed_By))
        Case "@Arival"
            .AddCurrentValue (Arival)
        Case "@Defect"
            .AddCurrentValue (Defect)
        Case "@Action"
            .AddCurrentValue (Action)
        Case "@Date_created"
            .AddCurrentValue (Date_Created)
        Case "@Date_closed"
            .AddCurrentValue (Date_Closed)
        Case "@Replaced_Part"
            .AddCurrentValue (Val(Rpt_sPartno))
        Case "Group1_val"
            .AddCurrentValue (Val(Rpt_Group1))
        Case "Group2_val"
            .AddCurrentValue (Val(Rpt_Group2))
        Case "Group3_val"
            .AddCurrentValue (Val(Rpt_Group3))
        Case "Group4_val"
            .AddCurrentValue (Val(Rpt_Group4))
        Case "Group1_order"
            .AddCurrentValue (Val(Rpt_Group1_order))
        Case "Group2_order"
            .AddCurrentValue (Val(Rpt_Group2_order))
        Case "Group3_order"
            .AddCurrentValue (Val(Rpt_Group3_order))
        Case "Group4_order"
            .AddCurrentValue (Val(Rpt_Group4_order))
        End Select
        End With
    Next
    'If Rpt_Group2 = 0 And Rpt_Group3 = 0 And Rpt_Group4 = 0 Then
     '   Report17.ReportHeaderSection1("GroupHeaderSection1").sectionformat.enablesupress = True
    
    'End If
    Outside_report.EnableParameterPrompting = False

    
    'Report17.Text1.SetText Rpt_Text1
    'Report17.Text2.SetText Rpt_Text2
    'Report17.Text3.SetText Rpt_Text3
    'Report17.Text4.SetText Rpt_Text4
    'Report17.Text5.SetText Rpt_Text5
    'Report17.Text6.SetText Rpt_Text6
    'Report17.Text7.SetText Rpt_Text7
    'Report17.Text8.SetText Rpt_Text13
    'Report17.Text9.SetText Rpt_Text11
'    Report17.Text10.SetText Rpt_Text11
'    If Current_User_Level = 9 Then
'        Report16.Text40.SetText Rpt_Text8
'        Report16.Text41.SetText Rpt_Text9
'        Report16.Text42.SetText Rpt_Text10
'    End If

    CRViewer1.ReportSource = Outside_report
    CRViewer1.ViewReport
End Sub
Private Sub Form_Resize()
CRViewer1.Top = 0
CRViewer1.Left = 0
CRViewer1.Height = ScaleHeight
CRViewer1.Width = ScaleWidth

End Sub

Private Sub Form_Unload(Cancel As Integer)
    Set Outside_report = Nothing
    Set Report = Nothing
    Set Report1 = Nothing
    Set Report2 = Nothing
    Set Report3 = Nothing
    Set Report4 = Nothing
    Set Report5 = Nothing
    Set Report6 = Nothing
    Set Report7 = Nothing
    Set Report8 = Nothing
    Set Report9 = Nothing
    Set Report10 = Nothing
    Set Report11 = Nothing
    Set Report12 = Nothing
    Set Report15 = Nothing
    Set Report14 = Nothing
    Set Report16 = Nothing
    Set Report17 = Nothing

End Sub
