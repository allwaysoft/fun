Attribute VB_Name = "Module1"
Option Explicit

Public SQLDataTO As ADODB.Connection
Public SQLData As ADODB.Connection

Public RS_Work As ADODB.Recordset
Public ssql As String
Public Report_Name
Public vdate As Date

Dim Application As New CRAXDRT.Application
Dim Outside_Report As New CRAXDRT.Report
Dim CRXParamDefs As CRAXDRT.ParameterFieldDefinitions
Dim CRXParamDef As CRAXDRT.ParameterFieldDefinition




Public Sub Main()
    'Set SQLData = New ADODB.Connection
    'SQLData.Open "dsn=MBTA2005", "mbta", "mbtadb"

    Call Produce_Bus_Report
    Set Outside_Report = Nothing
    Call Produce_Bus_7_Day_Report
    Set Outside_Report = Nothing
    Call Mail_Bus_Report
    
    Call Produce_GL_Report
    Set Outside_Report = Nothing
    Call Produce_GL_7_Day_Report
    Set Outside_Report = Nothing
    Call Mail_GL_Report
    
    'SQLData.Close
    'Set SQLData = Nothing

End Sub

Public Sub Produce_Bus_Report()
'D:\Sharing and Apps\Crystal_Reports
    Set Outside_Report = Application.OpenReport("d:\Sharing and Apps\Crystal_Reports\Farebox_probing.rpt")
    'Set Outside_Report = Application.OpenReport("\\mbtasql\Sharing and Apps\Crystal_Reports\Farebox_probing.rpt")

    Outside_Report.Database.SetDataSource SQLData
    Outside_Report.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
    
    Set CRXParamDefs = Outside_Report.ParameterFields
    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef
        Select Case .ParameterFieldName
            Case "ReportType"
                .AddCurrentValue Val(1)
            Case "Check_7"
                .AddCurrentValue Val(0)

            End Select
        End With
    Next
    Outside_Report.EnableParameterPrompting = False

    Outside_Report.EnableParameterPrompting = False
    'Outside_Report.ExportOptions.DiskFileName = "D:\Bus_report.pdf"
    'Outside_Report.ExportOptions.FormatType = crEFTPortableDocFormat
    
    Outside_Report.ExportOptions.DestinationType = crEDTDiskFile
    Outside_Report.ExportOptions.DiskFileName = "D:\Bus_report.xls"
    Outside_Report.ExportOptions.FormatType = crEFTExcelDataOnly
    Outside_Report.Export False

End Sub
Public Sub Produce_Bus_7_Day_Report()
'D:\Sharing and Apps\Crystal_Reports
    Set Outside_Report = Application.OpenReport("d:\Sharing and Apps\Crystal_Reports\Farebox_probing.rpt")
    'Set Outside_Report = Application.OpenReport("\\mbtasql\Sharing and Apps\Crystal_Reports\Farebox_probing.rpt")

    Outside_Report.Database.SetDataSource SQLData
    Outside_Report.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
    
    Set CRXParamDefs = Outside_Report.ParameterFields
    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef
        Select Case .ParameterFieldName
            Case "ReportType"
                .AddCurrentValue Val(1)
            Case "Check_7"
                .AddCurrentValue Val(1)
            End Select
        End With
    Next
    Outside_Report.EnableParameterPrompting = False

    Outside_Report.EnableParameterPrompting = False
    'Outside_Report.ExportOptions.DiskFileName = "D:\Bus_report.pdf"
    'Outside_Report.ExportOptions.FormatType = crEFTPortableDocFormat
    
    Outside_Report.ExportOptions.DestinationType = crEDTDiskFile
    Outside_Report.ExportOptions.DiskFileName = "D:\Bus_report_7_day.xls"
    Outside_Report.ExportOptions.FormatType = crEFTExcelDataOnly
    Outside_Report.Export False

End Sub

Public Sub Produce_GL_Report()

