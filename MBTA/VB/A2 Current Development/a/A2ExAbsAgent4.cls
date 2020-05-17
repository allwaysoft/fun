VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2ExAbsAgent4"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' EXCESSIVE ABSENTEEISM
' NOTIFICATION AGENT
'   VERSION 4

' Changes for this version:
'   - never have one instance of absence _trigger_ (be the last instance for) more than one
'     notification/discipline
'   - add handling for the 'deferred' discipline status -- indicates that ALL the
'     instances in that dis together (and alone) should never be notified again on
'     the same rule that the dis was for

Implements A2ISubscriber
'
'Public Type CaughtDay
'    abs As A2Abs
'    ruleNum As Integer
'    warnOnlyLevel As Boolean
'End Type
'
'Public Type ExAbsRule
'    ruleAlias As String
'    ruleNbr As Integer
'    ruleN As Integer
'    ruleM As Integer
'    ruleObject As A2Rule
'End Type

Private mColRuleUDTs As Collection

Private mSys As A2System

Private Const RULE_ALIAS_3IN1 As String = "ex3d1m"
Private Const RULE_ALIAS_5IN3 As String = "ex5d3m"
Private Const RULE_ALIAS_7IN6 As String = "ex7d6m"
Private Const RULE_ALIAS_9IN9 As String = "ex9d9m"
Private Const RULE_ALIAS_10IN12 As String = "ex10d12m"
Private Const RULE_ALIAS_12IN16 As String = "ex12d16m"
Private Const RULE_ALIAS_14IN20 As String = "ex14d20m"
Private Const RULE_ALIAS_16IN24 As String = "ex16d24m"

Private Const NOTIF_TYPE_ALIAS_VIOL As String = "exAbsViol"
Private Const NOTIF_TYPE_ALIAS_VIOL_NR As String = "exAbsViolNotRet"
Private Const NOTIF_TYPE_ALIAS_INFO As String = "exAbsInfo"

Private Const POLICY_EFF_DATE As Date = #5/23/2005#

Private Const INSTANCE_CUT_LIMIT As Integer = 6

Private mNotTypeViol As A2NotifType
Private mNotTypeViolNR As A2NotifType
Private mNotTypeInfo As A2NotifType

Private mAllDisContainingAbs As Scripting.Dictionary 'including deferred/cancelled/waived
Private mDisContainingAbs As Scripting.Dictionary
Private mNotifContainingAbs As Scripting.Dictionary

