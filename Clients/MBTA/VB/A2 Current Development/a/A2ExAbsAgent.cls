VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2ExAbsAgent"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

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

Private Const POLICY_EFF_DATE As Date = #4/15/2005#

Private mNotTypeViol As A2NotifType
Private mNotTypeViolNR As A2NotifType

Private mDisContainingAbs As Scripting.Dictionary
Private mNotifContainingAbs As Scripting.Dictionary

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

If iEventType = a2PubEvTypeAbsAdded Or _
    iEventType = a2PubEvTypeAbsAltered Or _
    iEventType = a2PubEvTypeAbsReplaced Or _
     iEventType = a2PubEvTypeDisAdded Or _
     iEventType = a2PubEvTypeDisAltered Then

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

    '2.  Get all unprotected Absences (absences with a primary absence type not falling
    '       into the 'Protected' group) for the Employee in the past two years, excluding any
    '       waived Absences.
    Dim unprotAbs As A2IObjSet
    Set unprotAbs = oEmp.GetUnprotUnwaivedAbs(twoYearsAgo)

    '3.  Get the last date worked for this emp
    Dim LastDateWorked As Date
    LastDateWorked = #1/1/1970#
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

    '4.  For each Rule in the excessive absenteeism progression (in descending order -
    '       starting with the 24 month Rule and working downward):
    Dim Rule As ExAbsRule
    Dim ruleIdx As Integer
    For ruleIdx = 8 To 1 Step -1

        v = allRules(CLng(ruleIdx))
        Rule = v
        n = Rule.ruleN
        m = Rule.ruleM

        'a.  Determine if the total number of Absences in the two year period is
        '   equal to or greater than n. If not, go to the next rule
        If unprotAbs.Count < n Then
            GoTo NextRule
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

            '1.     If ANY of the Absences between c and l are already in a Discipline
            '       Instance of status 'Open' or 'Effective' FOR THIS OR A HIGHER RULE,
            '           OR if ALL of the Absences between c and l are already in a
            '           Notification of status 'Open' FOR THIS OR A HIGHER RULE,
            '               OR if ANY of the Absences between c and l are already in cdc,
            '               stop processing this absence; move to the next one.
            If AnyAbsInSameOrHigherDis(oEmp, unprotAbs, absIdx, absIdx + n - 1, Rule.ruleNbr) Then
                GoTo NextAbs
            End If

            ' THIS STEP REMOVED; THIS IS TAKEN CARE OF IN LATER STEP, AND WE
            ' NEED TO KNOW HERE IF THE EMP HAS CROSSED THE THRESHOLD, REGARDLESS
            ' OF WHETHER IT IS ALREADY NOTIFIED OR NOT
            'If AllAbsInOpenNotifForSameOrHigher(oEmp, unprotAbs, absIdx, absIdx + n - 1, rule.ruleNbr) Then
            '    GoTo NextAbs
            'End If

            If AnyAbsInCDC(oEmp, cdc, unprotAbs, absIdx, absIdx + n - 1) Then
                GoTo NextAbs
            End If

            '2.  If none of those conditions were met:

            'a.  Put the Absences between c and l in the cdc:

            If LastDateWorked >= l.OnDate Then
                'i.  If the Employee has any worked days ON OR AFTER l, the WarnOnlyLevel
                ' bit is set to FALSE
                PutInCDC oEmp, cdc, unprotAbs, absIdx, absIdx + n - 1, Rule.ruleNbr, False
            Else
                'ii. If the Employee has NOT any worked days ON OR AFTER l, the WarnOnlyLevel
                '   bit is set to TRUE
                PutInCDC oEmp, cdc, unprotAbs, absIdx, absIdx + n - 1, Rule.ruleNbr, True
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

    'a.  If NO open Notifications found:
    If notifColl.Count = 0 Then

        'i.  If NO days are in cdc, do nothing.
        If cdc.Count = 0 Then
            ' do nothing  -- emp is OK

        'ii. If days ARE found in cdc:
        Else

            '1.  Create a Notification for each block of Absences (by Rule) in the cdc.
            For Each v In GetRulesInCDC(cdc).Keys
                CreateNotif oEmp, cdc, CLng(v)
            Next

        End If
    'b.  If any open Notifications are found:
    Else

        'i.  Check the cdc to build a list of all the Rules that the Employee has violated
        '       based on current conditions.

        'ii. For each open Notification for the Employee:
        For Each v In notifColl
            Set oNotif = v
            Set oRule = oNotif.Rule
            notifRuleAlias = oRule.Alias

            '1.  If the Notification's Rule is in the cdc:

            If IsRuleInExAbsTrack(notifRuleAlias) Then
                If IsRuleInCDC(cdc, Rules(notifRuleAlias).ruleNbr) Then

                    'a.  If any of the Absences in the Notification are NOT in the cdc for that Rule,
                    '       OR if any of the Absences in the cdc are NOT in the Notification, CANCEL
                    '       the existing Notification. Create a new notification with the absences
                    '       from the cdc for this Rule (using the WarnOnlyLevel bit)
                    cdcSignature = GetCDCSignature(cdc, Rules(notifRuleAlias).ruleNbr)
                    notifSignature = GetNotifSignature(oNotif)
                    If Not cdcSignature = notifSignature Then
                        oNotif.Cancel
                        CreateNotif oEmp, cdc, Rules(notifRuleAlias).ruleNbr
                    End If

                '2.  If the Notification's Rule is NOT in the cdc, CANCEL the Notification.
                Else
                    oNotif.Cancel
                End If
            End If
        Next

        ' Refresh the notifColl to reflect any added above
        Set notifColl = oEmp.GetNotif(True)
        Dim rudt As ExAbsRule
        Dim localBool As Boolean
        Dim v2 As Variant

        'iii.    For each Rule in the cdc:
            For Each v In GetRulesInCDC(cdc).Items
            '1.  If the Employee does not already have an open Notification for that Rule,
            '       create a new one with the absences from the cdc for this Rule (using the
            '       WarnOnlyLevel bit ).
                rudt = v
                localBool = False
                For Each v2 In notifColl
                    Set oNotif = v2
                    If oNotif.Rule.Alias = rudt.ruleAlias Then
                        localBool = True
                        Exit For
                    End If
                Next
                If Not localBool Then
                    CreateNotif oEmp, cdc, rudt.ruleNbr
                End If
            Next
    End If
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
    iColl As A2IObjSet, iStartIdx As Integer, iEndIdx As Integer) As Boolean

