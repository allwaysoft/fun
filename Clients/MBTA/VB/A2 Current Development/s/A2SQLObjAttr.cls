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

Implements Attend2C.A2IObjAttr

'Private mDS As A2SQLDataSource
'Private mWrefDS As Long
Private mWrefDS As A2SQLWeakRef

'Private mAttrs As A2SQLObjAttrs
'Private mWrefAttrs As Long
Private mWrefAttrs As A2SQLWeakRef
Private mSeq As Integer

Private mNewValue As Variant
Private mIsDirty As Boolean

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" ( _
        pDest As Any, pSrc As Any, ByVal ByteLen As Long)
        
Private Property Get mDS() As A2SQLDataSource
    Set mDS = mWrefDS.Target
End Property


Private Property Get mAttrs() As A2SQLObjAttrs
    Set mAttrs = mWrefAttrs.Target
End Property



Friend Property Get Alias() As String
    Alias = A2IObjAttr_Alias()
End Property

Private Property Get A2IObjAttr_Alias() As String
   A2IObjAttr_Alias = CStr(mAttrs.ObjType.AttrInfo(mSeq, FLD_ATTR_ALIAS))
End Property

Private Property Get A2IObjAttr_DataType() As Attend2C.a2DataType
    A2IObjAttr_DataType = mAttrs.ObjType.AttrInfo(mSeq, FLD_ATTR_DATA_TYPE)
End Property

Private Property Get A2IObjAttr_Desc() As String
    A2IObjAttr_Desc = CStr(mAttrs.ObjType.AttrInfo(mSeq, FLD_ATTR_LONG_NAME))
End Property


Private Property Get A2IObjAttr_NewValue() As Variant
    If mIsDirty Then
        If IsObject(mNewValue) Then
            Set A2IObjAttr_NewValue = mNewValue
        Else
            A2IObjAttr_NewValue = mNewValue
        End If
    Else
        Err.Raise a2ErrValueNotAltered, "A2SQLDS.A2SQLObjAttr", "Attribute has not been altered; use the Value property to get the attribute's current value"
    End If
End Property

Private Property Get A2IObjAttr_ObjType() As Attend2C.A2IObjType
    Dim refObjType As A2SQLObjType
    Dim refObjTypeId As Long
    
    refObjTypeId = mAttrs.ObjType.AttrInfo(mSeq, FLD_ATTR_OBJ_REF_OBJ_TYPE_ID)
    Set refObjType = mAttrs.ObjType.objTypes.ObjTypeById(refObjTypeId)

    Set A2IObjAttr_ObjType = refObjType

End Property

Private Property Get A2IObjAttr_ShortDesc() As String
    A2IObjAttr_ShortDesc = CStr(mAttrs.ObjType.AttrInfo(mSeq, FLD_ATTR_SHORT_NAME))
End Property

Private Property Set A2IObjAttr_Value(iNewValue As Attend2C.A2IObject)
    If mAttrs.EditMode = True Then
        mIsDirty = True
        Set mNewValue = iNewValue
    Else
        Err.Raise a2ErrNotEditMode, "A2SQLDS.A2SQLObjAttr", "Object's values cannot be changed unless attribute is in edit mode"
    End If
    
End Property

Private Property Let A2IObjAttr_Value(iNewValue As Variant)
    If mAttrs.EditMode = True Then
        mIsDirty = True
        mNewValue = iNewValue
    Else
        Err.Raise a2ErrNotEditMode, "A2SQLDS.A2SQLObjAttr", "Object's values cannot be changed unless attribute is in edit mode"
    End If
End Property

Private Property Get A2IObjAttr_Value() As Variant
    Dim objIdent As Long
    Dim vCheck As Variant, vArr() As Variant, v As Variant  ' Values
    Dim refObj As Attend2C.A2IObject
    Dim refObjType As A2SQLObjType
    Dim refObjTypeId As Long
    
    vCheck = mAttrs.Values
    If IsArray(vCheck) Then
        vArr = vCheck
        v = vArr(mSeq, 0)
    Else
        Err.Raise Attend2C.a2ErrNoAttributes, "A2SQLDS.A2SQLObjAttr", "Object has no attributes"
    End If
    
    If A2IObjAttr_DataType = Attend2C.a2DataTypeObjRef Then
        refObjTypeId = mAttrs.ObjType.AttrInfo(mSeq, FLD_ATTR_OBJ_REF_OBJ_TYPE_ID)
        Set refObjType = mAttrs.ObjType.objTypes.ObjTypeById(refObjTypeId)
        
        If mAttrs.ObjType.AttrInfo(mSeq, FLD_ATTR_IS_NULLABLE) = True Then
            If IsNull(v) Then
                Set A2IObjAttr_Value = Nothing
            Else
                objIdent = CLng(v)
                Set refObj = mDS.GetObjFromIdent(refObjType, objIdent)
            End If
        Else
            objIdent = CLng(v)
            Set refObj = mDS.GetObjFromIdent(refObjType, objIdent)
        End If
        
        Set A2IObjAttr_Value = refObj
    Else
        A2IObjAttr_Value = v
    End If
End Property

Friend Sub SetDS(iDS As A2SQLDataSource, iAttrs As A2SQLObjAttrs, _
    iSeq As Integer)
    'Set mDS = iDS
    Set mWrefDS = iDS.GetWeakReference
    'Set mAttrs = iAttrs
    Set mWrefAttrs = iAttrs.GetWeakReference
    mSeq = iSeq
End Sub

Friend Property Get IsIdentifier() As Boolean
    IsIdentifier = mAttrs.ObjType.AttrInfo(mSeq, FLD_ATTR_IS_IDENTITY)
End Property

Friend Property Get IsGUID() As Boolean
    IsGUID = mAttrs.ObjType.AttrInfo(mSeq, FLD_ATTR_IS_GUID)
End Property

Private Sub Class_Initialize()
    Set mNewValue = Nothing
    'Debug.Print " A2SQLObjAttr Init " & cntCreated
    'cntCreated = cntCreated + 1
End Sub

Friend Property Get Sequence() As Integer
    Sequence = mAttrs.ObjType.AttrInfo(mSeq, FLD_ATTR_SEQUENCE)
End Property

Friend Sub Revert()
    mIsDirty = False
    mNewValue = Null
End Sub