'D:\Sharing and Apps\Crystal_Reports
    Set Outside_Report = Application.OpenReport("d:\Sharing and Apps\Crystal_Reports\Farebox_probing.rpt")
    'Set Outside_Report = Application.OpenReport("\\mbtasql\Sharing and Apps\Crystal_Reports\Farebox_probing.rpt")

    Outside_Report.Database.SetDataSource SQLData
    Outside_Report.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
    
    Set CRXParamDefs = Outside_Report.ParameterFields
    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef
        Select Case .ParameterFieldName
            Case "ReportType"
                .AddCurrentValue Val(2)
            Case "Check_7"
                .AddCurrentValue Val(0)
            End Select
        End With
    Next
    Outside_Report.EnableParameterPrompting = False

    Outside_Report.EnableParameterPrompting = False
    'Outside_Report.ExportOptions.DiskFileName = "D:\GL_report.pdf"
    'Outside_Report.ExportOptions.FormatType = crEFTPortableDocFormat
    
    Outside_Report.ExportOptions.DestinationType = crEDTDiskFile
    Outside_Report.ExportOptions.DiskFileName = "D:\GL_report.xls"
    Outside_Report.ExportOptions.FormatType = crEFTExcelDataOnly
    
    Outside_Report.Export False


End Sub
Public Sub Produce_GL_7_Day_Report()

'D:\Sharing and Apps\Crystal_Reports
    Set Outside_Report = Application.OpenReport("d:\Sharing and Apps\Crystal_Reports\Farebox_probing.rpt")
    'Set Outside_Report = Application.OpenReport("\\mbtasql\Sharing and Apps\Crystal_Reports\Farebox_probing.rpt")

    Outside_Report.Database.SetDataSource SQLData
    Outside_Report.Database.Tables(1).SetLogOnInfo "", "", "", "mbtadb"
    
    Set CRXParamDefs = Outside_Report.ParameterFields
    For Each CRXParamDef In CRXParamDefs
        With CRXParamDef
        Select Case .ParameterFieldName
            Case "ReportType"
                .AddCurrentValue Val(2)
            Case "Check_7"
                .AddCurrentValue Val(1)
            End Select
        End With
    Next
    Outside_Report.EnableParameterPrompting = False

    Outside_Report.EnableParameterPrompting = False
    'Outside_Report.ExportOptions.DiskFileName = "D:\GL_report.pdf"
    'Outside_Report.ExportOptions.FormatType = crEFTPortableDocFormat
    
    Outside_Report.ExportOptions.DestinationType = crEDTDiskFile
    Outside_Report.ExportOptions.DiskFileName = "D:\GL_report_7_Day.xls"
    Outside_Report.ExportOptions.FormatType = crEFTExcelDataOnly
    
    Outside_Report.Export False


End Sub

Public Sub Mail_Bus_Report()

Dim lobj_cdomsg As CDO.Message
Set lobj_cdomsg = New CDO.Message
'Add the Project Reference Miscrosoft CDO WINDOWS FOR 2000
'lobj_cdomsg.Configuration.Fields(cdoSMTPServer)="102.16.100.189"
lobj_cdomsg.Configuration.Fields(cdoSMTPServer) = "131.108.45.23"
lobj_cdomsg.Configuration.Fields(cdoSMTPConnectionTimeout) = 30
lobj_cdomsg.Configuration.Fields(cdoSendUsingMethod) = cdoSendUsingPort
lobj_cdomsg.Configuration.Fields.Update

