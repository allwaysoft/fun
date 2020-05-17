VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2ExAbsAgent9"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' EXCESSIVE ABSENTEEISM
' NOTIFICATION AGENT
'   VERSION 9

'IN EXCESS OF:
'5 days or 3 instances within 3 months
'7 days or 4 instances within 6 months
'8 days or 5 instances within 9 months   ---   look back ONLY applies to this one
'9 days or 7 instances within 12 months
'12 days or 8 instances within 16 months
'15 days or 9 instances within 20 months

'18 days or 12 instances within 24 months
'
'Tardiness/Miss -- 1 instance
'Sick -- 1 day + 1 instance
'Red Miss -- 2 instances
'Red Miss/Sick -- 3 instances + 1 day
'AWOL -- suspension + 3 instances + 1 day
'
'--- 12 months free of attendance-related discipline, revert to discipline-free record

Implements A2ISubscriber
'
Public Type CaughtDay
    abs As A2Abs
    ruleNum As Long
    warnOnlyLevel As Boolean
    triggerString As String
End Type
'
Public Type ExAbsRule2
    ruleAlias As String
    ruleNbr As Long
    ruleN As Long
    ruleM As Long
    RuleI As Long ' # instances
    ruleObject As A2Rule
End Type

Private mColRuleUDTs As Collection

Private mSys As A2System

Private Const RULE_ALIAS_0 As String = "e2xawol"
Private Const RULE_ALIAS_1 As String = "e2x5d3i3m"
Private Const RULE_ALIAS_2 As String = "e2x7d4i6m"
Private Const RULE_ALIAS_3 As String = "e2x8d5i9m"
Private Const RULE_ALIAS_4 As String = "e2x9d7i12m"
Private Const RULE_ALIAS_5 As String = "e2x12d8i16m"
Private Const RULE_ALIAS_6 As String = "e2x15d9i20m"
Private Const RULE_ALIAS_7 As String = "e2x18d12i24m"

Private Const NOTIF_TYPE_ALIAS_VIOL As String = "exAbsViol"
Private Const NOTIF_TYPE_ALIAS_VIOL_NR As String = "exAbsViolNotRet"
Private Const NOTIF_TYPE_ALIAS_INFO As String = "exAbsInfo"

Private Const POLICY_EFF_DATE As Date = #1/9/2006# '#12/26/2005# ' ' #1/9/2006#

Private Const EARLIEST_TRIGGER_DATE As Date = #1/12/2006# ' #12/29/2005# ' '#1/12/2006#

Private Const LOOKBACK_START = #5/23/2005#
Private Const LOOKBACK_MIN_START_RANGE = #5/23/2005#
Private Const LOOKBACK_MIN_END_RANGE = #1/8/2006#
Private Const LOOKBACK_MIN_DAYS = 8
Private Const LOOKBACK_POLICY_END = #2/23/2006#

Private Const INSTANCE_CUT_LIMIT As Long = 6

Private Const TIME_LIMIT_DAYS As Long = 150

Private Const RED_MISS_ABSTYPE As String = "RED"
Private Const MISS_ABSTYPE As String = "MIS"
Private Const AWOL_ABSTYPE As String = "awol"

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
Private mInstancePoints As Scripting.Dictionary
Private mInstanceStartDate As Scripting.Dictionary

Private mDayPoints As Scripting.Dictionary

Private mAWOLAbsType As A2AbsType
Private mRedMissAbsType As A2AbsType

' Excessive Absence Agent

