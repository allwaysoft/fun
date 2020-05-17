Attribute VB_Name = "BatchDispatchMod"
Option Explicit

Public Const LTA_GET_SUMM_ABS_TO_REPLACE As String = "GetSummAbsToRepl"

Public Const LTA_GET_ABS_TYPES_FOR_ABS_TO_REPL As String = "GetAbsTypesForAbsToReplace"
    Public Const LTPA_GET_ABS_TYPES_FOR_ABS_TO_REPL_EMP As String = "emp"
    Public Const LTPA_GET_ABS_TYPES_FOR_ABS_TO_REPL_DATE As String = "date"

Public Const NUM_PROCESSES As Long = 5

Private mSys As A2System
Private mApp As A2App

Public Sub Main()
    
    Dim ds As A2IDataSource
    Set ds = New A2SQLDataSource
    ds.ConnectionString = "Provider=sqloledb;Data Source=TIMETEST;Initial Catalog=attend2"
    Set mApp = New A2App
    mApp.Logon ds, "TKSIMP", "doggers"
    Set mSys = mApp.System
    
    If InStr(1, "" & Interaction.Command$, "TKSPayLoad") > 0 Then
        DoTKSReplacements
    End If
    
End Sub

Private Sub DoTKSReplacements()

    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes(LTA_GET_SUMM_ABS_TO_REPLACE)
    
    Dim oSummObjType As A2IObjType
    Set oSummObjType = mSys.ObjectTypes("SummAbsToRepl")
    
    Dim summ As A2SummAbsToRepl
    Set summ = mSys.GetObject(oSummObjType, lookup)
    
    Dim vLowNum As Variant
    Dim vHighNum As Variant
    
    vLowNum = summ.LowNumber
    vHighNum = summ.HighNumber

    If Not IsNumeric("" & vLowNum) Or Not IsNumeric("" & vHighNum) Then
        Exit Sub
    End If
    
    Dim lowNum As Long
    Dim highNum As Long
    Dim diff As Long
    lowNum = CLng(vLowNum)
    highNum = CLng(vHighNum)
    diff = highNum - lowNum
    
    Dim increment As Long
    increment = diff / NUM_PROCESSES
    increment = Fix(increment)
    
    Dim i As Long, x As Long
    x = lowNum
    For i = 1 To NUM_PROCESSES
        If i = NUM_PROCESSES Then
            VBA.Shell "a2batch.exe TKSPayLoad/" & x & "/" & highNum
        Else
            VBA.Shell "a2batch.exe TKSPayLoad/" & x & "/" & x + increment
        End If
        x = x + increment
    Next
    
End Sub

