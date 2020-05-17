VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A26MonthAgent"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements A2ISubscriber

Private mSys As A2System

Private Const RULE_ALIAS As String = "longterm"
Private mRule As A2Rule

Private Const POLICY_EFF_DATE As Date = #5/23/2005#

Private Const NOTIF_TYPE_ALIAS As String = "longterm"

Private Const NUMBER_OF_DAYS As Integer = 180

Private mNotType As A2NotifType

Private mSrc As A2Source
Private mSrcObjType As A2IObjType

' Excessive Absence Agent

Private Sub A2ISubscriber_Accept( _
    iSys As A2System, iEventType As a2PubEventType, _
    iObj As A2IObject)

    Dim oEmp As A2Employee
    Dim oAbs As A2Abs
    Dim oDis As A2Dis
    'Set oAbs = iObj
    'Set oEmp = oAbs.Employee

If iEventType = a2PubEvTypeAbsAdded Or _
    iEventType = a2PubEvTypeAbsAltered Or _
    iEventType = a2PubEvTypeAbsReplaced Then
        Set oAbs = iObj
        Set oEmp = oAbs.Employee
End If

If iEventType = a2PubEvTypeDisAdded Or _
    iEventType = a2PubEvTypeDisAltered Then
        Set oDis = iObj
        Set oEmp = oDis.Employee
End If


If iEventType = a2PubEvTypeEmpAdded Or _
    iEventType = a2PubEvTypeEmpAltered Then
        Set oEmp = iObj
End If

If iEventType = a2PubEvTypeAbsAdded Or _
    iEventType = a2PubEvTypeAbsAltered Or _
    iEventType = a2PubEvTypeAbsReplaced Or _
     iEventType = a2PubEvTypeDisAdded Or _
     iEventType = a2PubEvTypeDisAltered Or _
     iEventType = a2PubEvTypeEmpAdded Or _
     iEventType = a2PubEvTypeEmpAltered Then
     
    Set mSys = iSys
    
    If mSrcObjType Is Nothing Then
        Set mSrcObjType = mSys.ObjectTypes("Src")
    End If
    
    If mSrc Is Nothing Then
        Set mSrc = mSys.GetObject(mSrcObjType, 1)
    End If
    
    Dim doNotify As Boolean
    doNotify = False
    
    Dim oLastDayAbs As A2Abs
    Dim oTriggerDay As A2Abs
    
    oEmp.Attributes.Refresh
    
    If IsNull(oEmp.LastDateWorked) Then
        If oEmp.IsInactive = False Then
            doNotify = True
            Set oLastDayAbs = GetAbsFromEmpAndDate(oEmp, DateAdd("d", NUMBER_OF_DAYS * -1, POLICY_EFF_DATE))
            If oLastDayAbs Is Nothing Then
                Set oLastDayAbs = CreateAbsenceX(oEmp, DateAdd("d", NUMBER_OF_DAYS * -1, POLICY_EFF_DATE), mSrc)
            End If
            Set oTriggerDay = GetAbsFromEmpAndDate(oEmp, POLICY_EFF_DATE)
            If oTriggerDay Is Nothing Then
                Set oTriggerDay = CreateAbsenceX(oEmp, POLICY_EFF_DATE, mSrc)
            End If
        End If
    Else
    
        If oEmp.IsInactive = False Then
            If DateDiff("d", oEmp.LastDateWorked, Now()) >= NUMBER_OF_DAYS Then
                doNotify = True
                Set oLastDayAbs = GetAbsFromEmpAndDate(oEmp, oEmp.LastDateWorked)
                Set oTriggerDay = GetAbsFromEmpAndDate(oEmp, DateAdd("d", NUMBER_OF_DAYS, oLastDayAbs.OnDate))
                If oTriggerDay Is Nothing Then
                    Set oTriggerDay = CreateAbsenceX(oEmp, DateAdd("d", NUMBER_OF_DAYS, oLastDayAbs.OnDate), mSrc)
                End If
            End If
        End If
    End If
    
    Dim absCalSet As A2IObjSet
    Dim absCalV As Variant
    Dim absCal As A2AbsCalDay
    Dim localBool As Boolean
    
    If doNotify = True Then
        Set absCalSet = oEmp.GetAbsenceCalendar(oLastDayAbs.OnDate, oTriggerDay.OnDate)
        If absCalSet.Count = 0 Then
            doNotify = False
        Else
            localBool = False
            For Each absCalV In absCalSet
                Set absCal = absCalV
                If absCal.IsProtected Or absCal.IsUnprotected Or absCal.IsWorked Then
                    localBool = True
                    Exit For
                End If
            Next
            If localBool = False Then
                doNotify = False
            End If
        End If
    End If
    
    Dim notifs As A2IObjSet
    
    Dim vNotif As Variant, oNotif As A2Notif
    
    
    Dim absSet As A2ObjSet
    Set absSet = New A2ObjSet
    absSet.coll.Add oLastDayAbs
    absSet.coll.Add oTriggerDay
    
    Dim foundNotifAlready As Boolean
    foundNotifAlready = False
    
    If doNotify = True Then
    
        Set notifs = oEmp.GetNotif(True)
        
        For Each vNotif In notifs
            Set oNotif = vNotif
            If oNotif.NotifType.Alias = NOTIF_TYPE_ALIAS Then
                If oNotif.Absences.IsEqualTo(absSet.AsIObjSet) Then
                    If foundNotifAlready = True Then
                        oNotif.Cancel
                    Else
                        foundNotifAlready = True
                        localBool = True
                    End If
                Else
                    oNotif.Cancel
                End If
            End If
        Next
        
        If localBool = False Then
            CreateNotif oEmp, oLastDayAbs, oTriggerDay
        End If
    
    Else
        Set notifs = oEmp.GetNotif(True)
        
        For Each vNotif In notifs
            Set oNotif = vNotif
            If oNotif.NotifType.Alias = NOTIF_TYPE_ALIAS Then
                    oNotif.Cancel
            End If
        Next
    End If
        