Private Sub A2ISubscriber_Accept( _
    iSys As A2System, iEventType As a2PubEventType, _
    iObj As A2IObject)

    Dim oEmp As A2Employee
    Dim oAbs As A2Abs
    Dim oDis As A2Dis
    Dim oExtEmp As A2ExtendedEmpInfo

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
    
    Dim debugTimeElapsed As Double
    Dim debugStartTime As Date
    Dim debugEndTime As Date
    
    debugStartTime = Now()
    
    Dim currDate As Date, twoYearsAgo As Date
    
    '1.  Create an empty collection of "caught days", where a caught day is defined as:
    '       Absence + Rule + WarnOnlyLevel bit. It will be referred to as cdc.
    Dim cdc As Scripting.Dictionary
    
    '2.  Get all unprotected Absences (absences with a primary absence type not falling
    '       into the 'Protected' group) for the Employee in the past two years, excluding any
    '       waived Absences.
    Dim unprotAbs As A2IObjSet
    'Set unprotAbs = oEmp.GetUnprotUnwaivedAbs(twoYearsAgo)
    Dim tmpUnprotAbs As A2IObjSet
    
    Dim tmpAllAbs As A2IObjSet
    
    Dim absV As Variant
    Dim absV2 As Variant
    Dim prevAbs As A2Abs
    Dim firstAbs As A2Abs
    Dim prevDate As Date
    Dim currAbs As A2Abs
    Dim tempAbs As A2Abs
    Dim currAbsDate As Date
    Dim instanceNumber As Long
    Dim groupNumber As Long
    Dim totalInstanceCount As Long
    
    Dim dayHasWork As Boolean
    Dim absCalSet As A2IObjSet
    Dim absCalV As Variant
    Dim absCal As A2AbsCalDay
    
    Dim absInInst As A2ObjSet
    
    Dim LastDateWorked As Date
    
    'Variable n will mean the Rule's Absence day threshold, and m will represent
    'the month threshold.
    Dim n As Long, m As Long, monthDiff As Long, i As Long, x As Long, y As Long, oldMonthDiff As Long
    Dim c As A2Abs, l As A2Abs, v As Variant
    Dim foundLocal As Boolean
    Dim absIdx As Long
    Dim absIdxCDC As Long
    Dim runningInstancePointCount As Long
    Dim lastInstanceNumber As Long
    Dim currInstanceNumber As Long
    
    Dim allRules As Collection
    
    Dim Rule As ExAbsRule2
    Dim ruleIdx As Long
    
    Dim cutoffDate As Date
 
    Dim notifColl As A2IObjSet
    Dim vNotif As Variant, oNotif As A2Notif
    Dim oRule As A2Rule, notifRuleAlias As String
    Dim cdcSignature As String
    Dim notifSignature As String
    Dim virtualNotifs As Scripting.Dictionary
    
    Dim collDis As A2IObjSet
    
    Dim prevDayIsFraction As Boolean  ' the previous day checked was a fraction of an absence
    Dim prevDayIsWhole As Boolean     ' the previous day checked was a full-day absence
    Dim startNewInstance As Boolean
    
    Dim lastUnprotectedAbsence As A2Abs
    Dim instNumOfLastUnprotAbs As Long
    
    Dim isLookBackMode As Boolean
    isLookBackMode = False    ' we may jump back to StartOfProcedure with a different
                              ' setting here; this impacts how the procedure works
    
    Dim endingRuleIndex As Long    ' normally 1, but in lookback mode, it is 3
    Dim startingRuleIndex As Long    ' normally 7, but in lookback mode, it is 3
    
    Dim firstAbsenceInRange As A2Abs
    Dim firstInstanceIndexInRange As Long
    
    Dim firstAbsenceIsFullDay As Boolean
    Dim firstAbsenceIsFraction As Boolean
    
    Dim InstancePoints As Long   ' while checking instances, we add up the points as we go
    
    Dim awolAbsSet As A2IObjSet
    Dim filteredAWOLAbsSet As A2IObjSet
    Dim lastAWOL As A2Abs
    Dim lastAWOLInstanceNumber As Long
    Dim lastAWOLInstanceSet As A2IObjSet
    Dim lastAWOLInstanceSetAdj As A2IObjSet
    
    Dim vAbsType As Variant
    Dim oAbsType As A2AbsType
    Dim absTypeSet As A2IObjSet
    
    Dim isRedMiss As Boolean
    Dim isRedMissAndAbsence As Boolean
    
    Dim TriggerNote As String
    
    Dim thisDayPoints As Long
    Dim runningDayPoints As Long
    
    Dim doesLastDayHaveWork As Boolean
    
    Dim fullDaysInLookBack As Long
    
    Dim isInitialLookBackTest As Boolean
    
    Dim totalDayPoints As Long
    
    isInitialLookBackTest = True
    
    Dim allDisSet As A2IObjSet
    Dim vDis As Variant
    
    Dim lookBackTriggerString As String
    Dim halfDaysTriggerString As String
    
    Dim dayPointsAfterNewPolicyStart As Long
    dayPointsAfterNewPolicyStart = 0
    
    Dim lastDisciplineTriggerDate As Date
    
    Dim lastUnprotectedInstanceNum As Long
    
    debugEndTime = Now()
    debugTimeElapsed = CDbl(debugEndTime) - CDbl(debugStartTime)
    debugStartTime = Now()
    
    Set allDisSet = Nothing
    Set allDisSet = oEmp.GetDis(False, True, False, False, False)
    
    If allDisSet.Count = 0 Then
        lastDisciplineTriggerDate = EARLIEST_TRIGGER_DATE
    Else
        Set oDis = allDisSet.Item(allDisSet.Count)
        lastDisciplineTriggerDate = oDis.TriggeredOn
    End If
