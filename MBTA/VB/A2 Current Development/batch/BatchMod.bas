Attribute VB_Name = "BatchMod"
Option Explicit

Public Const LTA_GET_ABS_TO_REPLACE As String = "GetAbsToReplace"

Public Const LTA_GET_ABS_TYPES_FOR_ABS_TO_REPL As String = "GetAbsTypesForAbsToReplace"
    Public Const LTPA_GET_ABS_TYPES_FOR_ABS_TO_REPL_EMP As String = "emp"
    Public Const LTPA_GET_ABS_TYPES_FOR_ABS_TO_REPL_DATE As String = "date"

Public Const LTA_GET_ABS_TO_REPL_IN_RANGE As String = "GetAbsToReplInRange"
    Public Const LTPA_GET_ABS_TO_REPL_IN_RANGE_LOW As String = "lowNum"
    Public Const LTPA_GET_ABS_TO_REPL_IN_RANGE_HIGH As String = "lowNum"

Private mSys As A2System
Private mApp As A2App

Public Sub Main()
    
    Dim ds As A2IDataSource
    Set ds = New A2SQLDataSource

    
    Dim lowNum As Long
    Dim highNum As Long
    
    Dim cmdLine As String
    cmdLine = "" & Interaction.Command$
    
    Dim parmArr() As String
    
    Dim a2username As String
    Dim a2password As String
    
'    If InStr(1, cmdLine, "/") > 0 Then
    
        parmArr = Split(cmdLine, "/")
        
        ds.ConnectionString = parmArr(0)
        Set mApp = New A2App
        
        a2username = parmArr(1)
        a2password = parmArr(2)
        
        'mApp.Logon ds, "TKSIMP", "doggers"
        mApp.Logon ds, a2username, a2password
        Set mSys = mApp.System
    
        If InStr(1, parmArr(3), "TKSPayLoad") > 0 And UBound(parmArr) = 5 Then
            If IsNumeric(parmArr(4)) Then
                lowNum = CLng(parmArr(4))
            Else
                Exit Sub
            End If
            
            If IsNumeric(parmArr(5)) Then
                highNum = CLng(parmArr(5))
            Else
                Exit Sub
            End If
            
            DoTKSReplacements lowNum, highNum
        End If
    
        If InStr(1, parmArr(3), "TKSBulkLoadNoCheck") > 0 And UBound(parmArr) = 5 Then
            If IsNumeric(parmArr(4)) Then
                lowNum = CLng(parmArr(4))
            Else
                Exit Sub
            End If
            
            If IsNumeric(parmArr(5)) Then
                highNum = CLng(parmArr(5))
            Else
                Exit Sub
            End If
            
            DoTKSReplacements lowNum, highNum
        End If
    
        If InStr(1, parmArr(3), "TKSPayLoad") > 0 And UBound(parmArr) = 3 Then
            DoTKSReplacements 0, 0
        End If
        
        If InStr(1, parmArr(3), "TKSBulkLoadWithCheck") > 0 And UBound(parmArr) = 3 Then
            DoTKSReplacements 0, 0, True
            mApp.RecheckEveryone
        End If
    
        If InStr(1, parmArr(3), "TKSBulkLoadNoCheck") > 0 And UBound(parmArr) = 3 Then
            DoTKSReplacements 0, 0, True
        End If
'    Else
'
'        ds.ConnectionString = "Provider=sqloledb;Data Source=OPSTECH2\A2PROD;Initial Catalog=attend2"
'        Set mApp = New A2App
'        mApp.Logon ds, "TKSIMP", "doggers"
'        Set mSys = mApp.System
'
'        If InStr(1, "" & Interaction.Command$, "TKSPayLoad") > 0 Then
'            DoTKSReplacements 0, 0
'        End If
'
'        If InStr(1, "" & Interaction.Command$, "TKSBulkLoadWithCheck") > 0 Then
'            DoTKSReplacements 0, 0, True
'            mApp.RecheckEveryone
'        End If
'
'        If InStr(1, "" & Interaction.Command$, "TKSBulkLoadNoCheck") > 0 Then
'            DoTKSReplacements 0, 0, True
'        End If
'
'    End If
    
End Sub

