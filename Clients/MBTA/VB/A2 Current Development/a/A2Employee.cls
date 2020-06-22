VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2Employee"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements A2IObject
Private mAttrs As A2IObjAttrs
Private mSys As A2System

Private Property Get A2IObject_AsA2IObject() As A2IObject
    Set A2IObject_AsA2IObject = Me
End Property

Private Property Get A2IObject_AsIDefault() As Object
    Dim iDef As A2Employee
    Set iDef = Me
    Set A2IObject_AsIDefault = iDef

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
    A2IObject_Identifier = mAttrs(mAttrs.ObjectType.IdentAttribute.Alias).Value
End Property

Private Property Get A2IObject_ObjectType() As A2IObjType
    Set A2IObject_ObjectType = mAttrs.ObjectType
End Property

Private Property Set A2IObject_System(RHS As A2System)
    If mSys Is Nothing Then
        Set mSys = RHS
    End If
End Property

Private Property Get A2IObject_System() As A2System
    Set A2IObject_System = mSys
End Property

Public Property Get IsInactive() As Boolean
    IsInactive = mAttrs(OAA_EMP_IS_INACTIVE).Value
End Property

Public Property Get BadgeNumber() As Long
    BadgeNumber = mAttrs(OAA_EMP_BADGE_NUM).Value
End Property

Public Property Get EmpName() As String
    EmpName = mAttrs(OAA_EMP_NAME).Value
End Property

Public Function GetAbsenceCalendar(iFromDate As Date, iToDate As Date) As A2IObjSet
    Dim parm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_GET_ABS_CAL)
    
    Dim gop As A2GetObjParm, gop2 As A2GetObjParm, gop3 As A2GetObjParm
    Set gop.parm = lookup.Parameters(LTPA_GET_ABS_CAL_EMP)
    Set gop.Val = Me
    Set gop2.parm = lookup.Parameters(LTPA_GET_ABS_CAL_FROM_DATE)
    gop2.Val = iFromDate
    Set gop3.parm = lookup.Parameters(LTPA_GET_ABS_CAL_TO_DATE)
    gop3.Val = iToDate
    
    Set GetAbsenceCalendar = mSys.GetObjects(Array(gop, gop2, gop3))

End Function

Public Function GetAbsencesWithType(iAbsType As A2AbsType) As A2IObjSet

    Dim parm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_ABS_FOR_EMP_WITH_TYPE)
    
    Dim gop As A2GetObjParm, gop2 As A2GetObjParm
    Set gop.parm = lookup.Parameters(LTPA_ABS_FOR_EMP_WITH_TYPE_EMP)
    Set gop.Val = Me
    Set gop2.parm = lookup.Parameters(LTPA_ABS_FOR_EMP_WITH_TYPE_ABS_TYPE)
    Set gop2.Val = iAbsType
    
    Set GetAbsencesWithType = mSys.GetObjects(Array(gop, gop2))
  
End Function

'
'
'Public Const LTA_DIS_FOR_EMP As String = "GetDisForEmp"
'    Public Const LTPA_DIS_FOR_EMP_EMP As String = "emp"
'    Public Const LTPA_DIS_FOR_EMP_INC_OPEN As String = "incOpen"
'    Public Const LTPA_DIS_FOR_EMP_INC_EFFECTIVE  As String = "incEffective"
'    Public Const LTPA_DIS_FOR_EMP_INC_CANCELLED  As String = "incCancelled"
'    Public Const LTPA_DIS_FOR_EMP_INC_WAIVED  As String = "incWaived"
'    Public Const LTPA_DIS_FOR_EMP_INC_DEFERRED  As String = "incDeferred"

