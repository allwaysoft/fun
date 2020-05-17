VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2SQLLookupTypeParms"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements Attend2C.A2ILookupTypeParms

'Private mDS As A2SQLDataSource
Private mDSRef As A2SQLWeakRef

'Private mLookupType As A2SQLLookupType
Private mLookupTypeRef As A2SQLWeakRef

Private mWeakRef As A2SQLWeakRef

Private mCol As Collection

Private Property Get mDS() As A2SQLDataSource
    If mDSRef Is Nothing Then
        Set mDS = Nothing
    Else
        Set mDS = mDSRef.Target
    End If
End Property

Private Property Get mLookupType() As A2SQLLookupType
    If mLookupTypeRef Is Nothing Then
        Set mLookupType = Nothing
    Else
        Set mLookupType = mLookupTypeRef.Target
    End If
End Property

Friend Property Get LookupType() As A2SQLLookupType
    Set LookupType = mLookupType
End Property

Private Property Get A2ILookupTypeParms_Count() As Long
    A2ILookupTypeParms_Count = mCol.Count
End Property

Private Function A2ILookupTypeParms_Item(vIndex As Variant) As Attend2C.A2ILookupTypeParm
    Set A2ILookupTypeParms_Item = mCol.Item(vIndex)
End Function

Private Property Get A2ILookupTypeParms_NewEnum() As stdole.IUnknown
    Set A2ILookupTypeParms_NewEnum = mCol.[_NewEnum]
End Property


Friend Sub SetDS(iDS As A2SQLDataSource, _
    iLookupType As A2SQLLookupType, iMaxParmSeq As Integer, Optional iValueArray As Variant = -1)
    
    'Set mDS = iDS
    Set mDSRef = iDS.GetWeakReference
    'Set mLookupType = iLookupType
    Set mLookupTypeRef = iLookupType.GetWeakReference
    
    Set mCol = Nothing
    Set mCol = New Collection
    
    Dim i As Integer
    
    Dim oParm As A2SQLLookupTypeParm
    
    If iMaxParmSeq >= 0 Then
        For i = 0 To iMaxParmSeq
            Set oParm = New A2SQLLookupTypeParm
            oParm.SetDS mDS, Me, i
            mCol.Add oParm, oParm.Alias
        Next
    End If
    
End Sub

Private Sub Class_Initialize()
    Set mCol = New Collection
    Set mWeakRef = New A2SQLWeakRef
    mWeakRef.Initialize Me
End Sub


Private Sub Class_Terminate()
    mWeakRef.Destroy
End Sub

Friend Function GetWeakReference() As A2SQLWeakRef
    Set GetWeakReference = mWeakRef
End Function
