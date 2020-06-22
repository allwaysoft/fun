Attribute VB_Name = "ModDB"
Option Explicit

' recordsets and db connextions
'Public Const SQL_DSN = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=sa;Initial Catalog=dbCCRDSTAGE;Data Source=TESTBED\SQLSVRT1;"
'Public Const SQL_DSN_LOCAL = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=sa;Initial Catalog=MBTA;Data Source=(local);"
'Public Const SQL_DSN_LOCAL = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=mbta;Initial Catalog=MBTA;Data Source=ref14684\mba_test;"
'Public Const SQL_DSN_LIVE = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=mbta;Password=mbtadb;Initial Catalog=mbta2;Data Source=mbtasql\SQLSVR1;"

Public SQLDataTO As ADODB.Connection
Public SQLData As ADODB.Connection

Public RS_Work As ADODB.Recordset
Public ssql As String
Public Report_Name
Public vdate As Date
Public PW_Option As String
' report variables
Public String1 As String
Public Current_User_Index As Long
Public Current_User_Id As Long
Public Current_User_Name As String
Public Current_User_Level As Long
Public Current_User_Branch As Long
Public PGBLprogname As String
Public St_Date As Date
Public End_Date As Date
Public St_Device As String
Public End_Device As String
Public R_Branch As Integer

Private Declare Function GetComputerName Lib "kernel32" Alias "GetComputerNameA" (ByVal lpbuffer As String, nSize As Long) As Long
Private Declare Function GetUserName Lib "advapi32.dll" Alias "GetUserNameA" (ByVal lpbuffer As String, nSize As Long) As Long
Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long


Public Sub Main()


        'GetComputer_Name
        'GetUser_Name
    
        Set SQLData = New ADODB.Connection
        'SQLData.Open "dsn=MBTA2005c", "mbta", "mbtadb"
        SQLData.Open "dsn=MBTA2005", "mbta", "mbtadb"
        'SQLData.Open "dsn=local2005", "mbta", "mbtadb"
        'checkit = PGBLPrevInstance
        'If checkit = 1 Then
        '    PGBLActivatePrevInstance
        'End If
    


    Frm_Menu.Show vbModal
    SQLData.Close
    Set SQLData = Nothing
    
End Sub

Public Function Calendar_date(Pass_Date As String) As Date

    If Not IsDate(Pass_Date) Then
        vdate = Date - 1
    Else
        vdate = Pass_Date
    End If
    Call Frm_Calendar.SetStartDate(vdate)
startit:
    Frm_Calendar.Show vbModal
    vdate = Frm_Calendar.GetDate
    If IsDate(vdate) = True Then
        If vdate > Date Then
            If (MsgBox("Date Cannot be greater than Todays date", vbRetryCancel) = vbRetry) Then
                GoTo startit
            Else
                Exit Function
            End If
        End If
        Calendar_date = Format(vdate, "MM/DD/YYYY")
    End If

End Function
