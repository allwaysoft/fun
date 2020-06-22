Attribute VB_Name = "TestMod2"
Option Explicit



Public Sub TestB12()

    Dim oApp As Attend2A.A2App
    Set oApp = New Attend2A.A2App


    Dim ds As A2SQLDataSource
    Set ds = New A2SQLDS.A2SQLDataSource
    Dim dsX As A2IDataSource
    Set dsX = ds.DispInterfaceX
    'ds.ConnectionString = "Provider=sqloledb;Network Library=DBMSSOCN;Data Source=nhastus-90.mbta.com,9915;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'ds.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=A2SQLUser;Password=bzr923"
    oApp.Logon ds, "AJV6412", "yxgd225"
    
    
    
    Dim aSys As A2System
    Set aSys = oApp.System
    
    Dim oAbsTypeObjType As A2IObjType
    Dim oObjTypeEmp As A2IObjType
    Dim oObjTypeSrc As A2IObjType
    Set oAbsTypeObjType = aSys.ObjectTypes("AbsType")
    Set oObjTypeEmp = aSys.ObjectTypes("Emp")
    Set oObjTypeSrc = aSys.ObjectTypes("Src")
    
    Dim oAbsTypeFMLA As A2AbsType
    Dim oAbsTypeSick As A2AbsType
    Dim oEmpMe As A2Employee
    Dim oSrcUser As A2Source
    
    Set oAbsTypeFMLA = aSys.GetObject(oAbsTypeObjType, 3)
    Set oAbsTypeSick = aSys.GetObject(oAbsTypeObjType, 15)
    'Set oEmpMe = aSys.GetObject(oObjTypeEmp, 1)
    Set oEmpMe = oApp.GetEmpByBadgeNum(100)  ' championetta serenade
    Set oSrcUser = aSys.GetObject(oObjTypeSrc, 1)
    
    
    Dim oAbs As A2Abs, oAbs2 As A2Abs
    Set oAbs = oApp.CreateAbsence(oEmpMe, #8/14/2000#, oSrcUser)
    Set oAbs2 = oAbs
    
    
    Debug.Print oAbs.Replaces.Count
    
    oAbs.AddType oAbsTypeSick
    'Debug.Print oabs.Identifier
    
    Dim objset As A2ObjSet
    Set objset = New A2ObjSet
    objset.coll.Add oAbsTypeSick
    
    Set oAbs = oAbs.Replace(oSrcUser, objset)
    
    Set oAbs = oAbs.Replace(oSrcUser, objset)
    
    Debug.Print oAbs.Replaces.Count
    
    oAbs.AddType oAbsTypeFMLA
    Debug.Print oAbs.Employee.BadgeNumber & " - " & oAbs.Types.Count

    
    Debug.Print oAbs.Types.Count
    Debug.Print oAbs2.ReplacedBy.Types.Count
End Sub






Public Sub TestB13()

    Dim oApp As Attend2A.A2App
    Set oApp = New Attend2A.A2App


    Dim ds As A2SQLDataSource
    Set ds = New A2SQLDS.A2SQLDataSource
    Dim dsX As A2IDataSource
    Set dsX = ds.DispInterfaceX
    'ds.ConnectionString = "Provider=sqloledb;Network Library=DBMSSOCN;Data Source=nhastus-90.mbta.com,9915;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'ds.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=A2SQLUser;Password=bzr923"
    oApp.Logon ds, "AJV6412", "doggers"
    
    Dim aSys As A2System
    Set aSys = oApp.System
    
    Dim oNotif As A2Notif
    'Set oNotif = oApp.GetObjFromIdent("Notif", 15)
    
    Dim oDis As A2Dis
    'Set oDis = oApp.CreateDisFromNotif(oNotif)
    Set oDis = oApp.GetObjFromIdent("Dis", 2)
    
    Dim oActTypes As A2IObjSet
    Set oActTypes = oApp.GetAllDisActTypes
    
    Dim oTypes As A2IObjSet
    Set oTypes = oApp.GetAllDisTypes
    
    Dim oActType As A2DisActType
    Dim v, v2
    For Each v In oActTypes
        Set v2 = v
        Set oActType = v2
        Exit For
    Next
    'Set oActType = oActTypes(1)
    
    Set oDis.DisType = oTypes(1).AsIDefault
    
    Dim oAct2 As A2DisAct
    
    Set oAct2 = oDis.AddAction(oActType, #1/1/2001#, "HELLO!!!")
    
    oDis.Status = a2DisStatusEffective
    
    oDis.Status = a2DisStatusCancelled
    
End Sub







Public Sub TestB14()

    Dim oApp As Attend2A.A2App
    Set oApp = New Attend2A.A2App


    Dim ds As A2SQLDataSource
    Set ds = New A2SQLDS.A2SQLDataSource
    Dim dsX As A2IDataSource
    Set dsX = ds.DispInterfaceX
    'ds.ConnectionString = "Provider=sqloledb;Network Library=DBMSSOCN;Data Source=nhastus-90.mbta.com,9915;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'ds.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    dsX.ConnectionString = "Provider=sqloledb;Data Source=UPSTAIRS;Initial Catalog=attend2"
    oApp.Logon ds, "AJV6412", "doggers"
    
    Dim aSys As A2System
    Set aSys = oApp.System
    
    Dim oNotif As A2Notif
    'Set oNotif = oApp.GetObjFromIdent("Notif", 15)
    
    Dim oDis As A2Dis
    'Set oDis = oApp.CreateDisFromNotif(oNotif)
    Set oDis = oApp.GetObjFromIdent("Dis", 2)
    
    Dim oDisType As A2DisType
    Set oDisType = oDis.Attributes("disDisType").Value
    
    Debug.Print oDisType.Desc
    
'
'
'    Dim oActTypes As A2IObjSet
'    Set oActTypes = oApp.GetAllDisActTypes
'
'    Dim oTypes As A2IObjSet
'    Set oTypes = oApp.GetAllDisTypes
'
'    Dim oActType As A2DisActType
'    Dim v, v2
'    For Each v In oActTypes
'        Set v2 = v
'        Set oActType = v2
'        Exit For
'    Next
'    'Set oActType = oActTypes(1)
'
'    Set oDis.DisType = oTypes(1).AsIDefault
'
'    Dim oAct2 As A2DisAct
'
'    Set oAct2 = oDis.AddAction(oActType, #1/1/2001#, "HELLO!!!")
'
'    oDis.Status = a2DisStatusEffective
'
'    oDis.Status = a2DisStatusCancelled
    
End Sub






Public Sub TestB15()

    Dim oApp As Attend2A.A2App
    Set oApp = New Attend2A.A2App


    Dim ds As A2SQLDataSource
    Set ds = New A2SQLDS.A2SQLDataSource
    Dim dsX As A2IDataSource
    Set dsX = ds.DispInterfaceX
    'ds.ConnectionString = "Provider=sqloledb;Network Library=DBMSSOCN;Data Source=nhastus-90.mbta.com,9915;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'ds.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    dsX.ConnectionString = "Provider=sqloledb;Data Source=UPSTAIRS;Initial Catalog=attend2"
    oApp.Logon ds, "AJV6412", "doggers"
    
    Dim aSys As A2System
    Set aSys = oApp.System
    
    Dim oNotif As A2Notif
    'Set oNotif = oApp.GetObjFromIdent("Notif", 15)
    
    Dim oDis As A2Dis
    'Set oDis = oApp.CreateDisFromNotif(oNotif)
    Set oDis = oApp.GetObjFromIdent("Dis", 3)
    
    Dim oDisType As A2DisType
    Set oDisType = oDis.DisType
    
    Debug.Print oDisType.Desc
    
'
'
'    Dim oActTypes As A2IObjSet
'    Set oActTypes = oApp.GetAllDisActTypes
'
'    Dim oTypes As A2IObjSet
'    Set oTypes = oApp.GetAllDisTypes
'
'    Dim oActType As A2DisActType
'    Dim v, v2
'    For Each v In oActTypes
'        Set v2 = v
'        Set oActType = v2
'        Exit For
'    Next
'    'Set oActType = oActTypes(1)
'
'    Set oDis.DisType = oTypes(1).AsIDefault
'
'    Dim oAct2 As A2DisAct
'
'    Set oAct2 = oDis.AddAction(oActType, #1/1/2001#, "HELLO!!!")
'
'    oDis.Status = a2DisStatusEffective
'
'    oDis.Status = a2DisStatusCancelled
    
End Sub







Public Sub TestB16()

    Dim oApp As Attend2A.A2App
    Set oApp = New Attend2A.A2App


    Dim ds As A2SQLDataSource
    Set ds = New A2SQLDS.A2SQLDataSource
    Dim dsX As A2IDataSource
    Set dsX = ds.DispInterfaceX
    'ds.ConnectionString = "Provider=sqloledb;Network Library=DBMSSOCN;Data Source=nhastus-90.mbta.com,9915;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'ds.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    dsX.ConnectionString = "Provider=sqloledb;Data Source=UPSTAIRS;Initial Catalog=attend2"
    oApp.Logon ds, "AJV6412", "doggers"
    
    Dim aSys As A2System
    Set aSys = oApp.System
    
    Dim oNotif As A2Notif
    'Set oNotif = oApp.GetObjFromIdent("Notif", 15)
    
    Dim oDis As A2Dis
    'Set oDis = oApp.CreateDisFromNotif(oNotif)
    Set oDis = oApp.GetObjFromIdent("Dis", 3)
    
    Dim oAbs As A2Abs
    Set oAbs = oApp.GetObjFromIdent("Abs", 145)
    
    Dim oSrc As A2Source
    Set oSrc = oApp.GetObjFromIdent("Src", 2)
    
    'oAbs.Replace oSrc, oAbs.Types
    Debug.Print oAbs.Employee.BadgeNumber & oAbs.Employee.EmpName
    
    
    Dim oDisType As A2DisType
    'Set oDisType = oDis.DisType
    
    'Debug.Print oDisType.Desc
    
'
'
'    Dim oActTypes As A2IObjSet
'    Set oActTypes = oApp.GetAllDisActTypes
'
'    Dim oTypes As A2IObjSet
'    Set oTypes = oApp.GetAllDisTypes
'
'    Dim oActType As A2DisActType
'    Dim v, v2
'    For Each v In oActTypes
'        Set v2 = v
'        Set oActType = v2
'        Exit For
'    Next
'    'Set oActType = oActTypes(1)
'
'    Set oDis.DisType = oTypes(1).AsIDefault
'
'    Dim oAct2 As A2DisAct
'
'    Set oAct2 = oDis.AddAction(oActType, #1/1/2001#, "HELLO!!!")
'
'    oDis.Status = a2DisStatusEffective
'
'    oDis.Status = a2DisStatusCancelled
    
End Sub
















Public Sub TestB17()

    Dim oApp As Attend2A.A2App
    Set oApp = New Attend2A.A2App


    Dim ds As A2SQLDataSource
    Set ds = New A2SQLDS.A2SQLDataSource
    Dim dsX As A2IDataSource
    Set dsX = ds.DispInterfaceX
    'ds.ConnectionString = "Provider=sqloledb;Network Library=DBMSSOCN;Data Source=nhastus-90.mbta.com,9915;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'ds.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=A2SQLUser;Password=bzr923"
    dsX.ConnectionString = "Provider=sqloledb;Data Source=UPSTAIRS;Initial Catalog=attend2"
    
    oApp.Logon ds, "AJV6412", "doggers"
    
    Dim aSys As A2System
    Set aSys = oApp.System
    
    Dim oAbsTypeObjType As A2IObjType
    Dim oObjTypeEmp As A2IObjType
    Dim oObjTypeSrc As A2IObjType
    Set oAbsTypeObjType = aSys.ObjectTypes("AbsType")
    Set oObjTypeEmp = aSys.ObjectTypes("Emp")
    Set oObjTypeSrc = aSys.ObjectTypes("Src")
    
    Dim oAbsTypeFMLA As A2AbsType
    Dim oAbsTypeSick As A2AbsType
    Dim oEmpMe As A2Employee
    Dim oSrcUser As A2Source
    
    Set oAbsTypeFMLA = aSys.GetObject(oAbsTypeObjType, 3)
    Set oAbsTypeSick = aSys.GetObject(oAbsTypeObjType, 15)
    'Set oEmpMe = aSys.GetObject(oObjTypeEmp, 1)
    Set oEmpMe = oApp.GetEmpByBadgeNum(100)  ' championetta serenade
    Set oSrcUser = aSys.GetObject(oObjTypeSrc, 1)
    
    Dim oFMLA As A2AbsType
    Set oFMLA = aSys.GetObject(oAbsTypeObjType, 12)
    
    
    Dim oAbs As A2Abs, oAbs2 As A2Abs
    Set oAbs = oApp.CreateAbsence(oEmpMe, #8/14/1997#, oSrcUser)
    Set oAbs2 = oAbs
    
    
    Debug.Print oAbs.Replaces.Count
    
    oAbs.AddType oAbsTypeSick
    'Debug.Print oabs.Identifier
    
    Dim objset As A2ObjSet
    Set objset = New A2ObjSet
    objset.coll.Add oAbsTypeSick
    
    Set oAbs = oAbs.Replace(oSrcUser, objset)
    
    Set oAbs = oAbs.Replace(oSrcUser, objset)
    
    Debug.Print oAbs.Replaces.Count
    
    oAbs.AddType oAbsTypeFMLA
    Debug.Print oAbs.Employee.BadgeNumber & " - " & oAbs.Types.Count

    
    Debug.Print oAbs.Types.Count
    Debug.Print oAbs2.ReplacedBy.Types.Count
End Sub


Public Sub TestB18()

    Dim oApp As Attend2A.A2App
    Set oApp = New Attend2A.A2App


    Dim ds As A2SQLDataSource
    Set ds = New A2SQLDS.A2SQLDataSource
    Dim dsX As A2IDataSource
    Set dsX = ds.DispInterfaceX
    'ds.ConnectionString = "Provider=sqloledb;Network Library=DBMSSOCN;Data Source=nhastus-90.mbta.com,9915;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'ds.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=A2SQLUser;Password=bzr923"
    dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=UPSTAIRS;Initial Catalog=attend2"
    
    oApp.Logon ds, "AJV6412", "doggers"
    
    Dim aSys As A2System
    Set aSys = oApp.System
    
    Dim oAbsTypeObjType As A2IObjType
    Dim oObjTypeEmp As A2IObjType
    Dim oObjTypeSrc As A2IObjType
    Set oAbsTypeObjType = aSys.ObjectTypes("AbsType")
    Set oObjTypeEmp = aSys.ObjectTypes("Emp")
    Set oObjTypeSrc = aSys.ObjectTypes("Src")
    
    Dim oAbsTypeFMLA As A2AbsType
    Dim oAbsTypeSick As A2AbsType
    Dim oEmpMe As A2Employee
    Dim oSrcUser As A2Source
    
    Set oAbsTypeFMLA = aSys.GetObject(oAbsTypeObjType, 3)
    Set oAbsTypeSick = aSys.GetObject(oAbsTypeObjType, 15)
    'Set oEmpMe = aSys.GetObject(oObjTypeEmp, 1)
    Set oEmpMe = oApp.GetEmpByBadgeNum(100)  ' championetta serenade
    
    Dim xx As A2IObjSet
    Set xx = oEmpMe.GetAbsences(#1/1/2001#, True, True, True, True)
    
    Set xx = oEmpMe.GetDis(True, True, True, True)
    
    
    Set oSrcUser = aSys.GetObject(oObjTypeSrc, 1)
    
    Dim oFMLA As A2AbsType
    Set oFMLA = aSys.GetObject(oAbsTypeObjType, 12)
    
    
    Dim oAbs As A2Abs, oAbs2 As A2Abs
    Set oAbs = oApp.CreateAbsence(oEmpMe, #8/31/1997#, oSrcUser)
    Set oAbs2 = oAbs
    
    
    Debug.Print oAbs.Replaces.Count
    
    oAbs.AddType oFMLA
    'Debug.Print oabs.Identifier
    
    Dim objset As A2ObjSet
    Set objset = New A2ObjSet
    objset.coll.Add oAbsTypeSick
    
    Set oAbs = oAbs.Replace(oSrcUser, objset)
    
    Set oAbs = oAbs.Replace(oSrcUser, objset)
    
    Debug.Print oAbs.Replaces.Count
    
    oAbs.AddType oAbsTypeFMLA
    Debug.Print oAbs.Employee.BadgeNumber & " - " & oAbs.Types.Count

    
    Debug.Print oAbs.Types.Count
    Debug.Print oAbs2.ReplacedBy.Types.Count
End Sub



Public Sub TestB19()

    Dim oApp As Attend2A.A2App
    Set oApp = New Attend2A.A2App


    Dim ds As A2SQLDataSource
    Set ds = New A2SQLDS.A2SQLDataSource
    Dim dsX As A2IDataSource
    Set dsX = ds.DispInterfaceX
    'ds.ConnectionString = "Provider=sqloledb;Network Library=DBMSSOCN;Data Source=nhastus-90.mbta.com,9915;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'ds.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=A2SQLUser;Password=bzr923"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;"
    dsX.ConnectionString = "Provider=sqloledb;Data Source=UPSTAIRS;Initial Catalog=attend2"
    
    oApp.Logon ds, "AJV6412", "doggers"
    
    Dim aSys As A2System
    Set aSys = oApp.System
    
    Debug.Print ds.RefCount
    
    Dim oAbs As A2Abs, oAbs2 As A2Abs
    Set oAbs = oApp.GetObjFromIdent("Abs", 175)
    
    Set oAbs = Nothing
    
    Dim awolAbsType As A2AbsType
    Set awolAbsType = oApp.GetObjFromIdent("AbsType", 12)
    
    Dim objset As A2IObjSet
    'Set objSet = New A2ObjSet
    
    Set oAbs = oApp.GetObjFromIdent("Abs", 178)
    
    Dim oAttr As A2IObjAttr
    Set oAttr = oAbs.Attributes.Item(1)
    
    Set oAbs = Nothing
    
    Dim i As Long
    For i = 0 To 5
    Set objset = oApp.GetAllAbsTypes
    
    'objSet.coll.Add awolAbsType
    Set objset = Nothing
    
    Set objset = oApp.GetAllDisTypes
    Next
    
    Debug.Print oAttr.Value
    Dim ousersrc As A2Source
    Set ousersrc = oApp.GetObjFromIdent("Src", 1)
    
     Set oAbs = oApp.GetObjFromIdent("Abs", 178)
    
    'oApp.Logoff
    
    Set oApp = Nothing
    Set aSys = Nothing
    Set dsX = Nothing
    Set oAbs = Nothing
    Set awolAbsType = Nothing
    Set oAttr = Nothing
    Set ousersrc = Nothing
   ' Debug.Print oAbs.OnDate
    
    'oAbs.Replace oUserSrc, objSet.AsIObjSet
    Set objset = Nothing
    Set ds = Nothing
End Sub

Public Sub testb21()
    Debug.Print "hi"
    TestB19
    Debug.Print "hello"
End Sub

'238

Public Sub TestB20()

End Sub

Public Sub testb22()


    Dim oApp As Attend2A.A2App
    Set oApp = New Attend2A.A2App


    Dim ds As A2SQLDataSource
    Set ds = New A2SQLDS.A2SQLDataSource
    Dim dsX As A2IDataSource
    Set dsX = ds.DispInterfaceX
    'ds.ConnectionString = "Provider=sqloledb;Network Library=DBMSSOCN;Data Source=nhastus-90.mbta.com,9915;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'ds.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=A2SQLUser;Password=bzr923"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=UPSTAIRS;Initial Catalog=attend2"
    dsX.ConnectionString = "Provider=sqloledb;Data Source=TIMETEST;Initial Catalog=attend2"
    
    oApp.Logon ds, "AJV6412", "doggers"

    Dim os As A2IObjSet
    Set os = oApp.GetNotifsOpenSince(#1/1/1999#)
    
    Debug.Print os.Count

    Set os = oApp.GetDisOpenSince(#1/1/1999#)
    
    Debug.Print os.Count

    
End Sub


Public Sub testb23()


    Dim oApp As Attend2A.A2App
    Set oApp = New Attend2A.A2App


    Dim ds As A2SQLDataSource
    Set ds = New A2SQLDS.A2SQLDataSource
    Dim dsX As A2IDataSource
    Set dsX = ds.DispInterfaceX
    'ds.ConnectionString = "Provider=sqloledb;Network Library=DBMSSOCN;Data Source=nhastus-90.mbta.com,9915;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'ds.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=A2SQLUser;Password=bzr923"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=UPSTAIRS;Initial Catalog=attend2"
    dsX.ConnectionString = "Provider=sqloledb;Data Source=TIMETEST;Initial Catalog=attend2"
    
    oApp.Logon ds, "AJV6412", "doggers"
    'oApp.Logon ds, "SMN0466", "attendpilot"

    Dim oEmp As A2Employee
    Set oEmp = oApp.GetEmpByBadgeNum(66991)

    Dim oAbs As A2Abs
    Set oAbs = oApp.GetAbsFromEmpAndDate(oEmp, #4/15/2005#)

    oApp.System.Publish a2PubEvTypeAbsAltered, oAbs
    
    Debug.Print oEmp.EmpName

    Dim collFMLA As A2IObjSet
    Set collFMLA = oEmp.GetFMLA
    Dim vFMLA As Variant, oFMLA As A2EmpFMLA
    For Each vFMLA In collFMLA
        Set oFMLA = vFMLA
        Debug.Print oFMLA.BeginDate & " " & oFMLA.EndDate & " " & oFMLA.LeaveReason & " " & oFMLA.LeaveType & " " & oFMLA.LeaveStatus
    Next


    Dim oUser As A2User
'    Set oUser = oApp.GetObjFromIdent("User", 88)
'    oUser.ResetPassword "attendpilot"
    
'    oUser.Enable
    
    Set oUser = oApp.System.CurrentUser
    
    oUser.RegenerateWatches
    
    Dim prefs As A2IObjSet
    Set prefs = oUser.GetWatchPreferences
    
    Dim v As Variant, oPref As A2WatchPref
    For Each v In prefs
        Set oPref = v
        Debug.Print oPref.AreaNumber & " " & oPref.IsWatching
        'oPref.IsWatching = False
        'Debug.Print oPref.AreaNumber & " " & oPref.IsWatching
    Next
    
    'oUser.ChangePassword "bzr923", "doggers"

    

    'oAbs.AddType(
    Dim oAbsType As A2AbsType
   Set oAbsType = oApp.GetObjFromIdent("AbsType", 11)

    oAbs.AddType oAbsType

    
End Sub


Public Sub testb24()


    Dim oApp As Attend2A.A2App
    Set oApp = New Attend2A.A2App


    Dim ds As A2SQLDataSource
    Set ds = New A2SQLDS.A2SQLDataSource
    Dim dsX As A2IDataSource
    Set dsX = ds.DispInterfaceX
    'ds.ConnectionString = "Provider=sqloledb;Network Library=DBMSSOCN;Data Source=nhastus-90.mbta.com,9915;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'ds.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=A2SQLUser;Password=bzr923"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=UPSTAIRS;Initial Catalog=attend2"
    dsX.ConnectionString = "Provider=sqloledb;Data Source=TIMETEST;Initial Catalog=attend2"
    
    oApp.Logon ds, "AJV6412", "doggers"
    'oApp.Logon ds, "SMN0466", "attendpilot"

    Dim oEmp As A2Employee
    Set oEmp = oApp.GetEmpByBadgeNum(67410)

    Dim oCal As A2IObjSet
    Set oCal = oEmp.GetAbsenceCalendar(#1/1/2005#, #3/1/2005#)
    
    Dim v As Variant, oCalDay As A2AbsCalDay
    For Each v In oCal
        Set oCalDay = v
        Debug.Print oCalDay.OnDate & " " & oCalDay.IsProtected & " " & oCalDay.IsUnprotected & " " & oCalDay.IsWorked
    Next

    
End Sub




Public Sub testb25()


    Dim oApp As Attend2A.A2App
    Set oApp = New Attend2A.A2App


    Dim ds As A2SQLDataSource
    Set ds = New A2SQLDS.A2SQLDataSource
    Dim dsX As A2IDataSource
    Set dsX = ds.DispInterfaceX
    'ds.ConnectionString = "Provider=sqloledb;Network Library=DBMSSOCN;Data Source=nhastus-90.mbta.com,9915;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'ds.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=A2SQLUser;Password=bzr923"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=UPSTAIRS;Initial Catalog=attend2"
    dsX.ConnectionString = "Provider=sqloledb;Data Source=TIMETEST;Initial Catalog=attend2;"
    
    oApp.Logon ds, "AJV6412", "yxgd227"
    'oApp.Logon ds, "SMN0466", "attendpilot"
    Dim oEmp As A2Employee
    Set oEmp = oApp.GetObjFromIdent("Emp", 65)
    oApp.System.Publish a2PubEvTypeEmpAltered, oEmp
    'oApp.RecheckEveryone

    Exit Sub
    
    
End Sub

Public Sub testb26()


    Dim oApp As Attend2A.A2App
    Set oApp = New Attend2A.A2App


    Dim ds As A2SQLDataSource
    Set ds = New A2SQLDS.A2SQLDataSource
    Dim dsX As A2IDataSource
    Set dsX = ds.DispInterfaceX
    'ds.ConnectionString = "Provider=sqloledb;Network Library=DBMSSOCN;Data Source=nhastus-90.mbta.com,9915;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'ds.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=A2SQLUser;Password=bzr923"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=UPSTAIRS;Initial Catalog=attend2"
    dsX.ConnectionString = "Provider=sqloledb;Data Source=TIMETEST;Initial Catalog=attend2"
    
    oApp.Logon ds, "AJV6412", "yxgd227"
    'oApp.Logon ds, "SMN0466", "attendpilot"

    Dim oEmp As A2Employee
    Set oEmp = oApp.GetEmpByBadgeNum(67410)

    Debug.Print oEmp.GetExtendedInfo.AreaNumber

End Sub



Public Sub testb27()


    Dim oApp As Attend2A.A2App
    Set oApp = New Attend2A.A2App


    Dim ds As A2SQLDataSource
    Set ds = New A2SQLDS.A2SQLDataSource
    Dim dsX As A2IDataSource
    Set dsX = ds.DispInterfaceX
    'ds.ConnectionString = "Provider=sqloledb;Network Library=DBMSSOCN;Data Source=nhastus-90.mbta.com,9915;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'ds.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=A2SQLUser;Password=bzr923"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=UPSTAIRS;Initial Catalog=attend2"
    dsX.ConnectionString = "Provider=sqloledb;Data Source=TIMETEST;Initial Catalog=attend2"
    
    oApp.Logon ds, "AJV6412", "yxgd227"
    'oApp.Logon ds, "SMN0466", "attendpilot"

    Dim os As A2IObjSet
    'Set os = oApp.System.GetRecentAbsences(#1/1/2005#, False)
    Set os = oApp.System.GetRandomNotifSample(#1/1/2005#, #5/1/2005#)
    
    Dim v As Variant, oNotif As A2Notif
    Dim oDisSet As A2IObjSet, vDis As Variant, oDis As A2Dis
    For Each v In os
        Set oNotif = v
        Debug.Print oNotif.Employee.EmpName & " " & oNotif.Rule.ShortDesc
        Set oDisSet = oNotif.GetRelatedDis
        For Each vDis In oDisSet
            Set oDis = vDis
            Debug.Print "   " & oDis.InitiatedOn & " " & oDis.Creator.DisplayName
        Next
    Next
End Sub

Public Sub testb28()


    Dim oApp As Attend2A.A2App
    Set oApp = New Attend2A.A2App


    Dim ds As A2SQLDataSource
    Set ds = New A2SQLDS.A2SQLDataSource
    Dim dsX As A2IDataSource
    Set dsX = ds.DispInterfaceX
    'ds.ConnectionString = "Provider=sqloledb;Network Library=DBMSSOCN;Data Source=nhastus-90.mbta.com,9915;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'ds.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=sa;Password=yxgd225"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;User ID=A2SQLUser;Password=bzr923"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=NHASTUS-90\SQL2;Initial Catalog=attend2;"
    'dsX.ConnectionString = "Provider=sqloledb;Data Source=UPSTAIRS;Initial Catalog=attend2"
    dsX.ConnectionString = "Provider=sqloledb;Data Source=TIMETEST;Initial Catalog=attend2;"
    
    oApp.Logon ds, "AJV6412", "yxgd227"
    'oApp.Logon ds, "SMN0466", "attendpilot"
    
    Dim oEmp As A2Employee
    Set oEmp = oApp.GetEmpByBadgeNum(9221)
    
    'oApp.RecheckEveryone
    oApp.System.Publish a2PubEvTypeEmpAltered, oEmp
    
    oApp.RecheckEveryone
End Sub
