VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2SQLObjAttr"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
Implements A2IObjAttr

Public Property Get A2IObjAttr_Alias() As String
End Property

Public Property Get A2IObjAttr_DataType() As a2DataType
End Property

Public Property Get A2IObjAttr_Desc() As String
End Property

Public Property Get A2IObjAttr_ObjType() As A2IObjType
End Property

Public Property Get A2IObjAttr_ShortDesc() As String
End Property

Public Property Set A2IObjAttr_Value(RHS As A2IObject)
End Property

Public Property Let A2IObjAttr_Value(RHS As Variant)
End Property

Public Property Get A2IObjAttr_Value() As Variant
Attribute A2IObjAttr_Value.VB_UserMemId = 0
End Property
