VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2ILookupType"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Property Get ObjectType() As A2IObjType
End Property

Public Property Get Alias() As String
End Property

Public Property Get Desc() As String
End Property

Public Property Get EqualTo(iLookupType As A2ILookupType) As Boolean
End Property

Public Property Get Parameters() As A2ILookupTypeParms
End Property

Public Property Get HasReturnValue() As Boolean
End Property

Public Property Get IsUnique() As Boolean
End Property