Private Sub DoTKSReplacements(lowNum As Long, highNum As Long, Optional delayCheck As Boolean = False)

    Dim lookup As A2ILookupType
    Dim parm1 As A2GetObjParm
    Dim parm2 As A2GetObjParm
    
    If lowNum = 0 And highNum = 0 Then
        Set lookup = mSys.LookupTypes(LTA_GET_ABS_TO_REPLACE)
    Else
        Set lookup = mSys.LookupTypes(LTA_GET_ABS_TO_REPL_IN_RANGE)
        Set parm1.parm = lookup.Parameters(LTPA_GET_ABS_TO_REPL_IN_RANGE_LOW)
        Set parm2.parm = lookup.Parameters(LTPA_GET_ABS_TO_REPL_IN_RANGE_HIGH)
        parm1.Val = lowNum
        parm2.Val = highNum
    End If
    
    Dim oSrcObjType As A2IObjType
    Set oSrcObjType = mSys.ObjectTypes("Src")

    Dim oSrc As A2Source
    Set oSrc = mSys.GetObject(oSrcObjType, 1)

    Dim absToReplace As A2IObjSet

    Dim absTypes As A2IObjSet
    
    Dim v As Variant, oAbs As A2Abs, oAbsToRepl As A2AbsToReplace
    Dim msgStr As String
    Dim oNewAbs As A2Abs
    
    Dim v2 As Variant, oType As A2AbsType
    
    Dim oAbsAbsType As A2AbsToReplAbsType
    
    Dim i As Long
    
    Dim countIncludedDis As Long

    On Error Resume Next
    
startloop:
    Set absToReplace = Nothing
    If lowNum = 0 And highNum = 0 Then
        Set absToReplace = mSys.GetObjects(lookup)
    Else
        Set absToReplace = mSys.GetObjects(Array(parm1, parm2))
    End If
    Dim ds
    
    If absToReplace.Count = 0 Then
        Exit Sub
    Else
        
        For Each v In absToReplace
            i = i + 1
            Set oAbsToRepl = v
            Set oNewAbs = Nothing
            Set oAbs = GetAbsFromEmpAndDate(oAbsToRepl.Employee, oAbsToRepl.OnDate)
            Set absTypes = oAbsToRepl.GetAbsTypes 'tOKfix-get abstypewithminutes
                        
            If oAbs Is Nothing Then
                Set oNewAbs = mApp.CreateAbsenceX(oAbsToRepl.Employee, oAbsToRepl.OnDate, oSrc)
            Else
                countIncludedDis = oAbs.GetContainingDis(True, True).Count
            
                If countIncludedDis = 0 Then
                    'If delayCheck = True Then
                        Set oNewAbs = oAbs.ReplaceWithoutTypes(oSrc, False) 'tOKfix - need minutes
                    'Else
                    '    Set oNewAbs = oAbs.ReplaceWithoutTypes(oSrc, True) 'tOKfix - need minutes
                    'End If
                End If
            End If
            
            If Not oNewAbs Is Nothing Then
                For Each v2 In absTypes
                    Set oAbsAbsType = v2
                    Set oType = oAbsAbsType.AbsType
                    'If delayCheck = True Then
                        oNewAbs.AddType oType, True, oAbsAbsType.Minutes 'tOKfix - add the minutes
                    'Else
                    '    oNewAbs.AddType oType, False, oAbsAbsType.Minutes 'tOKfix - add the minutes
                    'End If
                Next
            End If
            
            If delayCheck = False Then
                mSys.Publish a2PubEvTypeAbsReplaced, oNewAbs
            End If
            
            If Err.Number <> 0 Then
                msgStr = "Unknown"
                msgStr = Left("Emp " & oAbsToRepl.Employee.BadgeNumber & "  Date " & oAbsToRepl.OnDate, 49)
                If oNewAbs Is Nothing Then
                    VB.App.LogEvent "Error during TKS load -- absence not replaced: " & msgStr & " " & Err.Description, 1
                Else
                    VB.App.LogEvent "Error during TKS load -- absence replaced: " & msgStr & " " & Err.Description, 2
                    mSys.Publish a2PubEvTypeAbsAltered, oNewAbs
                End If
                Err.Clear
            End If
            
            oAbsToRepl.SetProcessed
            
            Set oNewAbs = Nothing
            Set oAbsToRepl = Nothing
            Set oAbs = Nothing
            Set absTypes = Nothing
        Next
    End If
    
    GoTo startloop
End Sub

Private Function GetAbsFromEmpAndDate(iEmp As A2Employee, iDate As Date) As A2Abs
    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes("GetAbsByEmpAndDate")
    
    Dim empParm As A2ILookupTypeParm
    Set empParm = lookup.Parameters("emp")
    Dim dateParm As A2ILookupTypeParm
    Set dateParm = lookup.Parameters("date")
    
    Dim empGop As A2GetObjParm
    Set empGop.parm = empParm
    Set empGop.Val = iEmp
    
    Dim dateGop As A2GetObjParm
    Set dateGop.parm = dateParm
    dateGop.Val = iDate
    
    Set GetAbsFromEmpAndDate = mSys.GetObject(mSys.ObjectTypes("Abs"), Array(empGop, dateGop))
End Function



