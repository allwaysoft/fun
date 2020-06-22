Attribute VB_Name = "moddb"
Option Explicit
' recordsets and db connextions
'Public Const SQL_DSN = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=sa;Initial Catalog=dbCCRDSTAGE;Data Source=TESTBED\SQLSVRT1;"
'Public Const SQL_DSN_LOCAL = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=sa;Initial Catalog=MBTA;Data Source=(local);"
'Public Const SQL_DSN_LOCAL = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=mbta;Initial Catalog=MBTA;Data Source=ref14684\mba_test;"
'Public Const SQL_DSN_LIVE = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=mbta;Password=mbtadb;Initial Catalog=mbta2;Data Source=mbtasql\SQLSVR1;"

Public SQLData As ADODB.Connection
Public ORAdata As ADODB.Connection
Public RSWork As ADODB.Recordset


Public sSql As String
Public Vdate As Date
Public St_Date As Date
Public End_Date As Date


    

Public Sub Main()
    

    Set SQLData = New ADODB.Connection
    SQLData.Open "dsn=MBTA2005", "mbta", "mbtadb"

    Set ORAdata = New ADODB.Connection
    'ORAdata.Open "dsn=mbta_nwcd", "mbta", "hallo"
    ORAdata.Open "dsn=mbta_nwcd_dw", "mbta", "hallo"

    Frm_Export.Show vbModal
    

End Sub


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