Private mInstances As Scripting.Dictionary
Private mInstanceForAbs As Scripting.Dictionary
Private mIsInstanceDis As Scripting.Dictionary
Private mIsInstanceDeferred As Scripting.Dictionary
Private mDidInstanceTriggerDis As Scripting.Dictionary
Private mIsInstanceWaived As Scripting.Dictionary

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
    
    '1.  Create an empty collection of "caught days", where a caught day is defined as:
    '       Absence + Rule + WarnOnlyLevel bit. It will be referred to as cdc.
    Dim cdc As Scripting.Dictionary
    Set cdc = New Scripting.Dictionary
    
    Set mDisContainingAbs = New Scripting.Dictionary
    Set mNotifContainingAbs = New Scripting.Dictionary
    Set mInstances = New Scripting.Dictionary
    Set mInstanceForAbs = New Scripting.Dictionary
    Set mIsInstanceDis = New Scripting.Dictionary
    Set mIsInstanceDeferred = New Scripting.Dictionary
    Set mDidInstanceTriggerDis = New Scripting.Dictionary
    Set mAllDisContainingAbs = New Scripting.Dictionary
    Set mIsInstanceWaived = New Scripting.Dictionary
    
    '2.  Get all unprotected Absences (absences with a primary absence type not falling
    '       into the 'Protected' group) for the Employee in the past two years, excluding any
    '       waived Absences.
    Dim unprotAbs As A2IObjSet
    'Set unprotAbs = oEmp.GetUnprotUnwaivedAbs(twoYearsAgo)
    Dim tmpUnprotAbs As A2IObjSet
    Set tmpUnprotAbs = oEmp.GetUnprotectedAbsences(twoYearsAgo)
    
    
    Dim absV As Variant
    Dim prevAbs As A2Abs
    Dim prevDate As Date
    Set prevAbs = Nothing
    Dim currAbs As A2Abs
    Dim currAbsDate As Date
    Dim instanceNumber As Long
    instanceNumber = 0
    Dim groupNumber As Integer
    groupNumber = 1
    
    Dim dayHasWork As Boolean
    Dim absCalSet As A2IObjSet
    Dim absCalV As Variant
    Dim absCal As A2AbsCalDay
    
    Dim absInInst As A2ObjSet
    
    ' 2a. Step through all of the absences in order.
    For Each absV In tmpUnprotAbs
        Set currAbs = absV
        ' if there is no previous absence
        If prevAbs Is Nothing Then
            currAbsDate = currAbs.OnDate
            ' start a new instance
            instanceNumber = instanceNumber + 1
            Set absInInst = New A2ObjSet
        Else
            prevDate = prevAbs.OnDate
            currAbsDate = currAbs.OnDate
            
            dayHasWork = False
            
            Set absCalSet = oEmp.GetAbsenceCalendar(DateAdd("d", 1, prevDate), currAbsDate)
            For Each absCalV In absCalSet
                Set absCal = absCalV
                If absCal.IsWorked Then
                    dayHasWork = True
                    Exit For
                End If
                
                ' An instance in this case is defined as
                '   THE SET OF ABSENCES BETWEEN TWO PERIODS OF _WORK_
                'If absCal.IsProtected Then
                '    dayHasWork = True
                '    Exit For
                'End If
            Next
            
            ' if there is _any_ work or protected absence in the intervening days
            If dayHasWork = True Then
                ' start a new instance
                instanceNumber = instanceNumber + 1
                Set absInInst = New A2ObjSet
            ' else
            Else
                ' if the instance is longer than the 'cut limit'
                
                'If absInInst.coll.Count >= INSTANCE_CUT_LIMIT Then
                '    instanceNumber = instanceNumber + 1
                '    Set absInInst = New A2ObjSet
                'End If
                
                ' continue the same instance
            End If
            
        End If
        
        
        If mInstances.Exists(CStr(instanceNumber)) Then
            Set absInInst = mInstances.Item(CStr(instanceNumber))
            absInInst.coll.Add currAbs
        Else
            absInInst.coll.Add currAbs
            mInstances.Add CStr(instanceNumber), absInInst
        End If
        mInstanceForAbs.Add CStr(Format(currAbsDate, "yyyymmdd")), CStr(instanceNumber)
        Set prevAbs = currAbs
    Next
    
    Set unprotAbs = GetFilteredAbs(tmpUnprotAbs)
    
    '3.  Get the last date worked for this emp
    Dim LastDateWorked As Date
    LastDateWorked = #1/1/1970#
    oEmp.Attributes.Refresh
    If Not IsNull(oEmp.LastDateWorked) Then
        LastDateWorked = CDate(oEmp.LastDateWorked)
    End If
    
    'Variable n will mean the Rule's Absence day threshold, and m will represent
    'the month threshold.
    Dim n As Integer, m As Integer, monthDiff As Integer
    Dim c As A2Abs, l As A2Abs, v As Variant
    Dim absIdx As Integer
    Dim absIdxCDC As Integer
    
    Dim allRules As Collection
    Set allRules = Rules
    
    '4.  For each Rule in the excessive absenteeism progression
    Dim Rule As ExAbsRule
    Dim ruleIdx As Integer
    For ruleIdx = 1 To 8 Step 1
        
        v = allRules(CLng(ruleIdx))
        Rule = v
        n = Rule.ruleN
        m = Rule.ruleM
        
        'a.  Determine if the total number of Absences in the two year period is
        '   equal to or greater than n. If not, stop processing
        If unprotAbs.Count < n Then
            GoTo EndOfRuleLoop
        End If
            
        'b.  For each unprotected Absence in the past two years. The current Absence
        '   is identified as c.
        absIdx = 1
        For Each v In unprotAbs
            Set c = v
            
            'i.  Step out n Absences after c. That Absence will be identified as l (for last).
            '   If there are not n MORE Absences after c, move to the next Rule.
            If unprotAbs.Count < (absIdx + n - 1) Then
                GoTo NextRule
            End If
            
            Set l = unprotAbs(absIdx + n - 1)
            
            'ii. Determine the number of months between the c and l. If the number of
            '   months is less than or equal to m:
            monthDiff = GetMonthDiff(c.OnDate, l.OnDate)
            
            If monthDiff > m Then
                GoTo NextAbs
            End If
            
            ' First stop on any local (CDC) items, as if we catch on those, we won't have
            ' to bother getting values from the database
            
            'If ANY of the Absences between c and l are already in a Discipline
            'Instance of status 'Open' or 'Effective' FOR THIS RULE, STOP
            If AnyAbsInCDC(oEmp, cdc, unprotAbs, absIdx, absIdx + n - 1, ruleIdx) Then
                GoTo NextAbs
            End If
            
            ' If any instance is in the CDC for the SAME rule, stop
            If AnyInstInCDC(oEmp, cdc, unprotAbs, absIdx, absIdx + n - 1, ruleIdx) Then
                GoTo NextAbs
            End If
            
            ' If the last instance in this group triggered any group in the CDC, stop
            If LastInstTriggeredCDC(oEmp, cdc, unprotAbs, absIdx, absIdx + n - 1) Then
                GoTo NextAbs
            End If
            
            ' If ALL instances are in the CDC for any rule, stop
            If AllInstInCDC(oEmp, cdc, unprotAbs, absIdx, absIdx + n - 1) Then
                GoTo NextAbs
            End If
            
            ' If the last instance in this group triggered any dis
            If LastInstTriggeredDis(oEmp, cdc, unprotAbs, absIdx, absIdx + n - 1) Then
                GoTo NextAbs
            End If
            
            If AnyAbsInSameOrHigherDis(oEmp, unprotAbs, absIdx, absIdx + n - 1, Rule.ruleNbr) Then
                GoTo NextAbs
            End If
            
            '  If ALL of the instances that c - l represent have at least one
            '  open/eff dis, skip and move to next absence
            If AllInstancesDisciplined(oEmp, unprotAbs, absIdx, absIdx + n - 1) Then
                GoTo NextAbs
            End If
            
            If AllInstDeferredForRule(oEmp, unprotAbs, absIdx, absIdx + n - 1, ruleIdx) Then
                GoTo NextAbs
            End If
            
            '2.  If none of those conditions were met:
                
            'a.  Put the Absences between c and l in the cdc:
            
            If LastDateWorked >= l.OnDate Then
                'i.  If the Employee has any worked days ON OR AFTER l, the WarnOnlyLevel
                ' bit is set to FALSE
                PutInCDC oEmp, cdc, unprotAbs, absIdx, absIdx + n - 1, Rule.ruleNbr, False, groupNumber
                groupNumber = groupNumber + 1
            Else
                'ii. If the Employee has NOT any worked days ON OR AFTER l, the WarnOnlyLevel
                '   bit is set to TRUE
                PutInCDC oEmp, cdc, unprotAbs, absIdx, absIdx + n - 1, Rule.ruleNbr, True, groupNumber
                groupNumber = groupNumber + 1
            End If