Public Function GetDis( _
    Optional includeOpen As Boolean = True, _
    Optional includeEffective As Boolean = True, _
    Optional includeCancelled As Boolean = True, _
    Optional includeWaived As Boolean = True, _
    Optional includeDeferred As Boolean = False) As A2IObjSet

    Dim parm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_DIS_FOR_EMP)
    
    Dim gopEmp As A2GetObjParm
    Dim gop1 As A2GetObjParm
    Dim gop2 As A2GetObjParm
    Dim gop3 As A2GetObjParm
    Dim gop4 As A2GetObjParm
    Dim gop5 As A2GetObjParm
    
    Set gopEmp.parm = lookup.Parameters(LTPA_DIS_FOR_EMP_EMP)
    Set gop1.parm = lookup.Parameters(LTPA_DIS_FOR_EMP_INC_OPEN)
    Set gop2.parm = lookup.Parameters(LTPA_DIS_FOR_EMP_INC_EFFECTIVE)
    Set gop3.parm = lookup.Parameters(LTPA_DIS_FOR_EMP_INC_CANCELLED)
    Set gop4.parm = lookup.Parameters(LTPA_DIS_FOR_EMP_INC_WAIVED)
    Set gop5.parm = lookup.Parameters(LTPA_DIS_FOR_EMP_INC_DEFERRED)
    
    Set gopEmp.Val = Me
    gop1.Val = includeOpen
    gop2.Val = includeEffective
    gop3.Val = includeCancelled
    gop4.Val = includeWaived
    gop5.Val = includeDeferred
    
    Set GetDis = mSys.GetObjects(Array(gopEmp, gop1, gop2, gop3, gop4, gop5))

End Function


Public Function GetFMLA() As A2IObjSet
Dim lookup As A2ILookupType
Dim gop As A2GetObjParm
Set lookup = mSys.LookupTypes(LTA_GET_FMLA_FOR_EMP)
Set gop.parm = lookup.Parameters(LTPA_GET_FMLA_FOR_EMP)
Set gop.Val = Me
Set GetFMLA = mSys.GetObjects(gop)
End Function

Public Function GetAbsences(iOnOrAfter As Date, _
    Optional includeProtected As Boolean = True, _
    Optional includeUnprotected As Boolean = True, _
    Optional includeWorked As Boolean = True, _
    Optional includeUnclassified As Boolean = True) As A2IObjSet

    Dim parm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_ABS_FOR_EMP)
    
    Dim gopEmp As A2GetObjParm
    Dim gopDate As A2GetObjParm
    Dim gopProtected As A2GetObjParm
    Dim gopUnprotected As A2GetObjParm
    Dim gopWorked As A2GetObjParm
    Dim gopUnclassified As A2GetObjParm
    
    Set gopEmp.parm = lookup.Parameters(LTPA_ABS_FOR_EMP_EMP)
    Set gopDate.parm = lookup.Parameters(LTPA_ABS_FOR_EMP_SINCE_DATE)
    Set gopProtected.parm = lookup.Parameters(LTPA_ABS_FOR_EMP_INC_PROTECTED)
    Set gopUnprotected.parm = lookup.Parameters(LTPA_ABS_FOR_EMP_INC_UNPROTECTED)
    Set gopWorked.parm = lookup.Parameters(LTPA_ABS_FOR_EMP_INC_WORKED)
    Set gopUnclassified.parm = lookup.Parameters(LTPA_ABS_FOR_EMP_INC_UNCLASSIFIED)
    
    Set gopEmp.Val = Me
    gopDate.Val = iOnOrAfter
    gopProtected.Val = includeProtected
    gopUnprotected.Val = includeUnprotected
    gopWorked.Val = includeWorked
    gopUnclassified.Val = includeUnclassified
    
    Set GetAbsences = mSys.GetObjects(Array(gopEmp, gopDate, gopProtected, gopUnprotected, gopWorked, gopUnclassified))

End Function

Public Function GetUnprotectedAbsences(iOnOrAfter As Date) As A2IObjSet
    Dim parm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_UNPROT_ABS_FOR_EMP)
    
    Dim gop As A2GetObjParm, gop2 As A2GetObjParm
    Set gop.parm = lookup.Parameters(LTPA_UNPROT_ABS_FOR_EMP_EMP)
    Set gop.Val = Me
    Set gop2.parm = lookup.Parameters(LTPA_UNPROT_ABS_FOR_EMP_SINCE_DATE)
    gop2.Val = iOnOrAfter
    
    Set GetUnprotectedAbsences = mSys.GetObjects(Array(gop, gop2))
