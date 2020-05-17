Attribute VB_Name = "TestMod1"
Option Explicit

Public Function GetApp() As A2App
    Dim oDS As A2IDataSource
    Set oDS = New A2SQLDataSource
    oDS.ConnectionString = "Provider=sqloledb;Data Source=OPSTECH2\A2PROD;Initial Catalog=attend2dev"
    
    Dim oApp As A2App
    Set oApp = New A2App
    oApp.Logon oDS, "ajv6412", "doggers"
    Set GetApp = oApp
    
End Function

Public Sub TestC1()
    Dim oApp As A2App
    Set oApp = GetApp()
    Dim oEmp As A2Employee
    Set oEmp = oApp.GetEmpByBadgeNum(16526)
    oApp.System.Publish a2PubEvTypeEmpAltered, oEmp

End Sub

Public Sub TestC2()
    Dim oApp As A2App
    Set oApp = GetApp()
    
    Dim lookup As A2ILookupType
    Set lookup = oApp.System.LookupTypes("GetAllUsers")
    
    Dim collUsers As A2IObjSet
    Set collUsers = oApp.System.GetObjects(lookup)
    
    Dim newPwd As String
    Randomize
    Dim pwdLong As Long
    
    Dim oUser As A2User, vUser As Variant
    For Each vUser In collUsers
        Set oUser = vUser
        If Trim(oUser.userName) = "TKSImp" Or _
            Trim(oUser.userName) = "AJV6412" Then
                ' do nothing
        Else
            pwdLong = Int(Rnd * 99999) + 1
            newPwd = "a2pw" & Format(pwdLong, "00000")
            Debug.Print oUser.userName & "," & newPwd
            oUser.ResetPassword newPwd
        End If
    Next
End Sub


Public Sub TestC3()
    Dim oApp As A2App
    Set oApp = GetApp()
    
    Dim lookup As A2ILookupType
    Set lookup = oApp.System.LookupTypes("GetAllUsers")
    
    Dim collUsers As A2IObjSet
    Set collUsers = oApp.System.GetObjects(lookup)
    
    Dim newPwd As String
    Randomize
    Dim pwdLong As Long
    
    Dim oUser As A2User, vUser As Variant
    
    
    For Each vUser In collUsers
        Set oUser = vUser
        If oUser.userName = "TKSIMP" Then
            oUser.ResetPassword "doggers"
        End If
    Next
End Sub

Public Sub TestC4()
    Dim oApp As A2App
    Set oApp = GetApp()
    oApp.RecheckEveryone

End Sub

Public Sub TestC5()
    Dim oApp As A2App
    Set oApp = GetApp()
    Dim oEmp As A2Employee
    Set oEmp = oApp.GetEmpByBadgeNum(2185)
    oApp.System.Publish a2PubEvTypeEmpAltered, oEmp

End Sub


Public Sub TestC6()
    Dim oApp As A2App
    Set oApp = GetApp()
    
    Dim lookup As A2ILookupType
    Set lookup = oApp.System.LookupTypes("GetAllUsers")
    
    Dim collUsers As A2IObjSet
    Set collUsers = oApp.System.GetObjects(lookup)
    
    Dim newPwd As String
    Randomize
    Dim pwdLong As Long
    
    Dim oUser As A2User, vUser As Variant
    For Each vUser In collUsers
        Set oUser = vUser
        If Trim(oUser.userName) = "TGC9513" Then
            pwdLong = Int(Rnd * 99999) + 1
            newPwd = "a2pw" & Format(pwdLong, "00000")
            Debug.Print oUser.userName & "," & newPwd
            oUser.ResetPassword newPwd
        End If
    Next
End Sub