NextAbs:
            absIdx = absIdx + 1
        Next
NextRule:
    Next
    
EndOfRuleLoop:
    
   Dim notifColl As A2IObjSet
   Dim vNotif As Variant, oNotif As A2Notif
   Dim oRule As A2Rule, notifRuleAlias As String
   Dim cdcSignature As String
   Dim notifSignature As String
   
    '5.  Get all of this Employee's Notifications of status 'Open'.
    Set notifColl = oEmp.GetNotif(True)
    
    Dim virtualNotifs As Scripting.Dictionary
    
    If oEmp.IsInactive Then
        Set virtualNotifs = New Scripting.Dictionary
    Else
        Set virtualNotifs = GetVirtualNotifs(oEmp, cdc)
    End If
    
    SyncNotifs oEmp, virtualNotifs, notifColl

End If

End Sub


Private Property Get Rules() As Collection
    If mColRuleUDTs Is Nothing Then
        Set mColRuleUDTs = BuildRuleColl()
    End If
    
    Set Rules = mColRuleUDTs
End Property

Private Function BuildRuleColl() As Collection
    Dim coll As Collection
    Set coll = New Collection
    
    Dim rule1 As ExAbsRule, rule2 As ExAbsRule, rule3 As ExAbsRule
    Dim rule4 As ExAbsRule, rule5 As ExAbsRule, rule6 As ExAbsRule
    Dim rule7 As ExAbsRule, rule8 As ExAbsRule
    
    With rule1
        .ruleAlias = RULE_ALIAS_3IN1: .ruleN = 3: .ruleM = 1: .ruleNbr = 1: Set .ruleObject = GetRuleObj(.ruleAlias)
        coll.Add rule1, CStr(.ruleAlias)
    End With
    With rule2
        .ruleAlias = RULE_ALIAS_5IN3: .ruleN = 5: .ruleM = 3: .ruleNbr = 2: Set .ruleObject = GetRuleObj(.ruleAlias)
        coll.Add rule2, CStr(.ruleAlias)
    End With
    With rule3
        .ruleAlias = RULE_ALIAS_7IN6: .ruleN = 7: .ruleM = 6: .ruleNbr = 3: Set .ruleObject = GetRuleObj(.ruleAlias)
        coll.Add rule3, CStr(.ruleAlias)
    End With
    With rule4
        .ruleAlias = RULE_ALIAS_9IN9: .ruleN = 9: .ruleM = 9: .ruleNbr = 4: Set .ruleObject = GetRuleObj(.ruleAlias)
        coll.Add rule4, CStr(.ruleAlias)
    End With
    With rule5
        .ruleAlias = RULE_ALIAS_10IN12: .ruleN = 10: .ruleM = 12: .ruleNbr = 5: Set .ruleObject = GetRuleObj(.ruleAlias)
        coll.Add rule5, CStr(.ruleAlias)
    End With
    With rule6
        .ruleAlias = RULE_ALIAS_12IN16: .ruleN = 12: .ruleM = 16: .ruleNbr = 6: Set .ruleObject = GetRuleObj(.ruleAlias)
        coll.Add rule6, CStr(.ruleAlias)
    End With
    With rule7
        .ruleAlias = RULE_ALIAS_14IN20: .ruleN = 14: .ruleM = 20: .ruleNbr = 7: Set .ruleObject = GetRuleObj(.ruleAlias)
        coll.Add rule7, CStr(.ruleAlias)
    End With
    With rule8
        .ruleAlias = RULE_ALIAS_16IN24: .ruleN = 16: .ruleM = 24: .ruleNbr = 8: Set .ruleObject = GetRuleObj(.ruleAlias)
        coll.Add rule8, CStr(.ruleAlias)
    End With
    
    Set BuildRuleColl = coll
    
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

Private Sub Class_Initialize()
    Set mColRuleUDTs = Nothing
End Sub

Private Function AnyAbsInSameOrHigherDis(oEmp As A2Employee, iColl As A2IObjSet, _
        iStartIdx As Integer, iEndIdx As Integer, iRuleIdx As Integer) As Boolean

Dim i As Integer, oAbs As A2Abs, collDis As A2IObjSet, v As Variant, oDis As A2Dis
Dim oRule As A2Rule, ruleUDT As ExAbsRule

For i = iStartIdx To iEndIdx
    Set oAbs = iColl(i)
    
    If mDisContainingAbs.Exists(CStr(oAbs.Identifier)) Then
        Set collDis = mDisContainingAbs.Item(CStr(oAbs.Identifier))
    Else
        Set collDis = oAbs.GetContainingDis(True)
        mDisContainingAbs.Add CStr(oAbs.Identifier), collDis
    End If
    
    For Each v In collDis
        Set oDis = v
        Set oRule = oDis.Rule
        If IsRuleInExAbsTrack(oRule.Alias) Then
            ruleUDT = Rules(oRule.Alias)
            If ruleUDT.ruleNbr >= iRuleIdx Then
                AnyAbsInSameOrHigherDis = True
                Exit Function
            End If
        End If
    Next
