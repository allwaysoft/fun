VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2AWOLAgent"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements A2ISubscriber

Private mColRuleUDTs As Collection

Private mSys As A2System

Private Const RULE_ALIAS_SINGLE As String = "awol1"
Private mSingleRule As A2Rule
Private Const RULE_ALIAS_MULTIPLE As String = "awol2"
Private mMultipleRule As A2Rule

Private Const MAX_DAYS_TO_SEARCH As Integer = 7

Private Const POLICY_EFF_DATE As Date = #5/23/2005#

Private Type xa2ExaminedAWOL
    awolAbs As A2Abs
    isMultiple As Boolean
    multipleNum As Integer
End Type

Private Const NOTIF_TYPE_ALIAS_VIOL As String = "awolViol"

Private mNotType As A2NotifType
Private mAWOLAbsType As A2AbsType

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
    
    Dim currDate As Date, twoYearsAgo As Date
    currDate = iSys.OperatingDate
    twoYearsAgo = DateAdd("yyyy", -2, currDate)
    
    If twoYearsAgo < POLICY_EFF_DATE Then
        twoYearsAgo = POLICY_EFF_DATE
    End If
    
    Dim nextMultipleNum As Integer
    nextMultipleNum = 1
    
    ' We're looking for any AWOLs in the past two years that are not already
    ' in an open, effective, or waived Dis.
    
    Dim absLookup As A2ILookupType
    Set absLookup = mSys.LookupTypes("GetAbsForEmpWithType")
    Dim absGopEmp As A2GetObjParm, absGopType As A2GetObjParm
    Set absGopEmp.parm = absLookup.Parameters("emp")
    Set absGopEmp.Val = oEmp
    Set absGopType.parm = absLookup.Parameters("absType")
    Set absGopType.Val = GetAWOLAbsType
    
    
    ' 1. Get all AWOLS in past two years into a collection
    
    Dim awolAbs As A2IObjSet
    Set awolAbs = mSys.GetObjects(Array(absGopEmp, absGopType))
    
    ' 2. Remove any AWOLs that are already in an OPEN or EFFECTIVE or WAIVED Discipline Instance
    
    Dim collAWOLs As A2IObjSet
    Set collAWOLs = GetFilteredAWOLs(awolAbs, twoYearsAgo)
    
    Dim collExaminedAWOLs() As xa2ExaminedAWOL
    
    ReDim collExaminedAWOLs(collAWOLs.Count)
    
    Dim collAbsSets As Collection
    Set collAbsSets = New Collection
    
    Dim oAbsSet As A2ObjSet
    
    Dim vAbsAwol As Variant, oAbsAwol As A2Abs
    
    Dim prevAWOL As A2Abs
    Set prevAWOL = Nothing
    
    Dim iAwol As Integer
    iAwol = 0
    
    Dim localIsMultiple As Boolean
    
    ' 3. For each remaining AWOL:
    For Each vAbsAwol In collAWOLs
        Set oAbsAwol = vAbsAwol
        Set collExaminedAWOLs(iAwol).awolAbs = oAbsAwol
        
        localIsMultiple = False
        
        If prevAWOL Is Nothing Then
            localIsMultiple = False
        Else
            If AnyNonAWOLDaysBetween(prevAWOL, oAbsAwol) Then
                localIsMultiple = False
            Else
                localIsMultiple = True
            End If
        End If
            
        If localIsMultiple = False Then
        ' if there are any NON-AWOL days between this AWOL and the PREVIOUS Awol (or if there
        '   are no previous AWOLs), then this is a SINGLE AWOL INSTANCE (rule awol1)
            collExaminedAWOLs(iAwol).isMultiple = False
            collExaminedAWOLs(iAwol).multipleNum = nextMultipleNum
            Set oAbsSet = New A2ObjSet
            oAbsSet.coll.Add oAbsAwol
            collAbsSets.Add oAbsSet, CStr(nextMultipleNum)
            nextMultipleNum = nextMultipleNum + 1
        Else
        
        ' if there are no NON-AWOL days between this AWOL and the previous AWOL, this is a
        '   MULTIPLE AWOL INSTANCE. If the previous AWOL already has a 'multiple' code set,
        '   set THIS AWOL to the same multiple code. If the previous AWOL does NOT have a
        '   multiple code set, create a new multiple code and apply it to this and the previous
        '   AWOL.
            If collExaminedAWOLs(iAwol - 1).isMultiple = True Then
                collExaminedAWOLs(iAwol).isMultiple = True
                collExaminedAWOLs(iAwol).multipleNum = collExaminedAWOLs(iAwol - 1).multipleNum
                collAbsSets(CStr(collExaminedAWOLs(iAwol - 1).multipleNum)).coll.Add oAbsAwol
            Else
                collAbsSets.Remove CStr(collExaminedAWOLs(iAwol - 1).multipleNum)
                
                Set oAbsSet = New A2ObjSet
                oAbsSet.coll.Add prevAWOL
                oAbsSet.coll.Add oAbsAwol
                collAbsSets.Add oAbsSet, CStr(collExaminedAWOLs(iAwol - 1).multipleNum)
                
                collExaminedAWOLs(iAwol).isMultiple = True
                collExaminedAWOLs(iAwol - 1).isMultiple = True
                collExaminedAWOLs(iAwol).multipleNum = collExaminedAWOLs(iAwol - 1).multipleNum
                'collExaminedAWOLs(iAwol - 1).multipleNum = nextMultipleNum
                'nextMultipleNum = nextMultipleNum + 1
            End If
        End If
    
        iAwol = iAwol + 1
        Set prevAWOL = oAbsAwol
    Next
    
    Dim notifs As A2IObjSet
    
    Dim collAbsNotifs As A2IObjSet, vNotif As Variant, oNotif As A2Notif
    
    Dim localBool As Boolean
    
    Dim LastDateWorked As Date
    LastDateWorked = #1/1/1970#
    oEmp.Attributes.Refresh
    If Not IsNull(oEmp.LastDateWorked) Then
        LastDateWorked = CDate(oEmp.LastDateWorked)
    End If
    
    Dim showAsWarning As Boolean
    If LastDateWorked >= Now() Then
        showAsWarning = False
    Else
        showAsWarning = True
    End If
    
    Dim iGroup As Integer
    If nextMultipleNum > 1 And oEmp.IsInactive = False Then
    
        Set notifs = oEmp.GetNotif(True)
        
        ' 1. Cancel any notifs that don't belong.
        For Each vNotif In notifs
            Set oNotif = vNotif
            If oNotif.NotifType.Alias = NOTIF_TYPE_ALIAS_VIOL And (oNotif.Rule.Alias = RULE_ALIAS_SINGLE Or oNotif.Rule.Alias = RULE_ALIAS_MULTIPLE) Then
                localBool = False
                
                For iGroup = 1 To (nextMultipleNum - 1)
                    Set oAbsSet = collAbsSets(CStr(iGroup))
                    If oNotif.Absences.IsEqualTo(oAbsSet) Then
                        localBool = True
                        Exit For
                    End If
                Next
            
                If localBool = False Then
                    oNotif.Cancel
                End If
            End If
        Next
        
        Set notifs = oEmp.GetNotif(True)
        
        ' 2. Add any notifs that are missing.
        For iGroup = 1 To (nextMultipleNum - 1)
            Set oAbsSet = collAbsSets(CStr(iGroup))
            localBool = False
        
            For Each vNotif In notifs
                Set oNotif = vNotif
                If oNotif.NotifType.Alias = NOTIF_TYPE_ALIAS_VIOL And (oNotif.Rule.Alias = RULE_ALIAS_SINGLE Or oNotif.Rule.Alias = RULE_ALIAS_MULTIPLE) Then
                    If oNotif.Absences.IsEqualTo(oAbsSet) Then
                        localBool = True
                        Exit For
                    End If
                End If
            Next
            
            If localBool = False Then
                CreateNotif oEmp, oAbsSet
            End If
        Next
    Else
        Set notifs = oEmp.GetNotif(True)
        
        For Each vNotif In notifs
            Set oNotif = vNotif
            If oNotif.NotifType.Alias = NOTIF_TYPE_ALIAS_VIOL And (oNotif.Rule.Alias = RULE_ALIAS_SINGLE Or oNotif.Rule.Alias = RULE_ALIAS_MULTIPLE) Then
                    oNotif.Cancel
            End If
        Next
    End If
        
    