Public Sub TestC7()
    Dim oApp As A2App
    Set oApp = GetApp()
    
    Dim objSet As A2IObjSet
    'Set objSet = oApp.GetOpenExtNotifForWatchedEmps()
    'Set objSet = oApp.GetOpenExtNotif(#6/1/2005#)
    'Set objSet = oApp.GetDisOpenSince(#1/1/2005#)
    Set objSet = oApp.GetOpenDisciplineInstances
    
    Dim extNotif As A2Dis, v As Variant
    For Each v In objSet
        Set extNotif = v
        Debug.Print extNotif.AreaAtInit.AreaNum
    Next
    
End Sub



Public Sub TestC8()
    Dim oApp As A2App
    Set oApp = GetApp()
    
    Dim objSet As A2IObjSet
    Set objSet = oApp.GetAllUsers()
    
    Dim v As Variant, oUser As A2User
    
    Set oUser = oApp.GetObjFromIdent("User", 50)
    Debug.Print oUser.TKSUserName
    Debug.Print oUser.IsDisabled
    oUser.Enable
    Debug.Print oUser.IsDisabled
    oUser.Disable
    Debug.Print oUser.IsDisabled
End Sub


Public Sub TestC9()
    Dim oApp As A2App
    Set oApp = GetApp()
    
    Dim objSet As A2IObjSet
    Set objSet = oApp.GetAllSecurityOverrides(False)
    
    Dim v As Variant, oSecO As A2SecOverride
    
    Set oSecO = oApp.GetObjFromIdent("SecOverride", 35)
    Debug.Print oSecO.IsInactive
    oSecO.Delete
    Debug.Print oSecO.IsInactive
    
    For Each v In objSet
        Set oSecO = v
        Debug.Print oSecO.user.userName & " - " & oSecO.AreaNumber
        Set oSecO = oApp.AddSecurityOverride(oApp.GetObjFromIdent("User", 1), 93, True, True)
    Next
    
End Sub