StartOfProcedure:
       
    Set cdc = New Scripting.Dictionary
    
    Set prevAbs = Nothing
    
    Set mDisContainingAbs = New Scripting.Dictionary
    Set mNotifContainingAbs = New Scripting.Dictionary
    Set mInstances = New Scripting.Dictionary
    Set mInstanceForAbs = New Scripting.Dictionary
    Set mIsInstanceDis = New Scripting.Dictionary
    Set mIsInstanceDeferred = New Scripting.Dictionary
    Set mDidInstanceTriggerDis = New Scripting.Dictionary
    Set mAllDisContainingAbs = New Scripting.Dictionary
    Set mIsInstanceWaived = New Scripting.Dictionary
    Set mInstancePoints = New Scripting.Dictionary
    Set mInstanceStartDate = New Scripting.Dictionary
    Set mDayPoints = New Scripting.Dictionary
       
    Set oExtEmp = oEmp.GetExtendedInfo
    If oExtEmp.UnionCode = "096" Or _
        oExtEmp.UnionCode = "097" Or _
        oExtEmp.UnionCode = "098" Or _
        oExtEmp.UnionCode = "099" Then
        ' Police Officers, Sergeants, Lieutenants, Temps, Interns, TSPs, are not included
        GoTo UpdateDatabase
    End If
    
    groupNumber = 1
    instanceNumber = 0
    
    currDate = iSys.OperatingDate
    twoYearsAgo = DateAdd("yyyy", -2, currDate)

    
    If isLookBackMode = True Then
        
        endingRuleIndex = 3
        startingRuleIndex = 7
        
        lookBackTriggerString = " (LB)"
        If isInitialLookBackTest = True Then
            Set tmpAllAbs = oEmp.GetAbsenceCalendar(LOOKBACK_MIN_START_RANGE, LOOKBACK_MIN_END_RANGE)
        End If
    Else
        
        endingRuleIndex = 1
        startingRuleIndex = 7
        
        lookBackTriggerString = ""
        If twoYearsAgo < POLICY_EFF_DATE Then
            twoYearsAgo = POLICY_EFF_DATE
        End If
        
        Set tmpAllAbs = oEmp.GetAbsenceCalendar(twoYearsAgo, Now())
        Set unprotAbs = oEmp.GetUnprotectedAbsences(twoYearsAgo)
    End If
    
    prevDayIsFraction = False
    prevDayIsWhole = False
    
    If tmpAllAbs.Count > 0 Then
        Set absCal = tmpAllAbs(1)
    
        If absCal.HasAnyWork Then
            If absCal.IsProtected Or absCal.IsUnprotected Then
                firstAbsenceIsFraction = True
                firstAbsenceIsFullDay = False
            Else
                firstAbsenceIsFraction = False
                firstAbsenceIsFullDay = False
            End If
        Else
            If absCal.IsProtected Or absCal.IsUnprotected Then
                firstAbsenceIsFraction = False
                firstAbsenceIsFullDay = True
            Else
                firstAbsenceIsFraction = False
                firstAbsenceIsFullDay = False
            End If
        End If
    End If
    

    
    ' 2a. Step through all of the absences in order.
    
    totalDayPoints = 0
    
    For Each absCalV In tmpAllAbs
        Set absCal = absCalV
        currAbsDate = absCal.OnDate
        
        thisDayPoints = absCal.DayPoints
        
        startNewInstance = False
        
        If absCal.IsProtected Or absCal.IsUnprotected Or absCal.IsWorked Then
            If absCal.HasAnyWork Then
                doesLastDayHaveWork = True
            Else
                doesLastDayHaveWork = False
            End If
        End If
        
        If absCal.IsProtected Or absCal.IsUnprotected Then
            If prevDayIsWhole Then
                If absCal.HasAnyWork Then
                    prevDayIsFraction = True
                    prevDayIsWhole = False
                Else
                    prevDayIsWhole = True
                    prevDayIsFraction = False
                End If
            Else
                If prevDayIsFraction Then
                    If absCal.HasAnyWork Then
                        startNewInstance = True
                        prevDayIsFraction = True
                        prevDayIsWhole = False
                    Else
                        prevDayIsWhole = True
                        prevDayIsFraction = False
                    End If
                Else
                    ' The previous day is neither a full or partial absence
                    startNewInstance = True
                        
                    If absCal.HasAnyWork Then
                        prevDayIsFraction = True
                        prevDayIsWhole = False
                    Else
                        prevDayIsWhole = True
                        prevDayIsFraction = False
                    End If
                End If
            End If
            
            If startNewInstance Then
                InstancePoints = 0
                instanceNumber = instanceNumber + 1
                Set absInInst = New A2ObjSet
                mInstanceStartDate.Add CStr(instanceNumber), currAbsDate
                mInstancePoints.Add CStr(instanceNumber), 0
            End If
            
            ' *** check and update instance points
            If absCal.HasSpecialHandling = True And absCal.IsProtected = False Then
                isRedMiss = False
                
                ' need to check for red miss + absence (3 points)
                ' or JUST red miss (2 points)
                Set c = GetAbsFromEmpAndDate(oEmp, currAbsDate)
                Set absTypeSet = c.Types
                For Each vAbsType In absTypeSet
                    Set oAbsType = vAbsType
                    If oAbsType.Alias = RED_MISS_ABSTYPE Then
                        isRedMiss = True
                        Exit For
                    End If
                Next
                
                If isRedMiss Then
                    
                
                    If absCal.HasAnyWork = True Then
                        isRedMissAndAbsence = False
                    Else
                        isRedMissAndAbsence = True
                    End If
                
                    If isRedMissAndAbsence = True Then
                        InstancePoints = 3
                        thisDayPoints = 1
                    Else
                        InstancePoints = absCal.InstancePoints
                        thisDayPoints = 0
                    End If
                Else
                    Set absTypeSet = c.Types
                    For Each vAbsType In absTypeSet
                        Set oAbsType = vAbsType
                        If oAbsType.Alias = AWOL_ABSTYPE Then
                            ' day points get left alone!
                            Exit For
                        End If
                    Next
                    For Each vAbsType In absTypeSet
                        Set oAbsType = vAbsType
                        If oAbsType.Alias = MISS_ABSTYPE Then
                            InstancePoints = InstancePoints + absCal.InstancePoints
                            Exit For
                        End If
                    Next
                    
                End If
                
                If mInstancePoints(CStr(instanceNumber)) < InstancePoints Then
                    mInstancePoints(CStr(instanceNumber)) = InstancePoints
                End If
            Else
                InstancePoints = absCal.InstancePoints
                If mInstancePoints(CStr(instanceNumber)) < InstancePoints Then
                    mInstancePoints(CStr(instanceNumber)) = InstancePoints
                End If
                
                If absCal.HasAnyWork Then
                    thisDayPoints = 0
                End If
                
            End If
            
            If mInstances.Exists(CStr(instanceNumber)) Then
                Set absInInst = mInstances.Item(CStr(instanceNumber))
                absInInst.coll.Add absCal '.Absence
            Else
                absInInst.coll.Add absCal '.Absence
                mInstances.Add CStr(instanceNumber), absInInst
            End If
            mInstanceForAbs.Add CStr(Format(currAbsDate, "yyyymmdd")), CStr(instanceNumber)
        
            mDayPoints.Add CStr(Format(currAbsDate, "yyyymmdd")), thisDayPoints
            
            If currAbsDate > lastDisciplineTriggerDate Then
                dayPointsAfterNewPolicyStart = dayPointsAfterNewPolicyStart + thisDayPoints
            End If
            
            totalDayPoints = totalDayPoints + thisDayPoints
        Else
            If absCal.HasAnyWork Then
                prevDayIsWhole = False
                prevDayIsFraction = False
            Else
                ' e.g. person's days off
                ' values of the flags stay unchanged
            End If
        
            mDayPoints.Add CStr(Format(currAbsDate, "yyyymmdd")), 0
            
            If currAbsDate > lastDisciplineTriggerDate Then
                dayPointsAfterNewPolicyStart = dayPointsAfterNewPolicyStart + thisDayPoints
            End If
            
            totalDayPoints = totalDayPoints + 0
        End If
        
    Next
    
    If isLookBackMode = True Then
    
        If isInitialLookBackTest = True Then
        
            If totalDayPoints >= LOOKBACK_MIN_DAYS And dayPointsAfterNewPolicyStart > 0 Then
            
                ' now we need to know if it is before or after the end date
                If Now() > LOOKBACK_POLICY_END Then
                    ' in order to proceed with the lookback, the emp needs to have some eff
                    ' discipline TRIGGERED before the policy end date
                    
                    Set vDis = Nothing
                    Set oDis = Nothing
                    For Each vDis In allDisSet
                        Set oDis = vDis
                        If oDis.TriggeredOn <= LOOKBACK_POLICY_END Then
                        
                            twoYearsAgo = DateAdd("yyyy", -2, currDate)
                            
                            If twoYearsAgo > LOOKBACK_MIN_START_RANGE Then
                                Set tmpAllAbs = oEmp.GetAbsenceCalendar(twoYearsAgo, Now())
                                Set unprotAbs = oEmp.GetUnprotectedAbsences(twoYearsAgo)
                            Else
                                Set tmpAllAbs = oEmp.GetAbsenceCalendar(LOOKBACK_MIN_START_RANGE, Now())
                                Set unprotAbs = oEmp.GetUnprotectedAbsences(LOOKBACK_MIN_START_RANGE)
                            End If
                            
                            isInitialLookBackTest = False
                            GoTo StartOfProcedure
                        End If
                    Next
                    
                    GoTo EndOfRuleLoop2
                Else
                    twoYearsAgo = DateAdd("yyyy", -2, currDate)
                    
                    If twoYearsAgo > LOOKBACK_MIN_START_RANGE Then
                        Set tmpAllAbs = oEmp.GetAbsenceCalendar(twoYearsAgo, Now())
                        Set unprotAbs = oEmp.GetUnprotectedAbsences(twoYearsAgo)
                    Else
                        Set tmpAllAbs = oEmp.GetAbsenceCalendar(LOOKBACK_MIN_START_RANGE, Now())
                        Set unprotAbs = oEmp.GetUnprotectedAbsences(LOOKBACK_MIN_START_RANGE)
                    End If
                    
                    isInitialLookBackTest = False
                    GoTo StartOfProcedure
                End If
            Else
                GoTo EndOfRuleLoop2
            End If
            
        End If
        
    End If

    
    '3.  Get the last date worked for this emp
    LastDateWorked = #1/1/1970#
    oEmp.Attributes.Refresh
    If Not IsNull(oEmp.LastDateWorked) Then
        LastDateWorked = CDate(oEmp.LastDateWorked)
    End If
    
    Set allRules = Rules
        
    ' - get the last unprotected absence day for the employee
    Set lastUnprotectedAbsence = Nothing
    If unprotAbs.Count > 0 Then
        Set lastUnprotectedAbsence = unprotAbs.Item(unprotAbs.Count)
    End If
    
    ' - get the instance number for the last unprotected day
    If Not lastUnprotectedAbsence Is Nothing Then
        instNumOfLastUnprotAbs = mInstanceForAbs(CStr(Format(lastUnprotectedAbsence.OnDate, "yyyymmdd")))
    
        If lastUnprotectedAbsence.OnDate < EARLIEST_TRIGGER_DATE Then
            GoTo EndOfRuleLoop2
        End If
    
        ' - if there is any open or effective discipline against any day in the instance, NO notifications!
        If IsInstanceDisciplined(CStr(instNumOfLastUnprotAbs)) = True Then
            GoTo EndOfRuleLoop2
        End If
    Else
        GoTo EndOfRuleLoop2
    End If
        
    ' - check for AWOL first -- if there's any instances with AWOLs in them that have not
    '   been disciplined, all of the AWOLs in that instance get added to the cdc for suspension
    If isLookBackMode = False Then
        Set awolAbsSet = oEmp.GetAbsencesWithType(GetAWOLAbsType)
        Set filteredAWOLAbsSet = GetFilteredAWOLs(awolAbsSet, twoYearsAgo)
        
        If filteredAWOLAbsSet.Count > 0 Then
            v = allRules(8)
            Rule = v
            groupNumber = 1
            
            Set lastAWOL = filteredAWOLAbsSet(filteredAWOLAbsSet.Count)
            lastAWOLInstanceNumber = mInstanceForAbs(CStr(Format(lastAWOL.OnDate, "yyyymmdd")))
            Set lastAWOLInstanceSet = mInstances(CStr(lastAWOLInstanceNumber))
            Set lastAWOLInstanceSetAdj = GetAbsenceSetFromAbsCalSet(lastAWOLInstanceSet)
            
            Set l = lastAWOLInstanceSetAdj(lastAWOLInstanceSet.Count)
            
            'If LastDateWorked >= l.OnDate Then
            If doesLastDayHaveWork = True Then
                'i.  If the Employee has any worked days ON OR AFTER l, the WarnOnlyLevel
                ' bit is set to FALSE
                PutInCDC oEmp, cdc, lastAWOLInstanceSetAdj, 1, lastAWOLInstanceSetAdj.Count, Rule.ruleNbr, False, groupNumber, "AWOL on " & lastAWOL.OnDate
            Else
                'ii. If the Employee has NOT any worked days ON OR AFTER l, the WarnOnlyLevel
                '   bit is set to TRUE
                PutInCDC oEmp, cdc, lastAWOLInstanceSetAdj, 1, lastAWOLInstanceSetAdj.Count, Rule.ruleNbr, True, groupNumber, "AWOL on " & lastAWOL.OnDate
            End If
            
            GoTo EndOfRuleLoop2
            
        End If
    End If
        
    ' - find the FIRST ABSENCE DAY and FIRST ABSENCE INSTANCE START DATE in the qualifying period
    Set firstAbsenceInRange = Nothing
    firstInstanceIndexInRange = -1
    If unprotAbs.Count > 0 Then
        Set firstAbsenceInRange = unprotAbs.Item(1)
        
        If isLookBackMode = False Then
            If firstAbsenceInRange.OnDate = POLICY_EFF_DATE Then
                ' we need to look back to see if this instance actually started on Jan 9
                
                Set absCalSet = Nothing
                Set absCalSet = oEmp.GetAbsenceCalendar(DateAdd("d", -14, firstAbsenceInRange.OnDate), firstAbsenceInRange.OnDate)
                
                If firstAbsenceIsFraction Then
                    ' previous day on record must not have any work
                    For x = (absCalSet.Count - 1) To 1 Step -1
                        Set absCal = absCalSet(x)
                        If absCal.HasAnyWork = False And (absCal.IsProtected Or absCal.IsUnprotected) Then
                            ' instance started before january 9
                            firstInstanceIndexInRange = mInstanceForAbs(CStr(Format(firstAbsenceInRange.OnDate, "yyyymmdd")))
                            If mInstances.Exists(CStr(firstInstanceIndexInRange + 1)) Then
                                firstInstanceIndexInRange = firstInstanceIndexInRange + 1
                            Else
                                firstInstanceIndexInRange = -1
                            End If
                            
                            Exit For
                        Else
                            If absCal.HasAnyWork Then
                                firstInstanceIndexInRange = mInstanceForAbs(CStr(Format(firstAbsenceInRange.OnDate, "yyyymmdd")))
                                
                                Exit For
                            End If
                        End If
                    Next
                Else
                    ' first absence must have been a full day
                    
                    For x = (absCalSet.Count - 1) To 1 Step -1
                        Set absCal = absCalSet(x)
                        If absCal.IsProtected Or absCal.IsUnprotected Then
                            ' instance started before january 9
                            firstInstanceIndexInRange = mInstanceForAbs(CStr(Format(firstAbsenceInRange.OnDate, "yyyymmdd")))
                            If mInstances.Exists(CStr(firstInstanceIndexInRange + 1)) Then
                                firstInstanceIndexInRange = firstInstanceIndexInRange + 1
                            Else
                                firstInstanceIndexInRange = -1
                            End If
                            
                            Exit For
                        Else
                            If absCal.HasAnyWork Then
                                firstInstanceIndexInRange = mInstanceForAbs(CStr(Format(firstAbsenceInRange.OnDate, "yyyymmdd")))
                                
                                Exit For
                            End If
                        End If
                    Next
                
                End If
                    
            Else
                ' the first instance starts on or after January 9, 2006
                firstInstanceIndexInRange = mInstanceForAbs(CStr(Format(firstAbsenceInRange.OnDate, "yyyymmdd")))
            End If
        End If
    End If

        
    ' DAYS SECTION
    For ruleIdx = startingRuleIndex To endingRuleIndex Step -1
        
        v = allRules(CLng(ruleIdx))
        Rule = v
        n = Rule.ruleN
        m = Rule.ruleM
        i = Rule.RuleI
        
        If unprotAbs.Count = 0 Then
            Exit For
        End If
        foundLocal = False
        
        runningDayPoints = 0
        
        For Each absV2 In unprotAbs
            Set oAbs = absV2
            currAbsDate = oAbs.OnDate
            thisDayPoints = mDayPoints(CStr(Format(currAbsDate, "yyyymmdd")))
            runningDayPoints = runningDayPoints + thisDayPoints
        Next
        
        If runningDayPoints < (n + 1) Then
            GoTo NextRule
        End If
        
        For Each absV In unprotAbs
            
            Set c = absV
            
            cutoffDate = DateAdd("m", m, c.OnDate)          '' Z1
            
            runningDayPoints = 0
            Set prevAbs = Nothing
            Set oAbs = Nothing
            Set firstAbs = Nothing
            
            For Each absV2 In unprotAbs
                Set oAbs = absV2
                currAbsDate = oAbs.OnDate
                If currAbsDate >= c.OnDate Then
                    thisDayPoints = mDayPoints(CStr(Format(currAbsDate, "yyyymmdd")))
                    If currAbsDate <= cutoffDate Then
                        runningDayPoints = runningDayPoints + thisDayPoints
                        If thisDayPoints > 0 Then
                            Set prevAbs = oAbs
                            If firstAbs Is Nothing Then
                                Set firstAbs = oAbs
                            End If
                        End If
                    Else
                        Exit For
                    End If
                End If
            Next
            
            ' prevAbs at this point is the last absence that had day points!
            
            ' we now have the starting date in "c" and the ending date in
            ' "oAbs" and the number of daypoints in runningDayPoints
            

            
            If runningDayPoints < (n + 1) Then
                ' do nothing
                'Exit For
                GoTo NextAbsLoopDaysSection
            Else
            
                If prevAbs Is Nothing Then
                    Debug.Print "ERROR!!!"
                End If
            
                If Not prevAbs Is Nothing Then
                    If mDisContainingAbs.Exists(CStr(prevAbs.Identifier)) Then
                        Set collDis = mDisContainingAbs.Item(CStr(prevAbs.Identifier))
                    Else
                        Set collDis = prevAbs.GetContainingDis(True)
                        mDisContainingAbs.Add CStr(prevAbs.Identifier), collDis
                    End If
                    
                    If collDis.Count > 0 Then
                        GoTo NextAbsLoopDaysSection
                    End If
                End If
            
                If runningDayPoints < unprotAbs.Count Then
                    halfDaysTriggerString = "+"
                Else
                    halfDaysTriggerString = ""
                End If
            
                'monthDiff = GetMonthDiff(c.OnDate, oAbs.OnDate)
                
                monthDiff = GetMonthDiff(firstAbs.OnDate, prevAbs.OnDate)
            
                If AnyAbsInHigherDis(oEmp, unprotAbs, 1, unprotAbs.Count, Rule.ruleNbr) Then
                    ' do nothing
                Else
                    If AllInstDeferredForRule(oEmp, unprotAbs, 1, unprotAbs.Count, ruleIdx) Then
                        ' do nothing
                    Else
                        If doesLastDayHaveWork = True Then
                            'i.  If the Employee has any worked days ON OR AFTER l, the WarnOnlyLevel
                            ' bit is set to FALSE
                            If monthDiff = 1 Then
                                PutInCDC oEmp, cdc, unprotAbs, 1, unprotAbs.Count, Rule.ruleNbr, False, groupNumber, runningDayPoints & halfDaysTriggerString & " days within " & monthDiff & " month" & lookBackTriggerString
                            Else
                                PutInCDC oEmp, cdc, unprotAbs, 1, unprotAbs.Count, Rule.ruleNbr, False, groupNumber, runningDayPoints & halfDaysTriggerString & " days within " & monthDiff & " months" & lookBackTriggerString
                            End If
                            groupNumber = groupNumber + 1
                            foundLocal = True
                        Else
                            'ii. If the Employee has NOT any worked days ON OR AFTER l, the WarnOnlyLevel
                            '   bit is set to TRUE
                            If monthDiff = 1 Then
                                PutInCDC oEmp, cdc, unprotAbs, 1, unprotAbs.Count, Rule.ruleNbr, True, groupNumber, runningDayPoints & halfDaysTriggerString & " days within " & monthDiff & " month" & lookBackTriggerString
                            Else
                                PutInCDC oEmp, cdc, unprotAbs, 1, unprotAbs.Count, Rule.ruleNbr, True, groupNumber, runningDayPoints & halfDaysTriggerString & " days within " & monthDiff & " months" & lookBackTriggerString
                            End If
                            groupNumber = groupNumber + 1
                            foundLocal = True
                        End If
                    End If
                
                End If
            
            End If
            
            If foundLocal = True Then
                Exit For
            End If
        