lobj_cdomsg.To = "KCastonguay@mbta.com;RCreedon@mbta.com; EWaaramaa@mbta.com; JCheney@mbta.com; JConnolly@mbta.com; JDArcangelo@mbta.com; JKelley@mbta.com; KMcGuire@mbta.com; MDullea@mbta.com; JFolk@mbta.com; MHarrigan@mbta.com; PHennigan@mbta.com; RHoyt@mbta.com; TArmstrong@mbta.com; tellerbee@mbta.com"
lobj_cdomsg.CC = "dhinds@mbta.com; ko'brien@nbta.com; jmwhite@mbta.com; wrose@mbta.com; wstellberger@mbta.com; kmeagher@mbta.com; " & _
"pbarrett@mbta.com; cchan@mbta.com; llawson@mbta.com; mle@mbta.com; tellerbee@mbta.com; ekehoe@mbta.com; kpetit@mbta.com; " & _
"fhill@mbta.com; bhinds@mbta.com; mdally@mbta.com; mspolsino@mbta.com; jmccarthy@mbta.com; hsumner@mbta.com; rbartlett@mbta.com; " & _
"tcollins@mbta.com; rhiggins@mbta.com; jpierre@mbta.com; fgreeley@mbta.com; tquinlan@mbta.com; rgreen@mbta.com; " & _
"wlydon@mbta.com; msheehan@mbta.com; dsoule@mbta.com; jcolameco@mbta.com; sbadohu@mbta.com; cellis@mbta.com; jnelson@mbta.com; " & _
"tswanwick@mbta.com; bjackson@mbta.com; ksiris@mbta.com; mnorman@mbta.com; dkopp@mbta.com; tathanasiou@mbta.com; " & _
"rsmith@mbta.com; jbranche@mbta.com; rwalter@mbta.com; slariviere@mbta.com; cmartin@mbta.com; wbuckley@mbta.com; " & _
"vdimercurio@mbta.com; rvitale@mbta.com; kchambers@mbta.com; schambers@mbta.com; kmitrano@mbta.com; pcassetta@mbta.com; " & _
"khayes@mbta.com; rmceldowney@mbta.com; rrogers@mbta.com"
lobj_cdomsg.From = "kcastonguay@mbta.com"
lobj_cdomsg.Subject = "Bus farebox polling report"
lobj_cdomsg.TextBody = "Bus farebox polling attached"
lobj_cdomsg.AddAttachment ("D:\Bus_report.xls")
lobj_cdomsg.AddAttachment ("D:\Bus_report_7_day.xls")
lobj_cdomsg.Send
Set lobj_cdomsg = Nothing


End Sub
Public Sub Mail_GL_Report()

Dim lobj_cdomsg As CDO.Message
Set lobj_cdomsg = New CDO.Message
'Add the Project Reference Miscrosoft CDO WINDOWS FOR 2000
'lobj_cdomsg.Configuration.Fields(cdoSMTPServer)="102.16.100.189"
lobj_cdomsg.Configuration.Fields(cdoSMTPServer) = "131.108.45.23"
lobj_cdomsg.Configuration.Fields(cdoSMTPConnectionTimeout) = 30
lobj_cdomsg.Configuration.Fields(cdoSendUsingMethod) = cdoSendUsingPort
lobj_cdomsg.Configuration.Fields.Update
lobj_cdomsg.To = "KCastonguay@mbta.com; Rcreedon@mbta.com; DGies@mbta.com; JCheney@mbta.com; BDwyer@mbta.com; EWaaramaa@mbta.com;KMcGuire@mbta.com; JConnolly@mbta.com; ABarry@mbta.com; JDArcangelo@mbta.com; JKelley@mbta.com; MDullea@mbta.com; PHennigan@mbta.com; QScott@mbta.com; RHoyt@mbta.com; SAdkins@mbta.com; TArmstrong@mbta.com"
lobj_cdomsg.CC = "agordon@mbta.com; ccassino@mbta.com; qscott@mbta.com; mfong@mbta.com; folson@mbta.com; frausa@mbta.com; smckeon@mbta.com; kevino'brien@mbta.com; "
lobj_cdomsg.From = "KCastonguay@mbta.com"
lobj_cdomsg.Subject = "Green Line farebox polling report"
lobj_cdomsg.TextBody = "Green Line farebox polling attached"
lobj_cdomsg.AddAttachment ("D:\GL_Report.xls")
lobj_cdomsg.AddAttachment ("D:\GL_Report_7_Day.xls")
lobj_cdomsg.Send
Set lobj_cdomsg = Nothing


End Sub