Next

AnyAbsInSameOrHigherDis = False

End Function

Private Function AllAbsInOpenNotifForSameOrHigher(oEmp As A2Employee, iColl As A2IObjSet, _
        iStartIdx As Integer, iEndIdx As Integer, iRuleIdx As Integer) As Boolean

Dim i As Integer, oAbs As A2Abs, collNotif As A2IObjSet, v As Variant, oNotif As A2Notif
Dim oRule As A2Rule, ruleUDT As ExAbsRule

AllAbsInOpenNotifForSameOrHigher = True

For i = iStartIdx To iEndIdx
    Set oAbs = iColl(i)
    
    If mNotifContainingAbs.Exists(CStr(oAbs.Identifier)) Then
        Set collNotif = mNotifContainingAbs.Item(CStr(oAbs.Identifier))
    Else
        Set collNotif = oAbs.GetContainingNotif(True)
        mNotifContainingAbs.Add CStr(oAbs.Identifier), collNotif
    End If
    
    If collNotif.Count = 0 Then
        AllAbsInOpenNotifForSameOrHigher = False
        Exit Function
    Else
        For Each v In collNotif
            Set oNotif = v
            Set oRule = oNotif.Rule
            If IsRuleInExAbsTrack(oRule.Alias) Then
                ruleUDT = Rules(oRule.Alias)
                If ruleUDT.ruleNbr < iRuleIdx Then
                    AllAbsInOpenNotifForSameOrHigher = False
                    Exit Function
                End If
            End If
        Next
    End If
Next
        
End Function

Private Function AnyAbsInCDC(oEmp As A2Employee, ByRef iCDC As Scripting.Dictionary, _
    iColl As A2IObjSet, iStartIdx As Integer, iEndIdx As Integer, iRuleIdx As Integer) As Boolean

Dim s As String
Dim oCDC As CCaughtDay
Dim i As Integer, oAbs As A2Abs
For i = iStartIdx To iEndIdx
    Set oAbs = iColl(i)
    s = Format(oAbs.OnDate, ("yyyymmdd")) & iRuleIdx
    
    If iCDC.Exists(s) Then
        Set oCDC = iCDC.Item(s)
        If oCDC.ruleNum = iRuleIdx Then
            AnyAbsInCDC = True
            Exit Function
        End If
    End If
Next

AnyAbsInCDC = False
End Function

Private Sub PutInCDC(oEmp As A2Employee, ByRef iCDC As Scripting.Dictionary, iColl As A2IObjSet, _
        iStartIdx As Integer, iEndIdx As Integer, iRuleIdx As Integer, warnOnlyFlag As Boolean, _
        iGroupNumber As Integer)


Dim cd As CCaughtDay

Dim i As Integer, oAbs As A2Abs
For i = iStartIdx To iEndIdx
    Set oAbs = iColl(i)
    Set cd = New CCaughtDay
    Set cd.oAbs = oAbs
    cd.ruleNum = iRuleIdx
    cd.warnOnlyLevel = warnOnlyFlag
    cd.groupNumber = iGroupNumber
    'Set cd(i).abs = oAbs
    'cd(i).ruleNum = iRuleIdx
    'cd(i).warnOnlyLevel = warnOnlyFlag
    
    If i = iEndIdx Then
        cd.isTriggeringAbs = True
    Else
        cd.isTriggeringAbs = False
    End If
    
    iCDC.Add Format(oAbs.OnDate, "yyyymmdd") & iRuleIdx, cd
Next

'
'Dim cd() As CaughtDay
'ReDim cd(iEndIdx)
'
'Dim i As Integer, oAbs As A2Abs
'For i = iStartIdx To iEndIdx
'    Set oAbs = iColl(i)
'
'    Set cd(i).abs = oAbs
'    cd(i).ruleNum = iRuleIdx
'    cd(i).warnOnlyLevel = warnOnlyFlag
'
'    iCDC.Add Format(oAbs.OnDate, "yyyymmdd"), cd(i)
'Next

End Sub

Private Function GetMonthDiff(iDate1 As Date, iDate2 As Date) As Integer
    Dim i As Integer
    i = DateDiff("m", iDate1, iDate2)
    
    Dim d1 As Integer, d2 As Integer
    d1 = CInt(DatePart("d", iDate1))
    d2 = CInt(DatePart("d", iDate2))
    
    If d2 > d1 Then
        i = i + 1

    End If
    
    If i <= 1 Then
        i = 1
    End If
    
    GetMonthDiff = i
End Function

Private Function IsRuleInCDC(iCDC As Scripting.Dictionary, iRuleIdx As Integer) As Boolean
    Dim v As Variant, cd As CCaughtDay
    For Each v In iCDC.Items
        Set cd = v
        If cd.ruleNum = iRuleIdx Then
            IsRuleInCDC = True
            Exit Function
        End If
    Next
End Function

Private Function IsRuleInExAbsTrack(iAlias As String) As Boolean
    Dim v As Variant, rudt As ExAbsRule
    IsRuleInExAbsTrack = False
    For Each v In Rules
        rudt = v
        If rudt.ruleAlias = iAlias Then
            IsRuleInExAbsTrack = True
            Exit For
        End If
    Next
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

