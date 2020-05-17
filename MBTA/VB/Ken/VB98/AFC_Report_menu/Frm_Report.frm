VERSION 5.00
Object = "{FB992564-9055-42B5-B433-FEA84CEA93C4}#11.0#0"; "crviewer.dll"
Begin VB.Form Frm_Report 
   Caption         =   "Report Viewer"
   ClientHeight    =   10950
   ClientLeft      =   60
   ClientTop       =   465
   ClientWidth     =   15045
   LinkTopic       =   "Form1"
   ScaleHeight     =   10950
   ScaleWidth      =   15045
   Begin CrystalActiveXReportViewerLib11Ctl.CrystalActiveXReportViewer CRviewer1 
      Height          =   10695
      Left            =   120
      TabIndex        =   0
      Top             =   240
      Width           =   14895
      _cx             =   26273
      _cy             =   18865
      DisplayGroupTree=   -1  'True
      DisplayToolbar  =   -1  'True
      EnableGroupTree =   -1  'True
      EnableNavigationControls=   -1  'True
      EnableStopButton=   -1  'True
      EnablePrintButton=   -1  'True
      EnableZoomControl=   -1  'True
      EnableCloseButton=   -1  'True
      EnableProgressControl=   0   'False
      EnableSearchControl=   -1  'True
      EnableRefreshButton=   -1  'True
      EnableDrillDown =   -1  'True
      EnableAnimationControl=   -1  'True
      EnableSelectExpertButton=   0   'False
      EnableToolbar   =   -1  'True
      DisplayBorder   =   -1  'True
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
Attribute VB_Name = "Frm_Report"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim Application As New CRAXDRT.Application
Dim Outside_report As New CRAXDRT.Report

Dim crxDatabaseField1 As CRAXDRT.DatabaseFieldDefinition
Dim crxDatabaseField2 As CRAXDRT.DatabaseFieldDefinition
Dim crxDatabaseField3 As CRAXDRT.DatabaseFieldDefinition

Dim CRXParamDefs As CRAXDRT.ParameterFieldDefinitions
Dim CRXParamDef As CRAXDRT.ParameterFieldDefinition
Dim CRXSubreport As CRAXDRT.Report
Dim DA_Report As New CrystalReport1

Dim Report As New New_Incident_Counts





Private Sub Form_Load()
    Screen.MousePointer = vbHourglass

    Select Case Report_Name
    Case "Availibility"     'DeviceAvailibility
        Call Device_Availability_Report
    Case "Incident_Counts"
        Call Incident_Count_Report
    Case "Money Status"
        Call Money_Status_Report
    Case "DateLastVaulted"
        Call Datelastvaulted
    Case "FareBox"
        Call FareBox
    End Select
    Screen.MousePointer = vbDefault

End Sub

Private Sub FareBox()
    Set Outside_report = Application.OpenReport("\\Mbtasql\Sharing and Apps\Crystal_Reports\Farebox_probing.rpt")
    Outside_report.Database.SetDataSource SQLData
    Outside_report.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
    'CRviewer1.ReportSource = Outside_report
    'CRviewer1.ViewReport


'    Outside_report.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
    
    Set CRXParamDefs = Outside_report.ParameterFields
    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef
        Select Case .ParameterFieldName
            Case "ReportType"
                .AddCurrentValue Val(Prob_Flag)
            Case "Check_7"
                .AddCurrentValue Val(0)
            End Select
        End With
    Next
    Outside_report.EnableParameterPrompting = False

    CRviewer1.ReportSource = Outside_report
    CRviewer1.ViewReport

End Sub

Private Sub Device_Availability_Report()
    
    
    'Set Outside_report = Application.OpenReport("\\Mbtasql\Sharing and Apps\Crystal_Reports\Device_Availability_All_Seperate.rpt")
    'Outside_report.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
    'CRviewer1.ReportSource = Outside_report
    'CRviewer1.ViewReport


    DA_Report.Database.SetDataSource SQLData
    DA_Report.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
    
    Set CRXParamDefs = DA_Report.ParameterFields
    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef
        Select Case .ParameterFieldName
            Case "StartDate"
                .AddCurrentValue (St_Date)
            Case "EndDate"
                .AddCurrentValue (End_Date)
            Case "StartHour"
                .AddCurrentValue CLng(StHour)
            Case "EndHour"
                .AddCurrentValue CLng(EndHour)
            End Select
        End With
    Next
    DA_Report.EnableParameterPrompting = False

    CRviewer1.ReportSource = DA_Report
    CRviewer1.ViewReport




End Sub
Private Sub Money_Status_Report()
    Set Outside_report = Application.OpenReport("\\Mbtasql\Sharing and Apps\Crystal_Reports\MoneyStatusReport.rpt")
    Outside_report.Database.Tables(1).SetLogOnInfo "", "", "", "hallo"
    CRviewer1.ReportSource = Outside_report
    CRviewer1.ViewReport

End Sub

Private Sub Datelastvaulted()
    Set Outside_report = Application.OpenReport("\\Mbtasql\Sharing and Apps\Crystal_Reports\DateLastVaulted.rpt")
    Outside_report.Database.Tables(1).SetLogOnInfo "", "", "", "hallo"
    CRviewer1.ReportSource = Outside_report
    CRviewer1.ViewReport

End Sub

Private Sub Form_Unload(Cancel As Integer)
    Set Report = Nothing
    Set DA_Report = Nothing
    Set Outside_report = Nothing

End Sub

Public Sub Incident_Count_Report()


'Go through each section in the main report...

    Report.Database.SetDataSource SQLData
    Report.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
    Report.EnableParameterPrompting = False
    
    Set CRXParamDefs = Report.ParameterFields
    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef
        Select Case .ParameterFieldName
            Case "St_Date"
                .AddCurrentValue (St_Date)
            Case "End_Date"
                .AddCurrentValue (End_Date)
            Case "Branch"
                .AddCurrentValue CLng(R_Branch)
            Case "St_Device"
                .AddCurrentValue (St_Device)
            Case "End_Device"
                .AddCurrentValue (End_Device)
            End Select
        End With
    Next
    
    
Report.Text4.SetText "Date Range: From " & St_Date & " thru " & End_Date
Report.Text5.SetText String1
Report.Text3.SetText "Incident Counts By Device Type"
    CRviewer1.ReportSource = Report
    CRviewer1.ViewReport

End Sub

