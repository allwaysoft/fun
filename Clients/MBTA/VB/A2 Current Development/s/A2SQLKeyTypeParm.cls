VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2SQLLookupTypeParm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements Attend2C.A2ILookupTypeParm

'Private mDS As A2SQLDataSource
Private mDSRef As A2SQLWeakRef

'Private mParms As A2SQLLookupTypeParms
Private mParmsRef As A2SQLWeakRef

Private mSeq As Integer

Private Property Get mDS() As A2SQLDataSource
    If mDSRef Is Nothing Then
        Set mDS = Nothing
    Else
        Set mDS = mDSRef.Target
    End If
End Property

Private Property Get mParms() As A2SQLLookupTypeParms
    If mParmsRef Is Nothing Then
        Set mParms = Nothing
    Else
        Set mParms = mParmsRef.Target
    End If
End Property


Friend Property Get Alias() As String
    Alias = A2ILookupTypeParm_Alias()
End Property

Friend Sub SetDS(iDS As A2SQLDataSource, iParms As A2SQLLookupTypeParms, _
    iSeq As Integer)
    Set mDSRef = iDS.GetWeakReference
    Set mParmsRef = iParms.GetWeakReference
    mSeq = iSeq
End Sub

Private Property Get A2ILookupTypeParm_Alias() As String
    A2ILookupTypeParm_Alias = mParms.LookupType.ParmInfo(mSeq, FLD_LOOKUP_PARM_ALIAS)
End Property

Private Property Get A2ILookupTypeParm_DataType() As Attend2C.a2DataType
    A2ILookupTypeParm_DataType = mParms.LookupType.ParmInfo(mSeq, FLD_LOOKUP_PARM_DATATYPE)
End Property

Friend Property Get DataType() As Attend2C.a2DataType
    DataType = A2ILookupTypeParm_DataType
End Property

Private Property Get A2ILookupTypeParm_Desc() As String
    A2ILookupTypeParm_Desc = mParms.LookupType.ParmInfo(mSeq, FLD_LOOKUP_PARM_DATATYPE)
End Property

Private Property Get A2ILookupTypeParm_LookupType() As Attend2C.A2ILookupType
    Set A2ILookupTypeParm_LookupType = mParms.LookupType
End Property

Private Property Get A2ILookupTypeParm_ObjectType() As Attend2C.A2IObjType
    Dim refObjType As A2SQLObjType
    Dim refObjTypeId As Long
    
    refObjTypeId = mParms.LookupType.ParmInfo(mSeq, FLD_LOOKUP_PARM_REFOBJTYPEID)
    Set refObjType = mDS.ObjectTypes.ObjTypeById(refObjTypeId)

    Set A2ILookupTypeParm_ObjectType = refObjType
End Property

Friend Property Get ParameterName() As String
    ParameterName = mParms.LookupType.ParmInfo(mSeq, FLD_LOOKUP_PARM_PARAMNAME)
End Property