NextAbsLoopDaysSection:
        
        Next
        
        If foundLocal = False Then
            GoTo NextRule
        Else
            Exit For
        End If
        
        
        'if ' *****************
        'If mDisContainingAbs.Exists(CStr(l.Identifier)) Then
        '    GoTo NextRule
        'End If
        
        'If monthDiff > m Then
        '    GoTo NextRule
        'End If
        
        'monthDiff = GetMonthDiff(c.OnDate, lastUnprotectedAbsence.OnDate)
       
            
                
NextRule:
    Next
    
EndOfRuleLoop:
    
    
    ' INSTANCES SECTION
    If isLookBackMode = False And firstInstanceIndexInRange > -1 And cdc.Count = 0 Then
        
        For ruleIdx = startingRuleIndex To endingRuleIndex Step -1
            
            v = allRules(CLng(ruleIdx))
            Rule = v
            n = Rule.ruleN
            m = Rule.ruleM
            i = Rule.RuleI
    
            
            
            For x = firstInstanceIndexInRange To mInstances.Count
            
                InstancePoints = 0
            
                For currInstanceNumber = x To mInstances.Count
                    monthDiff = GetMonthDiff(mInstanceStartDate(CStr(x)), mInstanceStartDate(CStr(currInstanceNumber)))
                    
                    If monthDiff <= m Then
                        y = mInstancePoints(CStr(currInstanceNumber))
                        InstancePoints = InstancePoints + y
                        
                        If y > 0 Then
                            lastUnprotectedInstanceNum = currInstanceNumber
                            oldMonthDiff = monthDiff
                        End If
                        
                    Else
                        monthDiff = oldMonthDiff
                        Exit For
                    End If
                Next
                
                If currInstanceNumber > 1 Then
                    currInstanceNumber = currInstanceNumber - 1
                End If
        
                If InstancePoints > i Then
                
                   
                    If IsInstanceDisciplined(CStr(lastUnprotectedInstanceNum)) Then
                        GoTo NextRule2
                    End If
                
                    If AnyAbsInHigherDis(oEmp, unprotAbs, 1, unprotAbs.Count, Rule.ruleNbr) Then
                        GoTo NextRule2
                    End If
                    
                    'If AllInstDeferredForRule(oEmp, unprotAbs, 1, unprotAbs.Count, ruleIdx) Then
                    '    Exit For
                    'End If
                    If AllInstInInstRangeDeferredForRule(oEmp, unprotAbs, firstInstanceIndexInRange, lastUnprotectedInstanceNum, ruleIdx) Then
                        Exit For
                    End If
        
                    If LastDateWorked >= lastUnprotectedAbsence.OnDate Then
                        'i.  If the Employee has any worked days ON OR AFTER l, the WarnOnlyLevel
                        ' bit is set to FALSE
                        If monthDiff = 1 Then
                            PutInCDC oEmp, cdc, unprotAbs, 1, unprotAbs.Count, Rule.ruleNbr, False, groupNumber, InstancePoints & " instances within " & monthDiff & " month"
                        Else
                            PutInCDC oEmp, cdc, unprotAbs, 1, unprotAbs.Count, Rule.ruleNbr, False, groupNumber, InstancePoints & " instances within " & monthDiff & " months"
                        End If
                        groupNumber = groupNumber + 1
                        Exit For
                    Else
                        'ii. If the Employee has NOT any worked days ON OR AFTER l, the WarnOnlyLevel
                        '   bit is set to TRUE
                        If monthDiff = 1 Then
                            PutInCDC oEmp, cdc, unprotAbs, 1, unprotAbs.Count, Rule.ruleNbr, True, groupNumber, InstancePoints & " instances within " & monthDiff & " month"
                        Else
                            PutInCDC oEmp, cdc, unprotAbs, 1, unprotAbs.Count, Rule.ruleNbr, True, groupNumber, InstancePoints & " instances within " & monthDiff & " months"
                        End If
                        groupNumber = groupNumber + 1
                        Exit For
                    End If
                    
                End If
            Next
            