Dim s As String

Dim i As Integer, oAbs As A2Abs
For i = iStartIdx To iEndIdx
    Set oAbs = iColl(i)
    s = Format(oAbs.OnDate, ("yyyymmdd"))

    If iCDC.Exists(s) Then
        AnyAbsInCDC = True
        Exit Function
    End If
Next

AnyAbsInCDC = False
End Function

Private Sub PutInCDC(oEmp As A2Employee, ByRef iCDC As Scripting.Dictionary, iColl As A2IObjSet, _
        iStartIdx As Integer, iEndIdx As Integer, iRuleIdx As Integer, warnOnlyFlag As Boolean)


Dim cd As CCaughtDay

Dim i As Integer, oAbs As A2Abs
For i = iStartIdx To iEndIdx
    Set oAbs = iColl(i)
    Set cd = New CCaughtDay
    Set cd.oAbs = oAbs
    cd.ruleNum = iRuleIdx
    cd.warnOnlyLevel = warnOnlyFlag
    'Set cd(i).abs = oAbs
    'cd(i).ruleNum = iRuleIdx
    'cd(i).warnOnlyLevel = warnOnlyFlag

    iCDC.Add Format(oAbs.OnDate, "yyyymmdd"), cd
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

Private Function GetCDCSignature(iCDC, iRuleIdx As Integer) As String
    Dim s As String
    s = ""
    Dim v As Variant, cd As CCaughtDay
    For Each v In iCDC.Items
        Set cd = v
        If cd.ruleNum = iRuleIdx Then
            s = s & Format(cd.oAbs.OnDate, "yyyymmdd")
            If cd.warnOnlyLevel = True Then
                 s = s & "W"
            Else
                s = s & "V"
            End If
        End If
    Next

    GetCDCSignature = s