End If


End Sub

Private Sub CreateNotif(iEmp, iAbsSet As A2IObjSet)
    Dim Rule As A2Rule
    If iAbsSet.Count = 1 Then
        Set Rule = SingleRule
    Else
        Set Rule = MultipleRule
    End If
    
    Dim oAbsGrp As A2AbsGrp
    Set oAbsGrp = CreateAbsGrp(iAbsSet)

    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes("AddNotif")

    Dim oNotType As A2NotifType
    Set oNotType = AWOLNotifType

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

Private Property Get SingleRule() As A2Rule
    If mSingleRule Is Nothing Then
        Set mSingleRule = GetRuleObj(RULE_ALIAS_SINGLE)
    End If
    
    Set SingleRule = mSingleRule
End Property


Private Property Get MultipleRule() As A2Rule
    If mMultipleRule Is Nothing Then
        Set mMultipleRule = GetRuleObj(RULE_ALIAS_MULTIPLE)
    End If
    
    Set MultipleRule = mMultipleRule
End Property

Private Property Get AWOLNotifType() As A2NotifType
    If mNotType Is Nothing Then
        Set mNotType = GetNotTypeFromAlias(NOTIF_TYPE_ALIAS_VIOL)
    End If
    
    Set AWOLNotifType = mNotType