End If

End Sub

Private Sub CreateNotif(iEmp As A2Employee, oAbs As A2Abs, oTriggerAbs As A2Abs)
    Dim Rule As A2Rule
    Set Rule = RuleObj
    
    Dim iAbsSet As A2IObjSet
    Set iAbsSet = New A2ObjSet
    Dim oSet As A2ObjSet
    Set oSet = iAbsSet
    oSet.coll.Add oAbs
    oSet.coll.Add oTriggerAbs
    
    Dim oAbsGrp As A2AbsGrp
    Set oAbsGrp = CreateAbsGrp(iAbsSet)

    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes("AddNotif")

    Dim oNotType As A2NotifType
    Set oNotType = GetNotifType

    

    Dim empGop As A2GetObjParm, notTypeGop As A2GetObjParm
    Dim ruleGop As A2GetObjParm, absGrpGop As A2GetObjParm

    Set empGop.parm = lookup.Parameters("emp")
    Set empGop.Val = iEmp
    Set notTypeGop.parm = lookup.Parameters("notType")
    Set notTypeGop.Val = oNotType
    Set ruleGop.parm = lookup.Parameters("rule")
    Set ruleGop.Val = Rule
    Set absGrpGop.parm = lookup.Parameters("absGrp")
    Set absGrpGop.Val = oAbsGrp

    mSys.GetObjects Array(empGop, notTypeGop, ruleGop, absGrpGop)
    
End Sub



Private Function GetNotTypeFromAlias(iAlias As String) As A2NotifType

    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes("GetNotifTypeFromAlias")
    
    Dim parm As A2ILookupTypeParm
    Set parm = lookup.Parameters("alias")
    
    Dim gop As A2GetObjParm
    Set gop.parm = parm
    gop.Val = iAlias
    
    Set GetNotTypeFromAlias = mSys.GetObject(mSys.ObjectTypes("NotifType"), gop)

End Function

Private Function GetNotifType() As A2NotifType
    If mNotType Is Nothing Then
        Set mNotType = GetNotTypeFromAlias(NOTIF_TYPE_ALIAS)
    End If
    
    Set GetNotifType = mNotType
End Function

Private Function GetRuleObj(iAlias As String) As A2Rule
    
    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes("GetRuleFromAlias")
    
    Dim parm As A2ILookupTypeParm
    Set parm = lookup.Parameters("alias")
    
    Dim gop As A2GetObjParm
    Set gop.parm = parm
    gop.Val = iAlias
    
    Set GetRuleObj = mSys.GetObject(mSys.ObjectTypes("Rule"), gop)


End Function

Private Property Get RuleObj() As A2Rule
    If mRule Is Nothing Then
        Set mRule = GetRuleObj(RULE_ALIAS)
    End If
    
    Set RuleObj = mRule
End Property

Private Function CreateAbsGrp(objSet As A2IObjSet) As A2AbsGrp
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
    
    Set CreateAbsGrp = oAbsGrp
End Function

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

Private Sub Class_Initialize()
    Set mSrc = Nothing
    Set mSrcObjType = Nothing
End Sub

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