NextRule2:
        Next
    End If
            
EndOfRuleLoop2:

    If isLookBackMode = False Then
        If cdc.Count = 0 Then
            isLookBackMode = True
            GoTo StartOfProcedure
        End If
    End If
    
UpdateDatabase:
    
    
    '5.  Get all of this Employee's Notifications of status 'Open'.
    Set notifColl = oEmp.GetNotif(True)
    
    If oEmp.IsInactive Then
        Set virtualNotifs = New Scripting.Dictionary
    Else
        Set virtualNotifs = GetVirtualNotifs(oEmp, cdc)
    End If
    
    SyncNotifs oEmp, virtualNotifs, notifColl

    debugEndTime = Now()
    debugTimeElapsed = DateDiff("s", debugStartTime, debugEndTime)
    Debug.Print "   Done " & debugTimeElapsed
    If debugTimeElapsed > 2 Then
        Debug.Print "LONG"
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
    
    Dim rule1 As ExAbsRule2, rule2 As ExAbsRule2, rule3 As ExAbsRule2
    Dim rule4 As ExAbsRule2, rule5 As ExAbsRule2, rule6 As ExAbsRule2
    Dim rule7 As ExAbsRule2, rule8 As ExAbsRule2, rule0 As ExAbsRule2
    
    With rule1
        .ruleAlias = RULE_ALIAS_1: .ruleN = 5: .ruleM = 3: .RuleI = 3: .ruleNbr = 1: Set .ruleObject = GetRuleObj(.ruleAlias)
        coll.Add rule1, CStr(.ruleAlias)
    End With
    With rule2
        .ruleAlias = RULE_ALIAS_2: .ruleN = 7: .ruleM = 6: .RuleI = 4: .ruleNbr = 2: Set .ruleObject = GetRuleObj(.ruleAlias)
        coll.Add rule2, CStr(.ruleAlias)
    End With
    With rule3
        .ruleAlias = RULE_ALIAS_3: .ruleN = 8: .ruleM = 9: .RuleI = 5: .ruleNbr = 3: Set .ruleObject = GetRuleObj(.ruleAlias)
        coll.Add rule3, CStr(.ruleAlias)
    End With
    With rule4
        .ruleAlias = RULE_ALIAS_4: .ruleN = 9: .ruleM = 12: .RuleI = 7: .ruleNbr = 4: Set .ruleObject = GetRuleObj(.ruleAlias)
        coll.Add rule4, CStr(.ruleAlias)
    End With
    With rule5
        .ruleAlias = RULE_ALIAS_5: .ruleN = 12: .ruleM = 16: .RuleI = 8: .ruleNbr = 5: Set .ruleObject = GetRuleObj(.ruleAlias)
        coll.Add rule5, CStr(.ruleAlias)
    End With
    With rule6
        .ruleAlias = RULE_ALIAS_6: .ruleN = 15: .ruleM = 20: .RuleI = 9: .ruleNbr = 6: Set .ruleObject = GetRuleObj(.ruleAlias)
        coll.Add rule6, CStr(.ruleAlias)
    End With
    With rule7
        .ruleAlias = RULE_ALIAS_7: .ruleN = 18: .ruleM = 24: .RuleI = 12: .ruleNbr = 7: Set .ruleObject = GetRuleObj(.ruleAlias)
        coll.Add rule7, CStr(.ruleAlias)
    End With
    With rule0
        .ruleAlias = RULE_ALIAS_0: .ruleN = 999: .ruleM = 1: .RuleI = 999: .ruleNbr = 8: Set .ruleObject = GetRuleObj(.ruleAlias)
        coll.Add rule0, CStr(.ruleAlias)
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

