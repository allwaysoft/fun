Attribute VB_Name = "Moddb"
Option Explicit

Public SQLdata As ADODB.Connection
Public ORAdata As ADODB.Connection
Public RsWork As ADODB.Recordset
Public RsWork2 As ADODB.Recordset
Public checkit As Long
Public sSql As String
Public Comp_Name
Public User_Name 'contained in the Windows shell
Public ExpOption As Long
Public MappedLetter As String
Public UpDowncount As Long
Public sline As String
Public Inputcheck As Boolean
Public myloop As Integer

Public Sub Main()
    Dim mydate As Date
    mydate = "01/01/1970 00:00:01"
    
    'mydate = mydate + second(1259643600)
    'mydate = "01/12/2009"
    
    'mydate = DateAdd("d", 280, mydate)
    'mydate = "12/01/2009"
    
    'mydate = mydate + second(1259643600)
    'mydate = DateAdd("s", 1257033599, mydate)
    
    'mydate = "01/01/1970"
    
    'mydate = mydate + second(1259643600)
    'mydate = DateAdd("s", 1956441600, mydate)
    
    Comp_Name = PGBLGetComputer_Name
    User_Name = PGBLGetUser_Name
    
    Set ORAdata = New ADODB.Connection
    ORAdata.Open "dsn=mbta_NWCD", "mbta", "hallo"
    'ORAdata.Open "dsn=mbta_NWCD_test", "mbta", "hallo"

    Set SQLdata = New ADODB.Connection
    SQLdata.Open "dsn=MBTA2005", "mbta", "mbtadb"
    checkit = PGBLPrevInstance
    If checkit = 1 Then
        PGBLActivatePrevInstance
    End If

    Frm_Main.Show vbModal
    
End Sub

