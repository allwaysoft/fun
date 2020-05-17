VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2ExtAbs"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements A2IObject
Private mAttrs As A2IObjAttrs
Private mSys As A2System

Private Property Get A2IObject_AsIDefault() As Object
    Dim iDef As A2ExtAbs
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

Public Property Get OnDate() As Date
    OnDate = mAttrs(OAA_EXTABS_DATE).Value
End Property

Public Property Get HTMLDesc() As String
    HTMLDesc = mAttrs(OAA_EXTABS_H_T_M_L_DESC).Value
End Property

Public Property Get Desc() As String
    Desc = mAttrs(OAA_EXTABS_DESC).Value
End Property

Public Property Get BadgeNum() As Long
    BadgeNum = mAttrs(OAA_EXTABS_BADGE_NUM).Value
End Property

Public Property Get EmpName() As String
    EmpName = mAttrs(OAA_EXTABS_EMP_NAME).Value
End Property

Public Property Get AreaDesc() As String
    AreaDesc = mAttrs(OAA_EXTABS_AREA_DESC).Value
End Property

Public Property Get AreaGrpDesc() As String
    AreaGrpDesc = mAttrs(OAA_EXTABS_AREA_GRP_DESC).Value
End Property

Public Property Get AreaNum() As Long
    AreaNum = mAttrs(OAA_EXTABS_AREA_NUM).Value
End Property

Public Property Get Absence() As A2Abs
    Set Absence = mAttrs(OAA_EXTABS_ABS).Value
End Property

' Add A2IObject methods to the default interface for convenience of users (esp VBScript)
Public Property Get Attributes() As A2IObjAttrs: Set Attributes = A2IObject_Attributes: End Property
Public Property Get Identifier() As Variant: Identifier = A2IObject_Identifier: End Property
Public Property Get AsA2IObject() As A2IObject: Set AsA2IObject = A2IObject_AsA2IObject: End Property
Public Property Get AsIDefault() As Object: Set AsIDefault = A2IObject_AsIDefault: End Property
Public Property Get AsIDispatch() As Object: Set AsIDispatch = A2IObject_AsIDispatch: End Property
Public Property Get ObjectType() As A2IObjType: Set ObjectType = A2IObject_ObjectType: End Property
Public Property Get System() As A2System: Set System = A2IObject_System: End Property
