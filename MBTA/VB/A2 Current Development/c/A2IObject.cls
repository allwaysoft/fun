VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2IObject"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Property Get Attributes() As A2IObjAttrs
End Property

Public Property Set Attributes(iAttrs As A2IObjAttrs)
End Property

Public Property Get System() As A2System
End Property

Public Property Set System(iSys As A2System)
End Property

Public Property Get Identifier() As Variant
End Property

Public Property Get ObjectType() As A2IObjType
End Property

Public Property Get AsIDispatch() As Object
Attribute AsIDispatch.VB_Description = "Get this A2IObject with its IDispatch interface presented"
Attribute AsIDispatch.VB_MemberFlags = "40"
End Property

Public Property Get AsIDefault() As Object
End Property

Public Property Get AsA2IObject() As A2IObject
Attribute AsA2IObject.VB_Description = "Get this object with its A2IObject interface presented"
Attribute AsA2IObject.VB_MemberFlags = "40"
End Property

Public Function IsEqualTo(iObj As A2IObject) As Boolean
End Function
