VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2Notif"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements A2IObject
Private mAttrs As A2IObjAttrs
Private mSys As A2System


Private Property Get A2IObject_AsIDefault() As Object
    Dim iDef As A2Notif
    Set iDef = Me
    Set A2IObject_AsIDefault = iDef

End Property

Private Property Set A2IObject_Attributes(RHS As A2IObjAttrs)
    If mAttrs Is Nothing Then
        Set mAttrs = RHS
    End If
End Property

Private Property Get A2IObject_AsA2IObject() As A2IObject
    Set A2IObject_AsA2IObject = Me
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

Public Property Get DateCreated() As Date
    DateCreated = mAttrs(OAA_NOTIF_DATE_CREATED).Value
End Property

Public Property Get DateTriggered() As Date
Attribute DateTriggered.VB_Description = "Date of last absence in the group"
    Dim v As Variant
    v = mAttrs(OAA_NOTIF_DATE_TRIGGERED).Value
    If IsNull(v) Then
        Err.Raise a2ErrRequestedValueNull, "Attend2A.A2Notif", "Notification has no absences, so has no trigger date"
    Else
        DateTriggered = v
    End If

' old version:
'   Dim os As A2IObjSet, v As Variant, oAbs As A2Abs
'   Set os = Me.Absences
'   If os.Count = 0 Then
'       Err.Raise a2ErrRequestedValueNull, "Attend2C.A2Notif", "Notification has no absences, so has no trigger date"
'   End If
    
'   Set oAbs = os(os.Count).AsIDefault
'   DateTriggered = oAbs.OnDate
End Property

Public Property Get NotifType() As A2NotifType
    Set NotifType = mAttrs(OAA_NOTIF_TYPE).Value
End Property

Public Property Get Rule() As A2Rule
    Set Rule = mAttrs(OAA_NOTIF_RULE).Value
End Property

Public Property Get Employee() As A2Employee
    Set Employee = mAttrs(OAA_NOTIF_EMP).Value
End Property

Public Function GetExtendedInfo() As A2ExtNotif

    Dim parm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_GET_EXT_INFO_FOR_NOTIF)
    Set parm = lookup.Parameters(LTPA_GET_EXT_INFO_FOR_NOTIF)
    
    Dim gop As A2GetObjParm
    Set gop.parm = parm
    Set gop.Val = Me
    
    Set GetExtendedInfo = mSys.GetObject(mSys.ObjectTypes(OTA_EXT_NOTIF), gop)

End Function

Public Property Get ExtAbsences() As A2IObjSet
    Dim oAbsGrp As A2AbsGrp
    Set oAbsGrp = mAttrs(OAA_NOTIF_ABS_GRP).Value
    Set ExtAbsences = oAbsGrp.ExtAbsences
End Property

Public Property Get Absences() As A2IObjSet
Attribute Absences.VB_Description = "Absences in this notification, in chronological order"
    Dim oAbsGrp As A2AbsGrp
    Set oAbsGrp = mAttrs(OAA_NOTIF_ABS_GRP).Value
    Set Absences = oAbsGrp.Absences
'
'    Dim parm As A2ILookupTypeParm
'    Dim lookup As A2ILookupType
'
'    Set lookup = mSys.LookupTypes(LTA_ABS_IN_NOTIF)
'    Set parm = lookup.Parameters(LTPA_ABS_IN_NOTIF_NOTIF)
'
'    Dim gop As A2GetObjParm
'    Set gop.parm = parm
'    Set gop.Val = Me
'
'    Set Absences = mSys.GetObjects(gop)
End Property


Public Function GetRelatedDis() As A2IObjSet

    Dim parm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_GET_DIS_RELATED_TO_NOTIF)
    Set parm = lookup.Parameters(LTPA_GET_DIS_RELATED_TO_NOTIF)
    
    Dim gop As A2GetObjParm
    Set gop.parm = parm
    Set gop.Val = Me
    
    Set GetRelatedDis = mSys.GetObjects(gop)
End Function

Public Sub Cancel()

    Dim parm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_CANCEL_NOTIF)
    Set parm = lookup.Parameters(LTPA_CANCEL_NOTIF)
    
    Dim gop As A2GetObjParm
    Set gop.parm = parm
    Set gop.Val = Me
    
    mSys.GetObjects gop

    Me.Attributes.Refresh
End Sub

Public Property Get IsCancelled() As Boolean
    IsCancelled = mAttrs(OAA_NOTIF_IS_CANCELLED).Value
End Property

Public Property Get TriggerNote() As String
    TriggerNote = mAttrs(OAA_NOTIF_TRIGGER_NOTE).Value
End Property

' Add A2IObject methods to the default interface for convenience of users (esp VBScript)
Public Property Get Attributes() As A2IObjAttrs: Set Attributes = A2IObject_Attributes: End Property
Public Property Get Identifier() As Variant: Identifier = A2IObject_Identifier: End Property
Public Property Get AsA2IObject() As A2IObject: Set AsA2IObject = A2IObject_AsA2IObject: End Property
Public Property Get AsIDefault() As Object: Set AsIDefault = A2IObject_AsIDefault: End Property
Public Property Get AsIDispatch() As Object: Set AsIDispatch = A2IObject_AsIDispatch: End Property
Public Property Get ObjectType() As A2IObjType: Set ObjectType = A2IObject_ObjectType: End Property
Public Property Get System() As A2System: Set System = A2IObject_System: End Property