Private Function GetViolNotifType() As A2NotifType
    If mNotTypeViol Is Nothing Then
        Set mNotTypeViol = GetNotTypeFromAlias(NOTIF_TYPE_ALIAS_VIOL)
    End If
    
    Set GetViolNotifType = mNotTypeViol
End Function
Private Function GetViolNRNotifType() As A2NotifType
    If mNotTypeViolNR Is Nothing Then
        Set mNotTypeViolNR = GetNotTypeFromAlias(NOTIF_TYPE_ALIAS_VIOL_NR)
    End If
    
    Set GetViolNRNotifType = mNotTypeViolNR
End Function

Private Function GetInfoNotifType() As A2NotifType
    If mNotTypeInfo Is Nothing Then
        Set mNotTypeInfo = GetNotTypeFromAlias(NOTIF_TYPE_ALIAS_INFO)
    End If
    
    Set GetInfoNotifType = mNotTypeInfo
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


'AllInstancesDisciplined

Private Function AllInstancesDisciplined(oEmp As A2Employee, _
    iColl As A2IObjSet, iStartIdx As Integer, iEndIdx As Integer) As Boolean

    ' first, clump the absences into instances
    Dim instancesToCheck As Scripting.Dictionary
    Set instancesToCheck = New Scripting.Dictionary
    
    Dim instNum As String
    
    Dim s As String
    Dim oAbs As A2Abs
    
    Dim i As Integer
    For i = iStartIdx To iEndIdx
        Set oAbs = iColl(i)
        s = Format(oAbs.OnDate, ("yyyymmdd"))
        instNum = mInstanceForAbs.Item(Format(oAbs.OnDate, "yyyymmdd"))
        If Not instancesToCheck.Exists(instNum) Then
            instancesToCheck.Add instNum, Nothing
        End If
    Next

    Dim v As Variant
    For Each v In instancesToCheck.Keys
        s = v
        If Not IsInstanceDisciplined(s) Then
            AllInstancesDisciplined = False
            Exit Function
        End If
    Next
    AllInstancesDisciplined = True
    
End Function

' True if any absence in the instance is disciplined.
Private Function IsInstanceDisciplined(instNum As String) As Boolean
    Dim absSet As A2ObjSet
    Dim vAbs As Variant
    Dim currAbs As A2Abs
    Dim collDis As A2IObjSet
    
    If mIsInstanceDis.Exists(instNum) Then
        IsInstanceDisciplined = mIsInstanceDis.Item(instNum)
    Else
        Set absSet = mInstances(instNum)
        For Each vAbs In absSet.coll
            Set currAbs = vAbs
            If mDisContainingAbs.Exists(CStr(currAbs.Identifier)) Then
                Set collDis = mDisContainingAbs.Item(CStr(currAbs.Identifier))
            Else
                Set collDis = currAbs.GetContainingDis(True)
                mDisContainingAbs.Add CStr(currAbs.Identifier), collDis
            End If
            If collDis.Count >= 1 Then
                mIsInstanceDis.Add CStr(instNum), True
                IsInstanceDisciplined = True
                Exit Function
            End If
        Next
        mIsInstanceDis.Add CStr(instNum), False
    End If
End Function

Private Function AnyInstInCDC(oEmp As A2Employee, iCDC As Scripting.Dictionary, _
    iColl As A2IObjSet, iStartIdx As Integer, iEndIdx As Integer, iRuleIdx As Integer) As Boolean

    ' first, clump the absences into instances
    Dim instancesToCheck As Scripting.Dictionary
    Set instancesToCheck = New Scripting.Dictionary
    
    Dim instNum As String
    
    Dim s As String
    Dim oAbs As A2Abs
    
    Dim i As Integer
    For i = iStartIdx To iEndIdx
        Set oAbs = iColl(i)
        s = Format(oAbs.OnDate, ("yyyymmdd"))
        instNum = mInstanceForAbs.Item(Format(oAbs.OnDate, "yyyymmdd"))
        If Not instancesToCheck.Exists(instNum) Then
            instancesToCheck.Add instNum, Nothing
        End If
    Next

    Dim v As Variant
    For Each v In instancesToCheck.Keys
        s = v
        If IsInstInCDC(s, iCDC, iRuleIdx) Then
            AnyInstInCDC = True
            Exit Function
        End If
    Next
    AnyInstInCDC = False
    
End Function


Private Function IsInstInCDCWithAnyRule(instNum As String, iCDC As Scripting.Dictionary) As Boolean

    Dim absSet As A2ObjSet
    Dim vAbs As Variant
    Dim currAbs As A2Abs
    Dim collDis As A2IObjSet
    Dim oCDC As CCaughtDay
    Set absSet = mInstances(instNum)
    Dim vCD As Variant
    
    For Each vAbs In absSet.coll
        Set currAbs = vAbs
        For Each vCD In iCDC.Items
            Set oCDC = vCD
            If oCDC.oAbs.IsEqualTo(currAbs) Then
                IsInstInCDCWithAnyRule = True
                Exit Function
            End If
        Next
    Next
    IsInstInCDCWithAnyRule = False
        

End Function

