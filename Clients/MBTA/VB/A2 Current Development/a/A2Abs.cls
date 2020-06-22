VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2Abs"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
  Option Explicit

Implements A2IObject
Private mAttrs As A2IObjAttrs
Private mSys As A2System

' In terms of whether to use Replace + AddType or just AddType, the API
' does not make a distinction between an absence being altered a second after
' it is created and one altered a month after -- it is the application developer's
' choice as to whether to use the 'Replace' feature to retain history.

Private Property Get A2IObject_AsA2IObject() As A2IObject
    Set A2IObject_AsA2IObject = Me
End Property

Private Property Get A2IObject_AsIDefault() As Object
    Dim iDef As A2Abs
    Set iDef = Me
    Set A2IObject_AsIDefault = iDef

End Property

Private Property Get A2IObject_AsIDispatch() As Object
    Set A2IObject_AsIDispatch = Me
End Property


Private Property Set A2IObject_Attributes(RHS As A2IObjAttrs)
    If mAttrs Is Nothing Then
        Set mAttrs = RHS
    End If
End Property

Private Property Get A2IObject_Attributes() As A2IObjAttrs
    Set A2IObject_Attributes = mAttrs
End Property


Private Property Get A2IObject_Identifier() As Variant
    A2IObject_Identifier = Me.Attributes(Me.Attributes.ObjectType.IdentAttribute.Alias).Value
End Property
Private Function A2IObject_IsEqualTo(iObj As A2IObject) As Boolean
    If Me.ObjectType.EqualTo(iObj.ObjectType) Then
        If Me.Identifier = iObj.Identifier Then
            A2IObject_IsEqualTo = True
        Else
            A2IObject_IsEqualTo = False
        End If
    Else
        A2IObject_IsEqualTo = False
    End If
End Function
Private Property Get A2IObject_ObjectType() As A2IObjType
    Set A2IObject_ObjectType = Me.Attributes.ObjectType
End Property

Private Property Set A2IObject_System(RHS As A2System)
    If mSys Is Nothing Then
        Set mSys = RHS
    End If
End Property

Private Property Get A2IObject_System() As A2System
    Set A2IObject_System = mSys
End Property

Public Property Get OnDate() As Date
    OnDate = mAttrs(OAA_ABS_DATE).Value
End Property
Public Property Get IsEstimated() As Boolean
    If Me.Source.Identifier = 2 And Me.DateCreated < #8/1/2007# Then
        IsEstimated = True
    Else
        IsEstimated = False
    End If
    
End Property

' NOTE: CAN BE NOTHING/NULL!
Public Property Get PrimaryType() As A2AbsType
Attribute PrimaryType.VB_Description = "Note: can be Nothing"
    Set PrimaryType = mAttrs(OAA_ABS_PRIMARY_ABS_TYPE).Value
End Property

Public Property Get DateCreated() As Date
    DateCreated = mAttrs(OAA_ABS_DATE_CREATED).Value
End Property

Public Function GetTypesWithMinutes() As A2IObjSet
    Dim parm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_GET_ABS_TYPES_FOR_ABS_WITH_MINUTES)
    Set parm = lookup.Parameters(LTPA_GET_ABS_TYPES_FOR_ABS_WITH_MINUTES_ABS)
    
    Dim gop As A2GetObjParm
    Set gop.parm = parm
    Set gop.Val = Me
    
    Set GetTypesWithMinutes = mSys.GetObjects(gop)
End Function

Public Property Get Types() As A2IObjSet
    Dim parm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_ABS_TYPE_FOR_ABS)
    Set parm = lookup.Parameters(LTPA_ABS_TYPS_FOR_ABS_ABS)
    
    Dim gop As A2GetObjParm
    Set gop.parm = parm
    Set gop.Val = Me
    
    Set Types = mSys.GetObjects(gop)
End Property

Public Property Get Employee() As A2Employee
    Dim v As Variant
    Set Employee = mAttrs(OAA_ABS_EMPLOYEE).Value
End Property

Public Property Get Area() As A2Area
    Set Area = mAttrs(OAA_ABS_AREA).Value
End Property

Public Property Get Source() As A2Source
    Set Source = mAttrs(OAA_ABS_SOURCE).Value
End Property

Public Property Get Creator() As A2User
    Set Creator = mAttrs(OAA_ABS_CREATOR).Value
End Property

Public Property Get IsReplaced() As Boolean
    IsReplaced = mAttrs(OAA_ABS_IS_REPLACED).Value