'
'        Dim s As String
'     s = ""
'    Dim v As Variant, cd As CaughtDay
'    For Each v In iCDC.Items
'        cd = v
'        If cd.ruleNum = iRuleIdx Then
'            s = s & Format(cd.abs.OnDate, "yyyymmdd")
'            If cd.warnOnlyLevel = True Then
'                 s = s & "W"
'            Else
'                s = s & "V"
'            End If
'        End If
'    Next
'
'    GetCDCSignature = s
End Function

Private Function GetNotifSignature(iNotif As A2Notif) As String
    Dim absColl As A2IObjSet
    Set absColl = iNotif.Absences

    Dim isWarning As Boolean
    isWarning = False

    If iNotif.NotifType.Alias = NOTIF_TYPE_ALIAS_VIOL_NR Then
        isWarning = True
    End If

    Dim v As Variant, oAbs As A2Abs, s As String
    s = ""
    For Each v In absColl
        Set oAbs = v
        s = s & Format(oAbs.OnDate, "yyyymmdd")
        If isWarning Then
            s = s & "W"
        Else
            s = s & "V"
        End If
    Next

    GetNotifSignature = s
End Function

Private Sub CreateNotif(iEmp As A2Employee, iCDC As Scripting.Dictionary, _
                iRuleIdx As Integer)

Dim absColl As A2ObjSet, coll As Collection
Set absColl = New A2ObjSet
Set coll = New Collection
Dim cd As CCaughtDay
Dim v As Variant, oAbs As A2Abs
Dim isWarning As Boolean

For Each v In iCDC.Items
    Set cd = v
    If cd.ruleNum = iRuleIdx Then
        coll.Add cd.oAbs
    End If
    isWarning = cd.warnOnlyLevel
Next

Set absColl.coll = coll

'Dim oNotif As A2Notif

    Dim oRule As A2Rule
    Set oRule = Rules(iRuleIdx).ruleObject

    Dim oAbsGrp As A2AbsGrp
    Set oAbsGrp = CreateAbsGrp(absColl)

    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes("AddNotif")

    Dim oNotType As A2NotifType
    If isWarning Then
        Set oNotType = GetViolNRNotifType
    Else
        Set oNotType = GetViolNotifType
    End If

    Dim empGop As A2GetObjParm, notTypeGop As A2GetObjParm
    Dim ruleGop As A2GetObjParm, absGrpGop As A2GetObjParm

    Set empGop.parm = lookup.Parameters("emp")
    Set empGop.Val = iEmp
    Set notTypeGop.parm = lookup.Parameters("notType")
    Set notTypeGop.Val = oNotType
    Set ruleGop.parm = lookup.Parameters("rule")
    Set ruleGop.Val = oRule
    Set absGrpGop.parm = lookup.Parameters("absGrp")
    Set absGrpGop.Val = oAbsGrp

    mSys.GetObjects Array(empGop, notTypeGop, ruleGop, absGrpGop)

End Sub

Private Function GetRulesInCDC(iCDC As Scripting.Dictionary) As Scripting.Dictionary
    Dim coll As Scripting.Dictionary
    Set coll = New Scripting.Dictionary
    Dim v As Variant, v2 As Variant
    Dim cd As CCaughtDay

    For Each v In iCDC.Items
        Set cd = v
        If Not coll.Exists(CStr(cd.ruleNum)) Then
            coll.Add CStr(cd.ruleNum), Rules(cd.ruleNum)
        End If

    Next

    Set GetRulesInCDC = coll


'
'
'        Dim coll As Scripting.Dictionary
'    Set coll = New Scripting.Dictionary
'    Dim v As Variant, v2 As Variant
'    Dim cd() As CaughtDay
'    ReDim cd(iCDC.Count)
'    Dim i As Long
'    i = 1
'    Dim tmpRuleNum As Integer
'
'    For Each v In iCDC.Keys
'        v2 = iCDC.Item(v)
'        cd(i) = iCDC(v)
'        tmpRuleNum = cd(i).ruleNum
'        If Not coll.Exists(CStr(tmpRuleNum)) Then
'            coll.Add CStr(tmpRuleNum), Rules(tmpRuleNum)
'        End If
'        i = i + 1
'    Next
'
'    Set GetRulesInCDC = coll
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
