Attribute VB_Name = "Module1"
Option Explicit

Public SQLDataTO As ADODB.Connection
Public SQLData As ADODB.Connection
Public OraData As ADODB.Connection

Public RS_Work As ADODB.Recordset
Public ssql As String
Public Report_Name
Public vdate As Date

Dim Application As New CRAXDRT.Application
Dim Outside_Report As New CRAXDRT.Report
Dim CRXParamDefs As CRAXDRT.ParameterFieldDefinitions
Dim CRXParamDef As CRAXDRT.ParameterFieldDefinition




Public Sub Main()
    Set SQLData = New ADODB.Connection
    SQLData.Open "dsn=MBTA2005", "mbta", "mbtadb"

    Set OraData = New ADODB.Connection
    OraData.Open "dsn=MBTA_nwcd", "mbta", "hallo"
    
    Set SQLData = New ADODB.Connection
    SQLData.Open "dsn=MBTA_nwcd_dw", "mbta", "hallo"


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

lobj_cdomsg.To = "KCastonguay@mbta.com"
lobj_cdomsg.CC = "This message is to inform you that the recurring charge for your Monthly Link Pass on CharlieCard serial number ########## will be charged to the account ####-####-####-1234 on the 10th business day from the 16th of September"
lobj_cdomsg.From = "kcastonguay@mbta.com"
lobj_cdomsg.Subject = "Bus farebox polling report"
lobj_cdomsg.TextBody = "Bus farebox polling attached"
lobj_cdomsg.AddAttachment ("D:\Bus_report.xls")
lobj_cdomsg.AddAttachment ("D:\Bus_report_7_day.xls")
lobj_cdomsg.Send
Set lobj_cdomsg = Nothing


End Sub