' *
Private Function AnyAbsInHigherDis(oEmp As A2Employee, iColl As A2IObjSet, _
        iStartIdx As Long, iEndIdx As Long, iRuleIdx As Long) As Boolean

Dim i As Long, oAbs As A2Abs, collDis As A2IObjSet, v As Variant, oDis As A2Dis
Dim oRule As A2Rule, ruleUDT As ExAbsRule2

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
            If ruleUDT.ruleNbr > iRuleIdx And Not oRule.Alias = RULE_ALIAS_0 Then
                AnyAbsInHigherDis = True
                Exit Function
            End If
        End If
    Next
Next

AnyAbsInHigherDis = False

End Function

Private Sub PutInCDC(oEmp As A2Employee, ByRef iCDC As Scripting.Dictionary, iColl As A2IObjSet, _
        iStartIdx As Long, iEndIdx As Long, iRuleIdx As Long, warnOnlyFlag As Boolean, _
        iGroupNumber As Long, Optional triggerString As String = "")


Dim cd As CCaughtDay

Dim i As Long, oAbs As A2Abs
For i = iStartIdx To iEndIdx
    Set oAbs = iColl(i)
    Set cd = New CCaughtDay
    Set cd.oAbs = oAbs
    cd.ruleNum = iRuleIdx
    cd.warnOnlyLevel = warnOnlyFlag
    cd.groupNumber = iGroupNumber
    cd.triggerString = triggerString
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
'Dim i As Long, oAbs As A2Abs
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

