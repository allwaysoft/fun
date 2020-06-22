VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2App"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
Private mSys As A2System
Private mLiaison As A2DSLiaison
'Private mCurrentUser As A2User

Public Sub Logon(iServer As A2IDataSource, iUserName As String, iPassword As String)
    mSys.Logon iServer, iUserName, iPassword, mLiaison
End Sub

Public Sub Logoff()
    mSys.Logoff
End Sub

Public Sub LogonByProxy(iServer As A2IDataSource, iUserName As String, iPassword As String, iAsUsername As String)
    mSys.LogonByProxy iServer, iUserName, iPassword, iAsUsername
End Sub

Public Function CreateAbsGrp(iObjSet As Variant) As A2AbsGrp
    Dim o As A2IObjSet
    Set o = iObjSet
    Set CreateAbsGrp = CreateAbsGrpX(o)
End Function

Public Function CreateAbsGrpX(objSet As A2IObjSet) As A2AbsGrp
    Dim oAbsGrp As A2AbsGrp
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes("AddAbsGrp")
    Set oAbsGrp = mSys.GetObject(mSys.ObjectTypes("AbsGrp"), lookup)
    
    Dim v As Variant
    Dim oAbs As A2Abs
    For Each v In objSet
        Set oAbs = v
        oAbsGrp.AddAbsence oAbs
    Next
    
    Set CreateAbsGrpX = oAbsGrp
End Function

Public Function CreateNotif(iForEmp As Variant, _
    iNotType As Variant, iRule As Variant, iAbsGrp As Variant, _
    Optional iTriggerNote As String = "") As A2Notif
        Dim oEmp As A2Employee, oNotType As A2NotifType
        Dim oRule As A2Rule, oAbsGrp As A2AbsGrp
        Set oEmp = iForEmp
        Set oNotType = iNotType
        Set oRule = iRule
        Set oAbsGrp = iAbsGrp
    Set CreateNotif = CreateNotifX(oEmp, oNotType, oRule, oAbsGrp, iTriggerNote)
End Function

Public Function CreateNotifX(iForEmp As A2Employee, _
    iNotType As A2NotifType, iRule As A2Rule, iAbsGrp As A2AbsGrp, Optional iTriggerNote As String = "") As A2Notif
    
    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes("AddNotif")
    
    Dim empGop As A2GetObjParm, notTypeGop As A2GetObjParm
    Dim ruleGop As A2GetObjParm, absGrpGop As A2GetObjParm
    Dim noteGop As A2GetObjParm
    
    Set empGop.parm = lookup.Parameters("emp")
    Set empGop.Val = iForEmp
    Set notTypeGop.parm = lookup.Parameters("notType")
    Set notTypeGop.Val = iNotType
    Set ruleGop.parm = lookup.Parameters("rule")
    Set ruleGop.Val = iRule
    Set absGrpGop.parm = lookup.Parameters("absGrp")
    Set absGrpGop.Val = iAbsGrp
    Set noteGop.parm = lookup.Parameters("triggerNote")
    noteGop.Val = iTriggerNote
    
    Set CreateNotifX = mSys.GetObject(mSys.ObjectTypes("Notif"), Array(empGop, notTypeGop, ruleGop, absGrpGop, noteGop))
End Function

Public Function CreateAbsence(iForEmp As Variant, _
    iOnDate As Variant, _
    iFromDataSource As Variant) As A2Abs
    Dim oEmp As A2Employee, pDate As Date, oSource As A2Source
    Set oEmp = iForEmp
    pDate = iOnDate
    Set oSource = iFromDataSource
    
Set CreateAbsence = Me.CreateAbsenceX(oEmp, pDate, oSource)
End Function

Public Function CreateAbsenceX( _
    iForEmp As A2Employee, _
    iOnDate As Date, _
    iFromDataSource As A2Source) As A2Abs
    
    Dim lookup As A2ILookupType
    Dim parmEmp As A2ILookupTypeParm
    Dim parmDate As A2ILookupTypeParm
    Dim parmSrc As A2ILookupTypeParm
    Set lookup = mSys.LookupTypes("CreateAbs")
    Set parmEmp = lookup.Parameters("emp")
    Set parmDate = lookup.Parameters("date")
    Set parmSrc = lookup.Parameters("src")
    
    Dim gopEmp As A2GetObjParm, gopDate As A2GetObjParm, gopSrc As A2GetObjParm
    Set gopEmp.parm = parmEmp
    Set gopEmp.Val = iForEmp
    Set gopDate.parm = parmDate
    gopDate.Val = iOnDate
    Set gopSrc.parm = parmSrc
    Set gopSrc.Val = iFromDataSource
    
    Dim oAbsObjType As A2IObjType
    Set oAbsObjType = mSys.ObjectTypes("Abs")
    
    Dim oAbs As A2Abs
    Set oAbs = mSys.GetObject(oAbsObjType, Array(gopEmp, gopDate, gopSrc))
    'mSys.Publish a2PubEvTypeAbsAdded, oAbs
    
    Set CreateAbsenceX = oAbs