End Property


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


Private Function GetAWOLAbsType() As A2AbsType
    If mAWOLAbsType Is Nothing Then
        Dim lookup As A2ILookupType
        Set lookup = mSys.LookupTypes("GetAbsTypeByAlias")
        Dim gop As A2GetObjParm
        Set gop.parm = lookup.Parameters("alias")
        gop.Val = "awol"
        Set mAWOLAbsType = mSys.GetObject(mSys.ObjectTypes("AbsType"), gop)
    End If
    
    If mAWOLAbsType Is Nothing Then
        Err.Raise vbObjectError, "Attend2A.A2AWOLAgent", "AWOL absence type not available"
    Else
        Set GetAWOLAbsType = mAWOLAbsType
    End If
End Function

Private Function AnyNonAWOLDaysBetween(oAWOL1 As A2Abs, oAWOL2 As A2Abs) As Boolean

    Dim daysDiff As Long
    Dim firstDate As Date
    firstDate = oAWOL1.OnDate
    
    daysDiff = DateDiff("d", firstDate, oAWOL2.OnDate) - 1
    
    Dim interAbs As A2Abs
    Dim emp As A2Employee
    
    Dim i As Long, newDate As Date
    
    If daysDiff > MAX_DAYS_TO_SEARCH Then
        AnyNonAWOLDaysBetween = True
        Exit Function
    End If
    
    If daysDiff = 0 Then
        AnyNonAWOLDaysBetween = False
        Exit Function
    Else
        Set emp = oAWOL1.Employee
        ' we need to check every day between the two and see if there is anything coded (anything at all)
        For i = 1 To daysDiff
            newDate = DateAdd("d", i, firstDate)
            Set interAbs = GetAbsFromEmpAndDate(emp, newDate)
            If Not interAbs Is Nothing Then
                If interAbs.Types.Count > 0 Then
                    ' OK! Found one!
                    AnyNonAWOLDaysBetween = True
                    Exit Function
                End If
            End If
        Next
    End If

    AnyNonAWOLDaysBetween = False

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

Private Function GetFilteredAWOLs(overallColl As A2IObjSet, startingDate As Date) As A2IObjSet
    Dim objSet As A2ObjSet
    Set objSet = New A2ObjSet
    

    Dim vAbs As Variant, oAbs As A2Abs
    Dim disColl As A2IObjSet, vDis As Variant, oDis As A2Dis
    Dim localBool As Boolean
    
    For Each vAbs In overallColl
    
        Set oAbs = vAbs
        If oAbs.OnDate >= startingDate Then
            Set disColl = oAbs.GetContainingDis(False)
            localBool = True   ' false if the abs is in an open/eff/waived dis
            
            If disColl.Count > 0 Then
                For Each vDis In disColl
                    Set oDis = vDis
                    If oDis.Status = a2DisStatusEffective Or oDis.Status = a2DisStatusOpen Or oDis.Status = a2DisStatusWaived Then
                        localBool = False
                    End If
                Next
            End If
            
            If localBool = True Then
                objSet.coll.Add oAbs
            End If
        End If
    Next
    
    Set GetFilteredAWOLs = objSet
End Function