Private Function IsInstInCDC(instNum As String, iCDC As Scripting.Dictionary, _
        iRuleIdx As Integer) As Boolean

    Dim absSet As A2ObjSet
    Dim vAbs As Variant
    Dim currAbs As A2Abs
    Dim collDis As A2IObjSet
    Dim oCDC As CCaughtDay
    Set absSet = mInstances(instNum)
    For Each vAbs In absSet.coll
        Set currAbs = vAbs
        If iCDC.Exists(CStr(Format(currAbs.OnDate, "yyyymmdd")) & iRuleIdx) Then
            Set oCDC = iCDC.Item(CStr(Format(currAbs.OnDate, "yyyymmdd")) & iRuleIdx)
            If oCDC.ruleNum = iRuleIdx Then
                IsInstInCDC = True
            End If
            Exit Function
        End If
    Next
    IsInstInCDC = False
        

End Function


Private Function GetVirtualNotifs(oEmp As A2Employee, iCDC As Scripting.Dictionary) _
    As Scripting.Dictionary

    Dim oCD As CCaughtDay
    Dim i As Integer
    i = 0
    Dim v As Variant
    
    Dim oRule As A2Rule
    Dim oNotifType As A2NotifType
    
    Dim collNotifs As Scripting.Dictionary
    Set collNotifs = New Scripting.Dictionary
    
    Dim virtualNotif  As CVirtualNotif
    
    For Each v In iCDC.Items
        Set oCD = v
        If Not oCD.groupNumber = i Then
            i = oCD.groupNumber
            
            Set oRule = Rules.Item(oCD.ruleNum).ruleObject
        
            If i = 1 Then
                If oCD.warnOnlyLevel = True Then
                    Set oNotifType = GetViolNRNotifType
                Else
                    Set oNotifType = GetViolNotifType
                End If
            Else
                Set oNotifType = GetInfoNotifType
            End If
            
            Set virtualNotif = New CVirtualNotif
            Set virtualNotif.NotifType = oNotifType
            Set virtualNotif.Rule = oRule
            virtualNotif.SeqNum = i
            virtualNotif.Absences.coll.Add oCD.oAbs
            
            collNotifs.Add CStr(i), virtualNotif
        Else
            virtualNotif.Absences.coll.Add oCD.oAbs
        End If
    Next

    Set GetVirtualNotifs = collNotifs

End Function

Public Sub SyncNotifs(oEmp As A2Employee, collVirtualNotifs As Scripting.Dictionary, _
    collActualNotifs As A2IObjSet)
    
    Dim vActualNotif As Variant, oActualNotif As A2Notif
    Dim vVirtualNotif As Variant, oVirtualNotif As CVirtualNotif
    
    Dim localBool As Boolean
    
    ' we need to make sure there are not multiple copies of the same
    ' notif out there.
    Dim collVirtualNotifsAvailable As Collection
    Set collVirtualNotifsAvailable = New Collection
    
    For Each vVirtualNotif In collVirtualNotifs.Items
        Set oVirtualNotif = vVirtualNotif
        collVirtualNotifsAvailable.Add vVirtualNotif, CStr(oVirtualNotif.SeqNum)
    Next
    
    For Each vActualNotif In collActualNotifs
        Set oActualNotif = vActualNotif
        If IsRuleInExAbsTrack(oActualNotif.Rule.Alias) Then
            localBool = False  ' not found
            For Each vVirtualNotif In collVirtualNotifsAvailable
                Set oVirtualNotif = vVirtualNotif
                If oActualNotif.Rule.Alias = oVirtualNotif.Rule.Alias Then
                    If oActualNotif.NotifType.Alias = oVirtualNotif.NotifType.Alias Then
                        If oActualNotif.Absences.IsEqualTo(oVirtualNotif.Absences.AsIObjSet) Then
                            localBool = True
                            Exit For
                        End If
                    End If
                End If
            Next
            If localBool = False Then
                oActualNotif.Cancel
            Else
                collVirtualNotifsAvailable.Remove CStr(oVirtualNotif.SeqNum)
            End If
        End If
    Next
    
    For Each vVirtualNotif In collVirtualNotifs.Items
        Set oVirtualNotif = vVirtualNotif
        localBool = False  ' not found
        For Each vActualNotif In collActualNotifs
            Set oActualNotif = vActualNotif
            If oActualNotif.Rule.Alias = oVirtualNotif.Rule.Alias Then
                If oActualNotif.NotifType.Alias = oVirtualNotif.NotifType.Alias Then
                    If oActualNotif.Absences.IsEqualTo(oVirtualNotif.Absences.AsIObjSet) Then
                        localBool = True
                        Exit For
                    End If
                End If
            End If
        Next
        If localBool = False Then
            CreateNotifFromVirtual oEmp, oVirtualNotif
        End If
    Next
    
    
End Sub

Private Sub CreateNotifFromVirtual(oEmp As A2Employee, oVirtualNotif As CVirtualNotif)
    
    Dim oAbsGrp As A2AbsGrp
    Set oAbsGrp = CreateAbsGrp(oVirtualNotif.Absences)

    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes("AddNotif")
    
    Dim oNotType As A2NotifType
    Set oNotType = oVirtualNotif.NotifType
    
    Dim empGop As A2GetObjParm, notTypeGop As A2GetObjParm
    Dim ruleGop As A2GetObjParm, absGrpGop As A2GetObjParm
    
    Set empGop.parm = lookup.Parameters("emp")
    Set empGop.Val = oEmp
    Set notTypeGop.parm = lookup.Parameters("notType")
    Set notTypeGop.Val = oNotType
    Set ruleGop.parm = lookup.Parameters("rule")
    Set ruleGop.Val = oVirtualNotif.Rule
    Set absGrpGop.parm = lookup.Parameters("absGrp")
    Set absGrpGop.Val = oAbsGrp

    mSys.Execute Array(empGop, notTypeGop, ruleGop, absGrpGop)