End Function


Public Property Get System() As A2System
    Set System = mSys
End Property

Public Function GetEmpByBadgeNum(iBadgeNum As Variant) As A2Employee
    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes("EmpByBadgeNum")
    
    Dim parm As A2ILookupTypeParm
    Set parm = lookup.Parameters("badgeNum")
    
    Dim gop As A2GetObjParm
    Set gop.parm = parm
    gop.Val = CLng(iBadgeNum)
    
    Set GetEmpByBadgeNum = mSys.GetObject(mSys.ObjectTypes("Emp"), gop)
End Function

Public Function GetEmpsByName(iLastNamePrefix As String) As A2IObjSet
    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes(LTA_GET_EMPS_BY_NAME)
    
    Dim parm As A2ILookupTypeParm
    Set parm = lookup.Parameters(LTPA_GET_EMPS_BY_NAME)
    
    Dim gop As A2GetObjParm
    Set gop.parm = parm
    gop.Val = iLastNamePrefix
    
    Set GetEmpsByName = mSys.GetObjects(gop)
End Function


Public Function GetObjFromIdent(iObjTypeAlias As Variant, iIdent As Variant) As Object
    Set GetObjFromIdent = mSys.GetObject(mSys.ObjectTypes(CStr(iObjTypeAlias)), CLng(iIdent))
End Function

Public Function GetAbsFromEmpAndDate(iEmp As Variant, iDate As Variant) As A2Abs
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

Public Function GetAllDisTypes() As A2IObjSet
    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes("GetAllDisTypes")
    
    Set GetAllDisTypes = mSys.GetObjects(lookup)
End Function

Public Function GetAllDisActTypes() As A2IObjSet
    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes("GetAllDisActTypes")
    
    Set GetAllDisActTypes = mSys.GetObjects(lookup)
End Function

Public Function GetAllAbsTypes() As A2IObjSet
    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes("GetAllAbsTypes")
    
    Set GetAllAbsTypes = mSys.GetObjects(lookup)
End Function

Public Function GetAllObjs(iObjTypeAlias As Variant) As A2IObjSet
    Set GetAllObjs = mSys.GetObjects(mSys.ObjectTypes(CStr(iObjTypeAlias)))
End Function


' This methods is used (especially from VBScript)
' to cast an object reference to a specified interface, as the caller may not
' know which interface they are holding. The AsIDefault method will return a reference
' to the same object under its "default" interface; for instance, the default interface
' for an object of type A2Abs is A2Abs.

Public Function AsIDisp(iObj As Variant) As Object
    Set AsIDisp = iObj
End Function

Public Function AsIDefault(iObj As Variant) As Object
    Dim a2IObj As A2IObject
    Set a2IObj = iObj
    Set AsIDefault = a2IObj.AsIDefault
End Function

Public Function CreateDisFromNotif(iNotifObj As Variant) As A2Dis
    
    Dim oNotif As A2Notif
    Set oNotif = iNotifObj
    
    If oNotif.IsCancelled = True Then
        Err.Raise vbObjectError, "Attend2A.A2App", "The Notification used to create this Discipline Instance has been cancelled (its condition no longer met) so it cannot be used to create a Discipline Instance."
    End If
    
    Dim oEmp As A2Employee
    Dim oRule As A2Rule
    Dim oAbsGrp As A2AbsGrp
    Dim TriggerNote As String
    
    Set oEmp = oNotif.Employee
    Set oRule = oNotif.Rule
    Set oAbsGrp = CreateAbsGrpX(oNotif.Absences)
    TriggerNote = oNotif.TriggerNote
    
    Set CreateDisFromNotif = CreateDisX(oEmp, oRule, oAbsGrp, TriggerNote)
End Function

