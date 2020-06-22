VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2AbsGrp"
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
    Dim iDef As A2AbsGrp
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
    A2IObject_Identifier = Me.Attributes(Me.Attributes.ObjectType.IdentAttribute.Alias).Value
End Property

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






Public Property Get Absences() As A2IObjSet
    Dim parm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_ABS_IN_ABS_GRP)
    Set parm = lookup.Parameters(LTPA_ABS_IN_ABS_GRP)
    
    Dim gop As A2GetObjParm
    Set gop.parm = parm
    Set gop.Val = Me
    
    Set Absences = mSys.GetObjects(gop)
End Property

Public Property Get ExtAbsences() As A2IObjSet
    Dim parm As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_GET_EXT_ABS_IN_ABS_GRP)
    Set parm = lookup.Parameters(LTPA_GET_EXT_ABS_IN_ABS_GRP)
    
    Dim gop As A2GetObjParm
    Set gop.parm = parm
    Set gop.Val = Me
    
    Set ExtAbsences = mSys.GetObjects(gop)
End Property



Public Property Get Creator() As A2User
    Set Creator = mAttrs(OAA_ABS_CREATOR).Value
End Property


Public Sub AddAbsence(iAbs As A2Abs)
    Dim o As Object
    Dim parm1 As A2ILookupTypeParm, parm2 As A2ILookupTypeParm
    Dim lookup As A2ILookupType
    
    Set lookup = mSys.LookupTypes(LTA_ADD_ABS_TO_GRP)
    Set parm1 = lookup.Parameters(LTPA_ADD_ABS_TO_GRP_ABS)
    Set parm2 = lookup.Parameters(LTPA_ADD_ABS_TO_GRP_GRP)
    
    Dim gop1 As A2GetObjParm, gop2 As A2GetObjParm
    Set gop1.parm = parm1
    Set gop1.Val = iAbs
    Set gop2.parm = parm2
    Set gop2.Val = Me
    
    mSys.GetObjects Array(gop1, gop2)
    
End Sub


'Public Function GetContainingDis(iOpenOrEffOnly As Boolean) As A2IObjSet
'End Function

'Public Function GetContainingNotif(iOpenOnly As Boolean) As A2IObjSet
'End Function


' Add A2IObject methods to the default interface for convenience of users (esp VBScript)
Public Property Get Attributes() As A2IObjAttrs: Set Attributes = A2IObject_Attributes: End Property
Public Property Get Identifier() As Variant: Identifier = A2IObject_Identifier: End Property
Public Property Get AsA2IObject() As A2IObject: Set AsA2IObject = A2IObject_AsA2IObject: End Property
Public Property Get AsIDefault() As Object: Set AsIDefault = A2IObject_AsIDefault: End Property
Public Property Get AsIDispatch() As Object: Set AsIDispatch = A2IObject_AsIDispatch: End Property
Public Property Get ObjectType() As A2IObjType: Set ObjectType = A2IObject_ObjectType: End Property
Public Property Get System() As A2System: Set System = A2IObject_System: End Property


