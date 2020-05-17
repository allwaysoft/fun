Attribute VB_Name = "Main_Module"
Option Explicit

Public SQLData As ADODB.Connection
Public ORAData As ADODB.Connection

Public RSwork As ADODB.Recordset
Public RSData As ADODB.Recordset

Public sSql As String

Dim Startdate As String
Dim Enddate As String
Dim Enddate1 As String



Public Sub Main()
    
    ' need to kill the first 1089 records in device availability table next week
    
    Set SQLData = New ADODB.Connection
    'SQLData.Open "dsn=MBTACopy", "mbta", "mbtadb"
    SQLData.Open "dsn=MBTA2005", "mbta", "mbtadb"
    'SQLData.Open "dsn=local2005", "mbta", "mbtadb"
    
    Frm_main.Show vbModal
    SQLData.Close
    Set SQLData = Nothing

End Sub