End Property

Public Property Get ReplacedBy() As A2Abs
    Set ReplacedBy = mAttrs(OAA_ABS_REPLACED_BY).Value
End Property

Public Property Get Replaces() As A2IObjSet
Attribute Replaces.VB_Description = "Get the absence(s) that this absence replaces -- non-recursive"

    Dim parm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_ABS_REPLACED_BY)
    Set parm = lookup.Parameters(LTPA_ABS_REPLACED_BY_ABS)
    
    Dim gop As A2GetObjParm
    Set gop.parm = parm
    Set gop.Val = Me
    
    Set Replaces = mSys.GetObjects(gop)
End Property

Public Function Replace(iSrc As A2Source, iAbsenceTypes As A2IObjSet, Optional iRecheckNotifications As Boolean = True) As A2Abs
    On Error GoTo ReplaceAbsErr
    
    Dim oAbs As A2Abs
    Dim parm1 As A2ILookupTypeParm, parm2 As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_REPLACE_ABS)
    Set parm1 = lookup.Parameters(LTPA_REPLACE_ABS_ORIG)
    Set parm2 = lookup.Parameters(LTPA_REPLACE_ABS_NEW_SRC)
    
    Dim gop1 As A2GetObjParm, gop2 As A2GetObjParm
    Set gop1.parm = parm1
    Set gop1.Val = Me
    Set gop2.parm = parm2
    Set gop2.Val = iSrc
    
    mSys.StartTransaction
    
    Set oAbs = mSys.GetObject(Me.Attributes.ObjectType, Array(gop1, gop2))
    
    Dim v As Variant, oAbsType As A2AbsType
    For Each v In iAbsenceTypes
        Set oAbsType = v
        'oAbs.AddType oAbsType
        oAbs.AddTypePriv oAbsType, True, 0
    Next
          
    mSys.CommitTransaction
    
    Me.Attributes.Refresh
    Me.Employee.Attributes.Refresh
    
    If iRecheckNotifications Then
        mSys.Publish a2PubEvTypeAbsReplaced, Me
    End If
    
    Set Replace = oAbs
    Exit Function
    
ReplaceAbsErr:
    Dim errNum As Long, errDesc As String, errSrc As String
    errNum = Err.Number
    errDesc = Err.Description
    errSrc = Err.Source
    mSys.RollbackTransaction
    Err.Raise a2ErrReplaceAbs, "Attend2A.A2Abs", "The Absence could not be replaced: " & errDesc & " (" & errSrc & "/" & errNum & ")"
End Function

Public Function ReplaceWithoutTypes(iSrc As A2Source, Optional iRecheckNotifications As Boolean = True) As A2Abs
    On Error GoTo ReplaceAbsErr
    
    Dim oAbs As A2Abs
    Dim parm1 As A2ILookupTypeParm, parm2 As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_REPLACE_ABS)
    Set parm1 = lookup.Parameters(LTPA_REPLACE_ABS_ORIG)
    Set parm2 = lookup.Parameters(LTPA_REPLACE_ABS_NEW_SRC)
    
    Dim gop1 As A2GetObjParm, gop2 As A2GetObjParm
    Set gop1.parm = parm1
    Set gop1.Val = Me
    Set gop2.parm = parm2
    Set gop2.Val = iSrc
    
    mSys.StartTransaction
    
    Set oAbs = mSys.GetObject(Me.Attributes.ObjectType, Array(gop1, gop2))
              
    mSys.CommitTransaction
    
    Me.Attributes.Refresh
    Me.Employee.Attributes.Refresh
    
    If iRecheckNotifications Then
        mSys.Publish a2PubEvTypeAbsReplaced, Me
    End If
    
    Set ReplaceWithoutTypes = oAbs
    Exit Function
    
ReplaceAbsErr:
    Dim errNum As Long, errDesc As String, errSrc As String
    errNum = Err.Number
    errDesc = Err.Description
    errSrc = Err.Source
    mSys.RollbackTransaction
    Err.Raise a2ErrReplaceAbs, "Attend2A.A2Abs", "The Absence could not be replaced: " & errDesc & " (" & errSrc & "/" & errNum & ")"
    
    mSys.Publish a2PubEvTypeAbsReplaced, Me ' Just in case
End Function