Private Function GetMonthDiff(iDate1 As Date, iDate2 As Date) As Long
    Dim i As Long
    i = DateDiff("m", iDate1, iDate2)
    
    Dim d1 As Long, d2 As Long
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

Private Function IsRuleInExAbsTrack(iAlias As String) As Boolean
    Dim v As Variant, rudt As ExAbsRule2
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

' True if any absence in the instance is disciplined.
Private Function IsInstanceDisciplined(instNum As String) As Boolean
    Dim absSet As A2ObjSet
    Dim vAbs As Variant
    Dim currAbs As A2Abs
    Dim collDis As A2IObjSet
    
    Dim absCal As A2AbsCalDay
    
    If mIsInstanceDis.Exists(instNum) Then
        IsInstanceDisciplined = mIsInstanceDis.Item(instNum)
    Else
        Set absSet = mInstances(instNum)
        For Each vAbs In absSet.coll
            Set absCal = vAbs
            Set currAbs = absCal.Absence
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

Private Function GetVirtualNotifs(oEmp As A2Employee, iCDC As Scripting.Dictionary) _
    As Scripting.Dictionary

    Dim oCD As CCaughtDay
    Dim i As Long
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
            virtualNotif.TriggerNote = oCD.triggerString
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
                        If oActualNotif.TriggerNote = oVirtualNotif.TriggerNote Then
                            If oActualNotif.Absences.IsEqualTo(oVirtualNotif.Absences.AsIObjSet) Then
                                localBool = True
                                Exit For
                            End If
                        End If
                    End If
                End If
            Next
            If localBool = False Then
                oActualNotif.Cancel
                Debug.Print "   Removed notification"
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
                    If oActualNotif.TriggerNote = oVirtualNotif.TriggerNote Then
                        If oActualNotif.Absences.IsEqualTo(oVirtualNotif.Absences.AsIObjSet) Then
                            localBool = True
                            Exit For
                        End If
                    End If
                End If
            End If
        Next
        If localBool = False Then
            CreateNotifFromVirtual oEmp, oVirtualNotif
            Debug.Print "   Created notification"
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
    Dim noteGop As A2GetObjParm
    
    Set empGop.parm = lookup.Parameters("emp")
    Set empGop.Val = oEmp
    Set notTypeGop.parm = lookup.Parameters("notType")
    Set notTypeGop.Val = oNotType
    Set ruleGop.parm = lookup.Parameters("rule")
    Set ruleGop.Val = oVirtualNotif.Rule
    Set absGrpGop.parm = lookup.Parameters("absGrp")
    Set absGrpGop.Val = oAbsGrp
    Set noteGop.parm = lookup.Parameters("triggerNote")
    noteGop.Val = oVirtualNotif.TriggerNote

    mSys.Execute Array(empGop, notTypeGop, ruleGop, absGrpGop, noteGop)

