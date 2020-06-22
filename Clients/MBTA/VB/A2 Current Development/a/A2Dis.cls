VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2Dis"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements A2IObject
Private mAttrs As A2IObjAttrs
Private mSys As A2System

Private Property Get A2IObject_AsIDefault() As Object
    Dim iDef As A2Dis
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



Private Property Set A2IObject_Attributes(RHS As A2IObjAttrs)
    If mAttrs Is Nothing Then
        Set mAttrs = RHS
    End If
End Property

Private Property Get A2IObject_AsA2IObject() As A2IObject
    Set A2IObject_AsA2IObject = Me
End Property
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

Public Property Get InitiatedOn() As Date
    InitiatedOn = mAttrs(OAA_DIS_INIT_DATE).Value
End Property

Public Property Get TriggeredOn() As Date
    If IsNull(mAttrs(OAA_DIS_DATE_TRIGGERED).Value) Then
        Err.Raise a2ErrRequestedValueNull, "Attend2A.A2Dis", "Discipline instance has no absences, so has no trigger date"
    Else
        TriggeredOn = mAttrs(OAA_DIS_DATE_TRIGGERED).Value
 
    End If

' Old version:
'    Dim os As A2IObjSet, v As Variant, oAbs As A2Abs
'   Set os = Me.Absences
'   If os.Count = 0 Then
'       Err.Raise a2ErrRequestedValueNull, "Attend2C.A2Dis", "Discipline instance has no absences, so has no trigger date"
'   End If
    
'   Set oAbs = os(os.Count).AsIDefault
'   TriggeredOn = oAbs.OnDate
End Property

Public Property Get DisType() As A2DisType
Attribute DisType.VB_Description = "Note: CAN BE NOTHING/NULL"
    Set DisType = mAttrs(OAA_DIS_DIS_TYPE).Value
End Property

Public Property Get Employee() As A2Employee
    Set Employee = mAttrs(OAA_DIS_EMP).Value
End Property

Public Property Get AreaAtInit() As A2Area
    Set AreaAtInit = mAttrs(OAA_DIS_AREA_AT_INIT).Value
End Property

Public Function AddAction(iActType As A2DisActType, iEffDate As Date, iNotes As String) As A2DisAct
    Dim s As String
    s = mSys.Defang(iNotes)
    If Len(s) > 254 Then
        Err.Raise a2ErrStringTooLong, "Attend2A.A2Dis", "Notes are longer than the maximum allowed -- 254 characters."
    End If
    
    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes(LTA_ADD_ACT_TO_DIS)
    
    Dim gopDis As A2GetObjParm, gopType As A2GetObjParm
    Dim gopDate As A2GetObjParm, gopNotes As A2GetObjParm
    
    Set gopDis.parm = lookup.Parameters(LTPA_ADD_ACT_TO_DIS_DIS)
    Set gopDis.Val = Me
    Set gopType.parm = lookup.Parameters(LTPA_ADD_ACT_TO_DIS_ACT_TYPE)
    Set gopType.Val = iActType
    Set gopDate.parm = lookup.Parameters(LTPA_ADD_ACT_TO_DIS_EFF_DATE)
    gopDate.Val = iEffDate
    Set gopNotes.parm = lookup.Parameters(LTPA_ADD_ACT_TO_DIS_NOTES)
    gopNotes.Val = s
    
    Dim oAct As A2DisAct
    Set oAct = mSys.GetObject(mSys.ObjectTypes(OTA_DIS_ACT), Array(gopDis, gopType, gopDate, gopNotes))
    Set AddAction = oAct
    Me.Attributes.Refresh
    mSys.Publish a2PubEvTypeDisAltered, Me
End Function

Public Property Get Actions() As A2IObjSet
    
    Dim parm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_DIS_ACT_FOR_DIS)
    Set parm = lookup.Parameters(LTPA_DIS_ACT_FOR_DIS)
    
    Dim gop As A2GetObjParm
    Set gop.parm = parm
    Set gop.Val = Me
    
    Set Actions = mSys.GetObjects(gop)
End Property

Public Property Get Absences() As A2IObjSet
    Dim oAbsGrp As A2AbsGrp
    Set oAbsGrp = mAttrs(OAA_DIS_ABS_GRP).Value
    Set Absences = oAbsGrp.Absences
End Property

Public Property Get ExtAbsences() As A2IObjSet
    Dim oAbsGrp As A2AbsGrp
    Set oAbsGrp = mAttrs(OAA_DIS_ABS_GRP).Value
    Set ExtAbsences = oAbsGrp.ExtAbsences
End Property

Public Property Get Creator() As A2User
    Set Creator = mAttrs(OAA_DIS_INIT_USER).Value
End Property

Public Property Get Rule() As A2Rule
    Set Rule = mAttrs(OAA_DIS_RULE).Value
End Property

Public Property Get Status() As a2DisStatus
    Status = mAttrs(OAA_DIS_STATUS).Value
End Property

Public Property Get EffectiveDate() As Variant
    EffectiveDate = mAttrs(OAA_DIS_EFF_DATE).Value
End Property

Public Property Get TriggerNote() As String
    TriggerNote = mAttrs(OAA_DIS_TRIGGER_NOTE).Value
End Property


' Add A2IObject methods to the default interface for convenience of users (esp VBScript)
Public Property Get Attributes() As A2IObjAttrs: Set Attributes = A2IObject_Attributes: End Property
Public Property Get Identifier() As Variant: Identifier = A2IObject_Identifier: End Property
Public Property Get AsA2IObject() As A2IObject: Set AsA2IObject = A2IObject_AsA2IObject: End Property
Public Property Get AsIDefault() As Object: Set AsIDefault = A2IObject_AsIDefault: End Property
Public Property Get AsIDispatch() As Object: Set AsIDispatch = A2IObject_AsIDispatch: End Property
Public Property Get ObjectType() As A2IObjType: Set ObjectType = A2IObject_ObjectType: End Property
Public Property Get System() As A2System: Set System = A2IObject_System: End Property