Public Sub TestC99()
    Dim oApp As A2App
    Set oApp = GetApp()
    
    Dim ocoll As A2IObjSet
    Set ocoll = oApp.GetRecentExtAbsences(#7/1/2005#, True, True)
    Dim oexa As A2ExtAbs
    Dim v As Variant
    For Each v In ocoll
        Set oexa = v
        Debug.Print oexa.AreaNum & " - " & oexa.BadgeNum & " - " & oexa.EmpName & " - " & oexa.AreaDesc & " - " & oexa.HTMLDesc
    Next
    Debug.Print ocoll.Count
    
    
End Sub

Public Sub TestC97()
    Dim oApp As A2App
    Set oApp = GetApp()
    
    Dim ocoll As A2IObjSet
    Set ocoll = oApp.GetEmpsByName("smi")
    
    Dim oexa As A2Employee
    Dim v As Variant
    For Each v In ocoll
        Set oexa = v
        Debug.Print oexa.EmpName
    Next
    Debug.Print ocoll.Count
    
    
End Sub


Public Sub Test98()

'Dim auth As A2IAuthenticator
'Set auth = New Class1
'Debug.Print auth.CheckLogon("ajv6412", "yxgd230").LogonSuccessful

End Sub


Public Sub TestC101()


    Dim oApp As attend2a.A2App
    Set oApp = GetApp()
    
    Dim uType As A2UserType
    Set uType = oApp.GetObjFromIdent("UserType", 1)
    
    Dim oEmp As A2Employee
    Set oEmp = Nothing
    
    Dim newuser As A2User
    Set newuser = oApp.AddUser("DEMO3", "Demo User 3", "3 Demo User", uType, "test")
        
    Debug.Print newuser.Identifier
    
End Sub

Public Sub TestC75()
    Dim oApp As A2App
    Set oApp = GetApp()
    
    Dim objSet As A2IObjSet
    Set objSet = oApp.GetOpenExtNotifForWatchedEmps()
    'Set objSet = oApp.GetOpenExtNotif(#6/1/2005#)
    'Set objSet = oApp.GetDisOpenSince(#1/1/2005#)
    'Set objSet = oApp.GetOpenDisciplineInstances
    
    Dim extNotif As A2ExtNotif, v As Variant
    For Each v In objSet
        Set extNotif = v
        If extNotif.Severity = a2NotifSeverityViolation Then
            Debug.Print extNotif.Notification.employee.BadgeNumber
            oApp.System.Publish a2PubEvTypeEmpAltered, extNotif.Notification.employee
        End If
    Next
    
End Sub

Public Sub TestC76()
 Dim oApp As A2App
    Set oApp = GetApp()
    Dim oEmp As A2Employee
    Set oEmp = oApp.GetEmpByBadgeNum(6943)
    Dim extinfo As A2ExtendedEmpInfo
    Set extinfo = oEmp.GetExtendedInfo
    
    Debug.Print extinfo.JobTitle & " * " & extinfo.UnionCode

End Sub


Public Sub TestC77()
 Dim oApp As A2App
    Set oApp = GetApp()
    Dim oEmp As A2Employee
    Set oEmp = oApp.GetEmpByBadgeNum(7600)
    oApp.System.Publish a2PubEvTypeEmpAltered, oEmp

End Sub

Public Sub RecheckEveryone()

    Dim oApp As A2App
    Set oApp = GetApp()

    Dim allEmps As A2IObjSet
    Set allEmps = oApp.CurrentUser.GetViewableEmployees()
    
    Dim vEmp As Variant
    Dim oEmp As A2Employee

    For Each vEmp In allEmps
        Set oEmp = vEmp
        Debug.Print oEmp.BadgeNumber & ": "
        oApp.System.Publish a2PubEvTypeEmpAltered, oEmp
    Next
    
End Sub



Public Sub TestC78()
 Dim oApp As A2App
    Set oApp = GetApp()
    Dim oEmp As A2Employee
    Set oEmp = oApp.GetEmpByBadgeNum(9185)
    oApp.System.Publish a2PubEvTypeEmpAltered, oEmp

End Sub


Public Sub TestC79()
 

    Dim oApp As A2App
    Set oApp = GetApp()
    Dim oEmp As A2Employee
    Set oEmp = oApp.GetEmpByBadgeNum(9185)
    'oApp.System.Publish a2PubEvTypeEmpAltered, oEmp
    
    Dim oSrc As A2Source
    Set oSrc = oApp.GetObjFromIdent("Src", 1)
    
    Dim oAbs As A2Abs
    Set oAbs = oApp.GetAbsFromEmpAndDate(oEmp, #3/29/2007#)
    Dim newabs As A2Abs
    
    
    Dim absTypes As A2ObjSet ' A2IObjSet
    Set absTypes = New A2ObjSet
    
    Dim missabstype As A2AbsType
    Set misabstype = oApp.GetObjFromIdent("AbsType", 13)
    
    Dim workabstype As A2AbsType
    Set workabstype = oApp.GetObjFromIdent("AbsType", 18)
    
    absTypes.coll.Add misabstype
    absTypes.coll.Add workabstype
    
    Set newabs = oAbs.Replace(oSrc, absTypes)
    
End Sub

Public Sub TestC80()
 

    Dim oApp As A2App
    Set oApp = GetApp()
    Dim oEmp As A2Employee
    Set oEmp = oApp.GetEmpByBadgeNum(68306)
    'oApp.System.Publish a2PubEvTypeEmpAltered, oEmp
    
    Dim oSrc As A2Source
    Set oSrc = oApp.GetObjFromIdent("Src", 1)
    
    Dim oAbs As A2Abs
    Set oAbs = oApp.GetAbsFromEmpAndDate(oEmp, #6/15/2007#)
    Debug.Print oAbs.IsEstimated
    Dim newabs As A2Abs
    
    
    Dim absTypes As A2IObjSet ' A2IObjSet
    Set absTypes = oAbs.GetTypesWithMinutes
    
    Dim OAbsType As A2AbsAbsType
    Dim VabsType As Variant
        For Each VabsType In absTypes
            Set OAbsType = VabsType
            Debug.Print OAbsType.absType.Desc & " " & OAbsType.Minutes
        Next
    
End Sub