End Sub

Private Function AllInstDeferredForRule(oEmp As A2Employee, _
    iColl As A2IObjSet, iStartIdx As Long, iEndIdx As Long, _
    iRuleIdx As Long) As Boolean

    ' first, clump the absences into instances
    Dim instancesToCheck As Scripting.Dictionary
    Set instancesToCheck = New Scripting.Dictionary
    
    Dim instNum As String
    
    Dim s As String
    Dim oAbs As A2Abs
    
    Dim i As Long
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

Private Function AllInstInInstRangeDeferredForRule(oEmp As A2Employee, _
    iColl As A2IObjSet, iStartIdx As Long, iEndIdx As Long, _
    iRuleIdx As Long) As Boolean

    ' first, clump the absences into instances
    Dim instancesToCheck As Scripting.Dictionary
    Set instancesToCheck = New Scripting.Dictionary
    
    Dim instNum As String
    
    Dim s As String
    Dim oAbs As A2Abs
    
    Dim i As Long
    For i = iStartIdx To iEndIdx
        If mInstancePoints(CStr(i)) > 0 Then
            instancesToCheck.Add i, Nothing
        End If
    Next

    Dim v As Variant
    For Each v In instancesToCheck.Keys
        s = v
        If Not IsInstanceDeferredForRule(s, iRuleIdx) Then
            AllInstInInstRangeDeferredForRule = False
            Exit Function
        End If
    Next
    AllInstInInstRangeDeferredForRule = True
    
End Function
Private Function IsInstanceDeferredForRule(instNum As String, iRuleIdx As Long) As Boolean
    Dim absSet As A2ObjSet
    Dim vAbs As Variant
    Dim currAbs As A2Abs
    Dim collDis As A2IObjSet
    Dim vDis As Variant
    Dim oDis As A2Dis
    Dim absCal As A2AbsCalDay
    
    If mIsInstanceDeferred.Exists(instNum & "/" & iRuleIdx) Then
        IsInstanceDeferredForRule = mIsInstanceDeferred.Item(instNum & "/" & iRuleIdx)
    Else
        Set absSet = mInstances(instNum)
        For Each vAbs In absSet.coll
            Set absCal = vAbs
            Set currAbs = absCal.Absence
            
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

Private Function GetAbsFromEmpAndDate(iEmp As Variant, iDate As Variant) As A2Abs
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

Private Function GetAWOLAbsType() As A2AbsType
    If mAWOLAbsType Is Nothing Then
        Dim lookup As A2ILookupType
        Set lookup = mSys.LookupTypes("GetAbsTypeByAlias")
        Dim gop As A2GetObjParm
        Set gop.parm = lookup.Parameters("alias")
        gop.Val = AWOL_ABSTYPE
        Set mAWOLAbsType = mSys.GetObject(mSys.ObjectTypes("AbsType"), gop)
    End If
    
    If mAWOLAbsType Is Nothing Then
        Err.Raise vbObjectError, "Attend2A", "AWOL absence type not available"
    Else
        Set GetAWOLAbsType = mAWOLAbsType
    End If
End Function

Private Function GetRedMissAbsType() As A2AbsType
    If mRedMissAbsType Is Nothing Then
        Dim lookup As A2ILookupType
        Set lookup = mSys.LookupTypes("GetAbsTypeByAlias")
        Dim gop As A2GetObjParm
        Set gop.parm = lookup.Parameters("alias")
        gop.Val = RED_MISS_ABSTYPE
        Set mRedMissAbsType = mSys.GetObject(mSys.ObjectTypes("AbsType"), gop)
    End If
    
    If mRedMissAbsType Is Nothing Then
        Err.Raise vbObjectError, "Attend2A", "RedMiss absence type not available"
    Else
        Set GetRedMissAbsType = mRedMissAbsType
    End If
End Function

Private Function GetFilteredAWOLs(overallColl As A2IObjSet, startingDate As Date) As A2IObjSet
    Dim objSet As A2ObjSet
    Set objSet = New A2ObjSet
    
    Dim vAbs As Variant, oAbs As A2Abs
    Dim disColl As A2IObjSet, vDis As Variant, oDis As A2Dis
    Dim localBool As Boolean
    
    Dim instanceNumber As Long
    
    Dim collDis As A2IObjSet
    
    For Each vAbs In overallColl
    
        Set oAbs = vAbs
        If oAbs.OnDate >= startingDate Then
        
            If oAbs.PrimaryType.IsProtected = False Then
                instanceNumber = mInstanceForAbs(CStr(Format(oAbs.OnDate, "yyyymmdd")))
                
                If Not IsInstanceDisciplined(CStr(instanceNumber)) Then

                    If mAllDisContainingAbs.Exists(CStr(oAbs.Identifier)) Then
                        Set collDis = mAllDisContainingAbs.Item(CStr(oAbs.Identifier))
                    Else
                        Set collDis = oAbs.GetContainingDis(False)
                        mAllDisContainingAbs.Add CStr(oAbs.Identifier), collDis
                    End If
                    
                    localBool = False
                    For Each vDis In collDis
                        Set oDis = vDis
                        If oDis.Status = a2DisStatusDeferred Then
                            localBool = True
                            Exit For
                        End If
                    Next
                    
                    If localBool = False Then       ' if the AWOL is in a deferred instance
                        objSet.coll.Add oAbs
                    End If
                End If
            
            End If
        End If
    Next
    
    Set GetFilteredAWOLs = objSet
End Function

Private Function GetAbsenceSetFromAbsCalSet(oSet As A2IObjSet) As A2IObjSet

    Dim newSet As A2IObjSet
    Set newSet = New A2ObjSet
    
    Dim newsetx As A2ObjSet
    Set newsetx = newSet
    
    Dim v As Variant
    Dim absCal As A2AbsCalDay
    For Each v In oSet
        Set absCal = v
        newsetx.coll.Add absCal.Absence
    Next

    Set GetAbsenceSetFromAbsCalSet = newSet
    
End Function
