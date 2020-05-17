VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2IObjType"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Property Get Attributes() As A2IObjAttrs
End Property

Public Property Get Alias() As String
End Property

Public Property Get IdentAttribute() As A2IObjAttr
End Property

Public Property Get EqualTo(iObjType As A2IObjType) As Boolean
End Property