Friend Sub AddTypePriv(iAbsType As A2AbsType, skipRefresh As Boolean, iMinutes As Long)
    Dim o As Object
    Dim parm1 As A2ILookupTypeParm, parm2 As A2ILookupTypeParm, parm3 As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_ADD_TYPE_TO_ABS_WITH_MINUTES)
    Set parm1 = lookup.Parameters(LTPA_ADD_TYPE_TO_ABS_WITH_MINUTES_ABS)
    Set parm2 = lookup.Parameters(LTPA_ADD_TYPE_TO_ABS_WITH_MINUTES_ABS_TYPE)
    Set parm3 = lookup.Parameters(LTPA_ADD_TYPE_TO_ABS_WITH_MINUTES_MINUTES)
    
    Dim gop1 As A2GetObjParm, gop2 As A2GetObjParm, gop3 As A2GetObjParm
    Set gop1.parm = parm1
    Set gop1.Val = Me
    Set gop2.parm = parm2
    Set gop2.Val = iAbsType
    Set gop3.parm = parm3
    gop3.Val = iMinutes
    
    mSys.GetObjects Array(gop1, gop2, gop3)
    Me.Attributes.Refresh

    If skipRefresh = False Then
        mSys.Publish a2PubEvTypeAbsAltered, Me
        Me.Employee.Attributes.Refresh
    End If

End Sub

Public Sub AddType(iAbsType As A2AbsType, Optional delayCheck As Boolean = False, Optional iMinutes As Long = 0)
    AddTypePriv iAbsType, delayCheck, iMinutes
End Sub

Public Function GetContainingDis(iOpenOrEffOnly As Boolean, Optional iIncludeDeferred As Boolean = False) As A2IObjSet
    Dim o As Object
    Dim parm1 As A2ILookupTypeParm, parm2 As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    If iIncludeDeferred = True Then
        Set lookup = mSys.LookupTypes(LTA_DIS_FOR_ABS_WITH_DEFERRED)
        Set parm1 = lookup.Parameters(LTPA_DIS_FOR_ABS_DEF_ABS)
        Set parm2 = lookup.Parameters(LTPA_DIS_FOR_ABS_DEF_OPEN_EFF_ONLY)
    Else
        Set lookup = mSys.LookupTypes(LTA_DIS_FOR_ABS)
        Set parm1 = lookup.Parameters(LTPA_DIS_FOR_ABS_ABS)
        Set parm2 = lookup.Parameters(LTPA_DIS_FOR_ABS_OPEN_EFF_ONLY)
    End If
    
    Dim gop1 As A2GetObjParm, gop2 As A2GetObjParm
    Set gop1.parm = parm1
    Set gop1.Val = Me
    Set gop2.parm = parm2
    gop2.Val = iOpenOrEffOnly
    
    Set GetContainingDis = mSys.GetObjects(Array(gop1, gop2))

End Function

Public Function GetContainingNotif(iOpenOnly As Boolean) As A2IObjSet
    Dim o As Object
    Dim parm1 As A2ILookupTypeParm, parm2 As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_NOTIFS_FOR_ABS)
    Set parm1 = lookup.Parameters(LTPA_NOTIFS_FOR_ABS_ABS)
    Set parm2 = lookup.Parameters(LTPA_NOTIFS_FOR_ABS_OPEN_ONLY)
    
    Dim gop1 As A2GetObjParm, gop2 As A2GetObjParm
    Set gop1.parm = parm1
    Set gop1.Val = Me
    Set gop2.parm = parm2
     gop2.Val = iOpenOnly
    
    Set GetContainingNotif = mSys.GetObjects(Array(gop1, gop2))

End Function


' Add A2IObject methods to the default interface for convenience of users (esp VBScript)
Public Property Get Attributes() As A2IObjAttrs: Set Attributes = A2IObject_Attributes: End Property
Public Property Get Identifier() As Variant: Identifier = A2IObject_Identifier: End Property
Public Property Get AsA2IObject() As A2IObject: Set AsA2IObject = A2IObject_AsA2IObject: End Property
Public Property Get AsIDefault() As Object: Set AsIDefault = A2IObject_AsIDefault: End Property
Public Property Get AsIDispatch() As Object: Set AsIDispatch = A2IObject_AsIDispatch: End Property
Public Property Get ObjectType() As A2IObjType: Set ObjectType = A2IObject_ObjectType: End Property
Public Property Get System() As A2System: Set System = A2IObject_System: End Property
Public Function IsEqualTo(iObj As A2IObject) As Boolean: IsEqualTo = A2IObject_IsEqualTo(iObj): End Function
