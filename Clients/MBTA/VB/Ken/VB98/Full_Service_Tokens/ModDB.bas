Attribute VB_Name = "ModDB"
Option Explicit

' recordsets and db connextions
'Public Const SQL_DSN = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=sa;Initial Catalog=dbCCRDSTAGE;Data Source=TESTBED\SQLSVRT1;"
'Public Const SQL_DSN_LOCAL = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=sa;Initial Catalog=MBTA;Data Source=(local);"
'Public Const SQL_DSN_LOCAL = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=mbta;Initial Catalog=MBTA;Data Source=ref14684\mba_test;"
'Public Const SQL_DSN_LIVE = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=mbta;Password=mbtadb;Initial Catalog=mbta2;Data Source=mbtasql\SQLSVR1;"

Public SQLDataTO As ADODB.Connection
Public SQLData As ADODB.Connection
Public ORAData As ADODB.Connection
Public Work As ADODB.Recordset

Public RS_Work As ADODB.Recordset
Public sSql






Public Sub Main()


    
    Set SQLData = New ADODB.Connection
    'SQLData.Open "dsn=MBTA2005c", "mbta", "mbtadb"
    SQLData.Open "dsn=MBTA2005", "mbta", "mbtadb"
    'SQLData.Open "dsn=local2005", "mbta", "mbtadb"

    Set ORAData = New ADODB.Connection
    ORAData.Open "dsn=mbta_nwcd", "mbta", "hallo"
    'ORAData.Open "dsn=mbta_nwcd_dw", "mbta", "hallo"
    'ORAData.Open "dsn=mbta_nwcd_test", "mbta", "hallo"
    Call Get_Tokens
    Call Compare_Tokens
    SQLData.Close
    Set SQLData = Nothing
    
End Sub


Public Sub Get_Tokens()
    sSql = "update fullservicetokens set TokenCountPrior = TokenCountcurrent, TokenPollPrior = TokenPollcurrent"
    SQLData.Execute (sSql)
    
    sSql = "update fullservicetokens set TokenCountcurrent =0, TokenPollcurrent = '" & Now & "'"
    SQLData.Execute (sSql)
    
    
    sSql = "SELECT deviceid, numberpieces, creadate FROM ActMoneycontainercontentsum  WHERE typeofcounter = 2 and " & _
            " moneycontainertype = 1 AND paymenttypevalue = 125 ORDER BY deviceid "
    Set RS_Work = New ADODB.Recordset
    Set RS_Work = ORAData.Execute(sSql)
    
    Do While RS_Work.EOF = False
        sSql = "update fullservicetokens set TokenCountcurrent =" & RS_Work("numberpieces") & _
        ",TokenPollcurrent = '" & RS_Work("creadate") & "' where tvmid = " & RS_Work("deviceid")
        SQLData.Execute (sSql)
        RS_Work.MoveNext
    Loop
    
RS_Work.Close
Set RS_Work = Nothing
ORAData.Close
Set ORAData = Nothing

End Sub


Public Sub Compare_Tokens()

Dim sFileText As String
Dim iFileNo As Integer

    iFileNo = FreeFile
    'open the file for writing
    sFileText = "X:\tokens" & Now & ".txt"
    sFileText = Replace(sFileText, ":", "-")
    sFileText = Replace(sFileText, "/", "-")
    sFileText = Replace(sFileText, "X-", "X:")
    Open sFileText For Output As #iFileNo

    sSql = "select tvmid, al_location_name, tokencountprior, tokencountcurrent from fullservicetokens left outer join afc_unittable on au_mbtano = vartvmid " & _
    "left outer join afc_location on au_location = al_id where tokencountcurrent - tokencountprior > 5"
    
    Set RS_Work = New ADODB.Recordset
    Set RS_Work = SQLData.Execute(sSql)
    
    Do While RS_Work.EOF = False
        Print #iFileNo, RS_Work("tvmid") & "  " & RS_Work("al_location_name") & "  " & RS_Work("tokencountcurrent") - RS_Work("tokencountprior") & vbCrLf
        RS_Work.MoveNext
    Loop
    
    Close #iFileNo
End Sub