Public Function CreateDisX(iForEmp As A2Employee, _
    iRule As A2Rule, iAbsGrp As A2AbsGrp, Optional iTriggerNote As String = "") As A2Dis
    
    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes("AddDis")
    
    Dim empGop As A2GetObjParm
    Dim ruleGop As A2GetObjParm, absGrpGop As A2GetObjParm
    Dim trigGop As A2GetObjParm
    
    Set empGop.parm = lookup.Parameters("emp")
    Set empGop.Val = iForEmp
    Set ruleGop.parm = lookup.Parameters("rule")
    Set ruleGop.Val = iRule
    Set absGrpGop.parm = lookup.Parameters("absGrp")
    Set absGrpGop.Val = iAbsGrp
    Set trigGop.parm = lookup.Parameters("triggerNote")
    trigGop.Val = iTriggerNote
    
    Dim oDis As A2Dis
    Set oDis = mSys.GetObject(mSys.ObjectTypes("Dis"), Array(empGop, ruleGop, absGrpGop, trigGop))
    mSys.Publish a2PubEvTypeDisAdded, oDis
    
    Set CreateDisX = oDis
End Function

Private Sub Class_Initialize()
    Set mSys = New A2System
    
    Dim exAbsAgt As Attend2C.A2ISubscriber
    Dim awolAgt As Attend2C.A2ISubscriber
    Dim Agt6Mo As Attend2C.A2ISubscriber
    'Set exAbsAgt = New A2ExAbsAgent
    'Set exAbsAgt = New A2ExAbsAgent2
    'Set exAbsAgt = New A2ExAbsAgent3
    'Set exAbsAgt = New A2ExAbsAgent4
    'Set exAbsAgt = New A2ExAbsAgent5
    'Set exAbsAgt = New A2ExAbsAgent6
    'Set exAbsAgt = New A2ExAbsAgent7
    'Set exAbsAgt = New A2ExAbsAgent9
    Set exAbsAgt = New A2ExAbsAgent10
    'Set awolAgt = New A2AWOLAgent
    'Set awolAgt = New A2AWOLAgent2
    'Set awolAgt = New A2AWOLAgent3
    'Set Agt6Mo = New A26MonthAgent
    Set mLiaison = New A2ADSLiason
    mSys.Subscribe exAbsAgt
    'mSys.Subscribe awolAgt
    'mSys.Subscribe Agt6Mo

End Sub

Private Sub Class_Terminate()
    If Not mSys Is Nothing Then
        mSys.Logoff
    End If
End Sub

Public Function GetNotifsOpenSince(iSinceDate As Variant) As A2IObjSet
    

    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes("GetOpenNotifTriggeredSince")
    
    Dim gop As A2GetObjParm
    
    Set gop.parm = lookup.Parameters("sinceDate")
    gop.Val = CDate(iSinceDate)
    
    Set GetNotifsOpenSince = mSys.GetObjects(gop)
    
End Function


Public Function GetDisOpenSince(iSinceDate As Variant) As A2IObjSet

    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes("GetOpenDisTriggeredSince")
    
    Dim gop As A2GetObjParm
    
    Set gop.parm = lookup.Parameters("sinceDate")
    gop.Val = CDate(iSinceDate)
    
    Set GetDisOpenSince = mSys.GetObjects(gop)
    
End Function

Public Sub RecheckEveryone()

    Dim allEmps As A2IObjSet
    Set allEmps = Me.CurrentUser.GetViewableEmployees()
    
    Dim vEmp As Variant
    Dim oEmp As A2Employee

    For Each vEmp In allEmps
        Set oEmp = vEmp
        mSys.Publish a2PubEvTypeEmpAltered, oEmp
        Debug.Print oEmp.BadgeNumber
    Next
    
End Sub

Public Property Get CurrentUser() As A2User
    Set CurrentUser = GetCurrentUser
End Property

Public Function GetCurrentUser() As A2User
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_GET_CURRENT_USER)
    
    Set GetCurrentUser = mSys.GetObject(mSys.ObjectTypes(OTA_USER), lookup)
    
End Function