End Sub

Private Function AllInstInCDC(oEmp As A2Employee, iCDC As Scripting.Dictionary, _
    iColl As A2IObjSet, iStartIdx As Integer, iEndIdx As Integer) As Boolean

    ' first, clump the absences into instances
    Dim instancesToCheck As Scripting.Dictionary
    Set instancesToCheck = New Scripting.Dictionary
    
    Dim instNum As String
    
    Dim s As String
    Dim oAbs As A2Abs
    
    Dim i As Integer
    For i = iStartIdx To iEndIdx
        Set oAbs = iColl(i)
        s = Format(oAbs.OnDate, ("yyyymmdd"))
        instNum = mInstanceForAbs.Item(Format(oAbs.OnDate, "yyyymmdd"))
        If Not instancesToCheck.Exists(instNum) Then
            instancesToCheck.Add instNum, Nothing
        End If
    Next

    Dim v As Variant
    For Each v In instancesToCheck.Keys
        s = v
        If Not IsInstInCDCWithAnyRule(s, iCDC) Then
            AllInstInCDC = False
            Exit Function
        End If
    Next
    AllInstInCDC = True
    
End Function

Private Function LastInstTriggeredCDC(oEmp As A2Employee, iCDC As Scripting.Dictionary, _
    iColl As A2IObjSet, iStartIdx As Integer, iEndIdx As Integer) As Boolean

    ' first, clump the absences into instances
    Dim instanceToCheck As Scripting.Dictionary
    Set instanceToCheck = New Scripting.Dictionary
    
    Dim instNum As String
    Dim instNumInCDC As String
    
    Dim v As Variant
    
    Dim s As String
    Dim oAbs As A2Abs
    
    Dim i As Integer
    i = iEndIdx
    Set oAbs = iColl(i)
    s = Format(oAbs.OnDate, ("yyyymmdd"))
    instNum = mInstanceForAbs.Item(s)

    ' we've got the instance; now we need to check everything in the cdc
    ' and see if it is the last instance in any of those...
    
    Dim oCD As CCaughtDay
    For Each v In iCDC.Items
        Set oCD = v
        If oCD.isTriggeringAbs Then
            instNumInCDC = mInstanceForAbs.Item(Format(oCD.oAbs.OnDate, "yyyymmdd"))
            If instNumInCDC = instNum Then
                LastInstTriggeredCDC = True
                Exit Function
            End If
        End If
    Next

End Function

Private Function AllInstDeferredForRule(oEmp As A2Employee, _
    iColl As A2IObjSet, iStartIdx As Integer, iEndIdx As Integer, _
    iRuleIdx As Integer) As Boolean

    ' first, clump the absences into instances
    Dim instancesToCheck As Scripting.Dictionary
    Set instancesToCheck = New Scripting.Dictionary
    
    Dim instNum As String
    
    Dim s As String
    Dim oAbs As A2Abs
    
    Dim i As Integer
    For i = iStartIdx To iEndIdx
        Set oAbs = iColl(i)
        s = Format(oAbs.OnDate, ("yyyymmdd"))
        instNum = mInstanceForAbs.Item(Format(oAbs.OnDate, "yyyymmdd"))
        If Not instancesToCheck.Exists(instNum) Then
            instancesToCheck.Add instNum, Nothing
        End If
    Next

    Dim v As Variant
    For Each v In instancesToCheck.Keys
        s = v
        If Not IsInstanceDeferredForRule(s, iRuleIdx) Then
            AllInstDeferredForRule = False
            Exit Function
        End If
    Next
    AllInstDeferredForRule = True
    
End Function

Private Function IsInstanceDeferredForRule(instNum As String, iRuleIdx As Integer) As Boolean
    Dim absSet As A2ObjSet
    Dim vAbs As Variant
    Dim currAbs As A2Abs
    Dim collDis As A2IObjSet
    Dim vDis As Variant
    Dim oDis As A2Dis
    
    If mIsInstanceDeferred.Exists(instNum & "/" & iRuleIdx) Then
        IsInstanceDeferredForRule = mIsInstanceDeferred.Item(instNum & "/" & iRuleIdx)
    Else
        Set absSet = mInstances(instNum)
        For Each vAbs In absSet.coll
            Set currAbs = vAbs
            If mAllDisContainingAbs.Exists(CStr(currAbs.Identifier)) Then
                Set collDis = mAllDisContainingAbs.Item(CStr(currAbs.Identifier))
            Else
                Set collDis = currAbs.GetContainingDis(False)
                mAllDisContainingAbs.Add CStr(currAbs.Identifier), collDis
            End If
            For Each vDis In collDis
                Set oDis = vDis
                If oDis.Status = a2DisStatusDeferred Then
                    mIsInstanceDeferred.Add instNum & "/" & iRuleIdx, True
                    IsInstanceDeferredForRule = True
                    Exit Function
                End If
            Next
        Next
        mIsInstanceDeferred.Add instNum & "/" & iRuleIdx, False
        IsInstanceDeferredForRule = False
    End If
End Function

