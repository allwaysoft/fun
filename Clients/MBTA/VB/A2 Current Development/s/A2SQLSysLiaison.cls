VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2SQLSysLiaison"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
Implements Attend2C.A2ISysLiaison

'Private mDS As A2SQLDataSource
Private mDSRef As A2SQLWeakRef

Private Property Get mDS() As A2SQLDataSource
    If mDSRef Is Nothing Then
        Set mDS = Nothing
    Else
        Set mDS = mDSRef.Target
    End If
End Property

Private Sub A2ISysLiaison_CommitTransaction()
    mDS.Conn.CommitTrans
End Sub

Private Function A2ISysLiaison_CreateObject(iObjType As Attend2C.A2IObjType) As Attend2C.A2IObject
    Set A2ISysLiaison_CreateObject = mDS.CreateObject(iObjType)
End Function

Private Function A2ISysLiaison_GetObject(iObjType As Attend2C.A2IObjType, iParms As Variant) As Attend2C.A2IObject
    Set A2ISysLiaison_GetObject = mDS.GetObject(iObjType, iParms)
End Function

Private Function A2ISysLiaison_GetObjects(iParms As Variant) As Attend2C.A2IObjSet
    Set A2ISysLiaison_GetObjects = mDS.GetObjects(iParms)
End Function

Private Property Get A2ISysLiaison_LookupTypes() As Attend2C.A2ILookupTypes
    Set A2ISysLiaison_LookupTypes = mDS.LookupTypes
End Property

Private Property Get A2ISysLiaison_ObjectTypes() As Attend2C.A2IObjTypes
    Set A2ISysLiaison_ObjectTypes = mDS.ObjectTypes
End Property

Friend Sub SetDS(iDS As A2SQLDataSource)
    Set mDSRef = iDS.GetWeakReference
End Sub

Private Sub A2ISysLiaison_RollbackTransaction()
    mDS.Conn.RollbackTrans
End Sub

Private Sub A2ISysLiaison_SaveAttrs(iAttrs As Attend2C.A2IObjAttrs)
    Dim sAttrs As A2SQLObjAttrs
    Set sAttrs = iAttrs
    sAttrs.Save
End Sub

Private Sub A2ISysLiaison_SetEditMode(iAttrs As Attend2C.A2IObjAttrs, allowEdits As Boolean)
    Dim sAttrs As A2SQLObjAttrs
    Set sAttrs = iAttrs
    sAttrs.EditMode = allowEdits
End Sub

Private Sub A2ISysLiaison_StartTransaction()
    mDS.Conn.BeginTrans
End Sub