End Function

Public Function GetUnprotUnwaivedAbs(iOnOrAfter As Date) As A2IObjSet
    Dim parm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_UNPROT_UNWAIVED_ABS_FOR_EMP)
    
    Dim gop As A2GetObjParm, gop2 As A2GetObjParm
    Set gop.parm = lookup.Parameters(LTPA_UNPROT_UNWAIVED_ABS_FOR_EMP_EMP)
    Set gop.Val = Me
    Set gop2.parm = lookup.Parameters(LTPA_UNPROT_UNWAIVED_ABS_FOR_EMP_SINCE_DATE)
    gop2.Val = iOnOrAfter
    
    Set GetUnprotUnwaivedAbs = mSys.GetObjects(Array(gop, gop2))
End Function

Public Function GetNotif(iOpenOnly As Boolean) As A2IObjSet

    Dim parmEmp As A2ILookupTypeParm, parmOpenOnly As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_NOTIFS_FOR_EMP)
    Set parmEmp = lookup.Parameters(LTPA_NOTIFS_FOR_EMP_EMP)
    Set parmOpenOnly = lookup.Parameters(LTPA_NOTIFS_FOR_EMP_OPEN_ONLY)
    
    Dim gopEmp As A2GetObjParm, gopOpenOnly As A2GetObjParm
    Set gopEmp.parm = parmEmp
    Set gopEmp.Val = Me
    Set gopOpenOnly.parm = parmOpenOnly
    gopOpenOnly.Val = iOpenOnly
    
    Set GetNotif = mSys.GetObjects(Array(gopEmp, gopOpenOnly))
End Function

Public Property Get LastDateWorked() As Variant
Attribute LastDateWorked.VB_Description = "Note: Can be NULL"
    LastDateWorked = mAttrs(OAA_EMP_LAST_DATE_WORKED).Value
End Property

Public Function GetExtendedInfo() As A2ExtendedEmpInfo
    
Dim lookup As A2ILookupType
Dim gop As A2GetObjParm
Set lookup = mSys.LookupTypes(LTA_GET_EXTENDED_INFO_FOR_EMP)
Set gop.parm = lookup.Parameters(LTPA_GET_EXTENDED_INFO_FOR_EMP)
Set gop.Val = Me
Set GetExtendedInfo = mSys.GetObject(mSys.ObjectTypes(OTA_EXTENDED_EMP_INFO), gop)
End Function

Public Function GetDaysWorked(iFromDate As Date, iToDate As Date) As A2IObjSet
    Dim parm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_GET_DAYS_WORKED)
    
    Dim gop As A2GetObjParm, gop2 As A2GetObjParm, gop3 As A2GetObjParm
    Set gop.parm = lookup.Parameters(LTPA_GET_DAYS_WORKED_EMP)
    Set gop.Val = Me
    Set gop2.parm = lookup.Parameters(LTPA_GET_DAYS_WORKED_FROM_DATE)
    gop2.Val = iFromDate
    Set gop3.parm = lookup.Parameters(LTPA_GET_DAYS_WORKED_TO_DATE)
    gop3.Val = iToDate
    
    Set GetDaysWorked = mSys.GetObjects(Array(gop, gop2, gop3))

End Function


' Add A2IObject methods to the default interface for convenience of users (esp VBScript)
Public Property Get Attributes() As A2IObjAttrs: Set Attributes = A2IObject_Attributes: End Property
Public Property Get Identifier() As Variant: Identifier = A2IObject_Identifier: End Property
Public Property Get AsA2IObject() As A2IObject: Set AsA2IObject = A2IObject_AsA2IObject: End Property
Public Property Get AsIDefault() As Object: Set AsIDefault = A2IObject_AsIDefault: End Property
Public Property Get AsIDispatch() As Object: Set AsIDispatch = A2IObject_AsIDispatch: End Property
Public Property Get ObjectType() As A2IObjType: Set ObjectType = A2IObject_ObjectType: End Property
Public Property Get System() As A2System: Set System = A2IObject_System: End Property