' True if any absence in the instance is disciplined.
Private Function DidInstTriggerDis(instNum As String) As Boolean
    Dim absSet As A2ObjSet
    Dim vAbs As Variant
    Dim currAbs As A2Abs
    Dim collDis As A2IObjSet
    Dim vDis As Variant
    Dim oDis As A2Dis
    
    If mDidInstanceTriggerDis.Exists(instNum) Then
        DidInstTriggerDis = mDidInstanceTriggerDis.Item(instNum)
    Else
        Set absSet = mInstances(instNum)
        For Each vAbs In absSet.coll
            Set currAbs = vAbs
            If mAllDisContainingAbs.Exists(CStr(currAbs.Identifier)) Then
                Set collDis = mAllDisContainingAbs.Item(CStr(currAbs.Identifier))
            Else
                Set collDis = currAbs.GetContainingDis(False)
                mAllDisContainingAbs.Add CStr(currAbs.Identifier), collDis
            End If
            For Each vDis In collDis
                Set oDis = vDis
                If oDis.Status = a2DisStatusDeferred Or oDis.Status = a2DisStatusEffective Or oDis.Status = a2DisStatusOpen Then
                    mDidInstanceTriggerDis.Add CStr(instNum), True
                    DidInstTriggerDis = True
                    Exit Function
                End If
            Next
        Next
        mDidInstanceTriggerDis.Add CStr(instNum), False
        DidInstTriggerDis = False
    End If
End Function


Private Function LastInstTriggeredDis(oEmp As A2Employee, iCDC As Scripting.Dictionary, _
    iColl As A2IObjSet, iStartIdx As Integer, iEndIdx As Integer) As Boolean

    ' first, clump the absences into instances
    Dim instanceToCheck As Scripting.Dictionary
    Set instanceToCheck = New Scripting.Dictionary
    
    Dim instNum As String
    Dim instNumInCDC As String
    
    Dim v As Variant
    
    Dim s As String
    Dim oAbs As A2Abs
    
    Dim i As Integer
    i = iEndIdx
    Set oAbs = iColl(i)
    s = Format(oAbs.OnDate, ("yyyymmdd"))
    instNum = mInstanceForAbs.Item(s)

    LastInstTriggeredDis = DidInstTriggerDis(instNum)


End Function

Private Function AnyInstanceWaived(oEmp As A2Employee, iCDC As Scripting.Dictionary, _
    iColl As A2IObjSet, iStartIdx As Integer, iEndIdx As Integer) As Boolean

    ' first, clump the absences into instances
    Dim instancesToCheck As Scripting.Dictionary
    Set instancesToCheck = New Scripting.Dictionary
    
    Dim instNum As String
    
    Dim s As String
    Dim oAbs As A2Abs
    
    Dim i As Integer
    For i = iStartIdx To iEndIdx
        Set oAbs = iColl(i)
        s = Format(oAbs.OnDate, ("yyyymmdd"))
        instNum = mInstanceForAbs.Item(Format(oAbs.OnDate, "yyyymmdd"))
        If Not instancesToCheck.Exists(instNum) Then
            instancesToCheck.Add instNum, Nothing
        End If
    Next

    Dim v As Variant
    For Each v In instancesToCheck.Keys
        s = v
        If IsInstanceWaived(s) Then
            AnyInstanceWaived = True
            Exit Function
        End If
    Next
    AnyInstanceWaived = False
    
End Function

Private Function IsInstanceWaived(instNum As String) As Boolean
    Dim absSet As A2ObjSet
    Dim vAbs As Variant
    Dim currAbs As A2Abs
    Dim collDis As A2IObjSet
    Dim vDis As Variant
    Dim oDis As A2Dis
    
    If mIsInstanceWaived.Exists(CStr(instNum)) Then
        IsInstanceWaived = mIsInstanceWaived.Item(CStr(instNum))
    Else
        Set absSet = mInstances(instNum)
        For Each vAbs In absSet.coll
            Set currAbs = vAbs
            If mAllDisContainingAbs.Exists(CStr(currAbs.Identifier)) Then
                Set collDis = mAllDisContainingAbs.Item(CStr(currAbs.Identifier))
            Else
                Set collDis = currAbs.GetContainingDis(False)
                mAllDisContainingAbs.Add CStr(currAbs.Identifier), collDis
            End If
            For Each vDis In collDis
                Set oDis = vDis
                If oDis.Status = a2DisStatusWaived Then
                    mIsInstanceWaived.Add CStr(instNum), True
                    IsInstanceWaived = True
                    Exit Function
                End If
            Next
        Next
        mIsInstanceWaived.Add CStr(instNum), False
        IsInstanceWaived = False
    End If
End Function


Private Function GetFilteredAbs(overallColl As A2IObjSet) As A2IObjSet
    Dim objSet As A2ObjSet
    Set objSet = New A2ObjSet
    

    Dim vAbs As Variant, oAbs As A2Abs
    Dim disColl As A2IObjSet, vDis As Variant, oDis As A2Dis
    Dim localBool As Boolean
    
    Dim s As String
    Dim instNum As String
    
    For Each vAbs In overallColl
    
        Set oAbs = vAbs
        
        s = Format(oAbs.OnDate, ("yyyymmdd"))
        instNum = mInstanceForAbs.Item(Format(oAbs.OnDate, "yyyymmdd"))
        If Not IsInstanceWaived(instNum) Then
            objSet.coll.Add oAbs
        End If
    Next
    
    Set GetFilteredAbs = objSet
End Function