Public Function AddUser(iUserName As String, iDisplayName As String, iSortableName As String, _
            iUserType As A2UserType, iInitialPassword As String) As A2User

    Dim lookup As A2ILookupType

    Set lookup = mSys.LookupTypes(LTA_ADD_USER)
    Dim parmUserName As A2GetObjParm
    Dim parmDisplayName As A2GetObjParm
    Dim parmSortName As A2GetObjParm
    Dim parmUserType As A2GetObjParm
    Dim parmInitialPassword As A2GetObjParm
    Dim parmEmployee As A2GetObjParm
    
    Set parmUserName.parm = lookup.Parameters(LTPA_ADD_USER_USERNAME)
    parmUserName.Val = iUserName
    Set parmDisplayName.parm = lookup.Parameters(LTPA_ADD_USER_DISPLAY_NAME)
    parmDisplayName.Val = iDisplayName
    Set parmSortName.parm = lookup.Parameters(LTPA_ADD_USER_SORT_NAME)
    parmSortName.Val = iSortableName
    Set parmUserType.parm = lookup.Parameters(LTPA_ADD_USER_USER_TYPE)
    Set parmUserType.Val = iUserType
    Set parmInitialPassword.parm = lookup.Parameters(LTPA_ADD_USER_INITIAL_PASSWORD)
    parmInitialPassword.Val = iInitialPassword
    
    Set AddUser = mSys.GetObject(mSys.ObjectTypes(OTA_USER), _
        Array(parmUserName, parmDisplayName, parmSortName, parmUserType, _
            parmInitialPassword))

End Function


Public Function GetOpenNotifications(Optional iViolations As Boolean = True, _
                                                Optional iWarnings As Boolean = False, _
                                                Optional iInformational As Boolean = False)
    
    Dim lookup As A2ILookupType
    Dim prmViol As A2ILookupTypeParm
    Dim prmWarn As A2ILookupTypeParm
    Dim prmInfo As A2ILookupTypeParm
    
    Set lookup = mSys.LookupTypes(LTA_OPEN_NOTIF_FOR_USER)
    
    Set prmViol = lookup.Parameters(LTPA_OPEN_NOTIF_USER_SHOW_VIOL)
    Set prmWarn = lookup.Parameters(LTPA_OPEN_NOTIF_USER_SHOW_WARN)
    Set prmInfo = lookup.Parameters(LTPA_OPEN_NOTIF_USER_SHOW_INFO)
    
    Dim gopViol As A2GetObjParm, gopWarn As A2GetObjParm, gopInfo As A2GetObjParm
    Set gopViol.parm = prmViol
    gopViol.Val = iViolations
    Set gopWarn.parm = prmWarn
    gopWarn.Val = iWarnings
    Set gopInfo.parm = prmInfo
    gopInfo.Val = iInformational
    
    Set GetOpenNotifications = mSys.GetObjects(Array(gopViol, gopWarn, gopInfo))
End Function

Public Function GetRandomNotifSample(iFromDate As Date, _
                                                            iToDate As Date) As A2IObjSet
                                                            
    Dim lookup As A2ILookupType
    Dim fromDateParm As A2ILookupTypeParm
    Dim toDateParm As A2ILookupTypeParm
    Set lookup = mSys.LookupTypes(LTA_GET_RANDOM_NOTIFS)
    Set fromDateParm = lookup.Parameters(LTA_GET_RANDOM_NOTIFS_FROM_DATE)
    Set toDateParm = lookup.Parameters(LTA_GET_RANDOM_NOTIFS_TO_DATE)
    
    Dim gopFromDate As A2GetObjParm
    Dim gopToDate As A2GetObjParm
    
    Set gopFromDate.parm = fromDateParm
    gopFromDate.Val = iFromDate
    Set gopToDate.parm = toDateParm
    gopToDate.Val = iToDate
    
    Set GetRandomNotifSample = mSys.GetObjects(Array(gopFromDate, gopToDate))
End Function

Public Function GetRecentAbsences(iSinceDate As Date, _
                                    Optional iInclProtected As Boolean = False, _
                                    Optional iInclUnprotected As Boolean = True) As A2IObjSet
    Dim dateParm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
        
    Set lookup = mSys.LookupTypes(LTA_RECENT_ABS_FOR_USER)
    Set dateParm = lookup.Parameters(LTPA_RECENT_ABS_FOR_USER_SINCE_DATE)
    
    Dim gopDate As A2GetObjParm
    Dim gopProt As A2GetObjParm
    Dim gopUnProt As A2GetObjParm
    
    
    Set gopDate.parm = dateParm
    gopDate.Val = iSinceDate
    Set gopProt.parm = lookup.Parameters(LTPA_RECENT_ABS_FOR_USER_PROT)
    gopProt.Val = iInclProtected
    Set gopUnProt.parm = lookup.Parameters(LTPA_RECENT_ABS_FOR_USER_UNPROT)
    gopUnProt.Val = iInclUnprotected
    
    Set GetRecentAbsences = mSys.GetObjects(Array(gopDate, gopProt, gopUnProt))
