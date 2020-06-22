VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2IObjAttr"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Property Get Value() As Variant
Attribute Value.VB_UserMemId = 0
End Property

Public Property Let Value(iVal As Variant)
End Property

Public Property Set Value(ia2Obj As A2IObject)
End Property

Public Property Get Alias() As String
End Property

Public Property Get ShortDesc() As String
End Property

Public Property Get Desc() As String
End Property

Public Property Get DataType() As a2DataType
End Property

Public Property Get ObjType() As A2IObjType
End Property

Public Property Get NewValue() As Variant
End Property

