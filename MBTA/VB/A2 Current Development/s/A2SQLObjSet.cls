VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2SQLObjSet"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements Attend2C.A2IObjSet
Private mCol As Collection

Private Property Get A2IObjSet_AsA2IObjSet() As Attend2C.A2IObjSet
    Dim o As A2IObjSet
    Set o = Me
    Set A2IObjSet_AsA2IObjSet = o
    
End Property

Private Property Get A2IObjSet_AsIDefault() As Object
    Dim o As A2SQLObjSet
    Set o = Me
    Set A2IObjSet_AsIDefault = o
End Property

Private Property Get A2IObjSet_AsIDispatch() As Object
    Dim o As Object
    Set o = Me
    Set A2IObjSet_AsIDispatch = o
End Property

Private Property Get A2IObjSet_Count() As Long
    A2IObjSet_Count = mCol.Count
End Property

Private Function A2IObjSet_Item(vIndex As Variant) As Attend2C.A2IObject
    Set A2IObjSet_Item = mCol.Item(vIndex)
End Function

Private Property Get A2IObjSet_NewEnum() As stdole.IUnknown
    Set A2IObjSet_NewEnum = mCol.[_NewEnum]
End Property

Friend Sub SetColl(iCol As Collection)
    Set mCol = iCol
End Sub

Private Sub Class_Initialize()
    Set mCol = New Collection
End Sub


Private Function A2IObjSet_IsEqualTo(iObjSet As Attend2C.A2IObjSet) As Boolean
    Dim vMine As Variant, vTheirs As Variant
    Dim oMine As A2IObject, oTheirs As A2IObject
    Dim MeX As Attend2C.A2IObjSet
    Set MeX = Me
    Dim localBool As Boolean
    
    If Not MeX.Count = iObjSet.Count Then
        A2IObjSet_IsEqualTo = False
        Exit Function
    Else
        For Each vMine In MeX
            Set oMine = vMine
            localBool = False
            
            For Each vTheirs In iObjSet
                Set oTheirs = vTheirs
                If oTheirs.IsEqualTo(oMine) Then
                    localBool = True
                    Exit For
                End If
            Next
            
            If localBool = False Then
                A2IObjSet_IsEqualTo = False
                Exit Function
            End If
        Next
    End If
    
    A2IObjSet_IsEqualTo = True
End Function