End Function

Public Function GetEncryptedPassword(iPassword As String) As String
    GetEncryptedPassword = mSys.GetPassword(iPassword)
End Function

Public Function GetRecentExtAbsences(iSinceDate As Date, _
                                    Optional iInclProtected As Boolean = False, _
                                    Optional iInclUnprotected As Boolean = True) As A2IObjSet
    Dim dateParm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_GET_RECENT_EXT_ABS_FOR_USER)
    Set dateParm = lookup.Parameters(LTPA_RECENT_EXT_ABS_FOR_USER_SINCE_DATE)
    
    Dim gopDate As A2GetObjParm
    Dim gopProt As A2GetObjParm
    Dim gopUnProt As A2GetObjParm
    
    Set gopDate.parm = dateParm
    gopDate.Val = iSinceDate
    Set gopProt.parm = lookup.Parameters(LTPA_RECENT_EXT_ABS_FOR_USER_INC_PROTECTED)
    gopProt.Val = iInclProtected
    Set gopUnProt.parm = lookup.Parameters(LTPA_RECENT_EXT_ABS_FOR_USER_INC_UNPROTECTED)
    gopUnProt.Val = iInclUnprotected
    
    Set GetRecentExtAbsences = mSys.GetObjects(Array(gopDate, gopProt, gopUnProt))
End Function

Public Function GetOpenDisciplineInstances() As A2IObjSet
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_OPEN_DIS_FOR_USER)
    
    Set GetOpenDisciplineInstances = mSys.GetObjects(lookup)
End Function

Public Function GetOpenExtNotifForWatchedEmps() As A2IObjSet
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_OPEN_EXT_NOTIF_FOR_WATCHED)
    
    Set GetOpenExtNotifForWatchedEmps = mSys.GetObjects(lookup)
End Function

Public Function GetOpenExtNotif(iSinceDate As Date) As A2IObjSet
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_OPEN_EXT_NOTIF)
    Dim parm As A2GetObjParm
    Set parm.parm = lookup.Parameters(LTPA_OPEN_EXT_NOTIF_SINCE_DATE)
    parm.Val = iSinceDate
    
    Set GetOpenExtNotif = mSys.GetObjects(parm)
End Function

Public Function GetAllSecurityOverrides(includeInactive As Boolean) As A2IObjSet
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_GET_ALL_SEC_OVERRIDES)
    Dim parm As A2GetObjParm
    Set parm.parm = lookup.Parameters(LTPA_GET_ALL_SEC_OVERRIDES_INCL_INACTIVE)
    parm.Val = includeInactive
    
    Set GetAllSecurityOverrides = mSys.GetObjects(parm)
End Function

Public Function AddSecurityOverride(iUser As A2User, iAreaNum As Long, iCanView As Boolean, iCanAlter As Boolean) As A2SecOverride
    Dim lookup As A2ILookupType
        
    Set lookup = mSys.LookupTypes(LTA_ADD_SEC_OVERRIDE)
    Dim parmUser As A2GetObjParm
    Dim parmArea As A2GetObjParm
    Dim parmCanView As A2GetObjParm
    Dim parmCanAlter As A2GetObjParm
    
    Set parmUser.parm = lookup.Parameters(LTPA_ADD_SEC_OVERRIDE_USER)
    Set parmUser.Val = iUser
    
    Set parmArea.parm = lookup.Parameters(LTPA_ADD_SEC_AREA_NUM)
     parmArea.Val = iAreaNum
    
    Set parmCanView.parm = lookup.Parameters(LTPA_ADD_SEC_CAN_VIEW)
     parmCanView.Val = iCanView
    
    Set parmCanAlter.parm = lookup.Parameters(LTPA_ADD_SEC_CAN_ALTER)
     parmCanAlter.Val = iCanAlter
    
    Set AddSecurityOverride = mSys.GetObject(mSys.ObjectTypes(OTA_SEC_OVERRIDE), Array(parmUser, parmArea, parmCanView, parmCanAlter))
End Function

Public Function GetAllUsers() As A2IObjSet
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_GET_ALL_USERS)
    
    Set GetAllUsers = mSys.GetObjects(lookup)
End Function

Public Property Get AppVersion() As String
    AppVersion = VB.App.Major & "." & VB.App.Minor & "." & VB.App.Revision
End Property
