VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2ISysLiaison"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Property Get ObjectTypes() As A2IObjTypes
End Property

Public Property Get LookupTypes() As A2ILookupTypes
End Property

Public Function GetObject(iObjType As A2IObjType, iParms As Variant) As A2IObject
End Function

Public Function GetObjects(iParms As Variant) As A2IObjSet
End Function

Public Sub StartTransaction()
End Sub

Public Sub CommitTransaction()
End Sub

Public Sub RollbackTransaction()
End Sub

Public Sub SetEditMode(iAttrs As A2IObjAttrs, allowEdits As Boolean)
End Sub

Public Sub SaveAttrs(iAttrs As A2IObjAttrs)
End Sub

Public Function CreateObject(iObjType As A2IObjType) As A2IObject
End Function
