VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2SQLLookupType"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements Attend2C.A2ILookupType

'Private mDS As A2SQLDataSource
Private mDSRef As A2SQLWeakRef

Private mIdent As Long
Private mAlias As String
Private mDesc As String
Private mCommandText As String
'Private mObjType As A2SQLObjType
Private mObjTypeRef As A2SQLWeakRef

Private mParms As A2SQLLookupTypeParms
Private mParmArray As Variant
Private mReturnsIdent As Boolean
Private mNoReturnVal As Boolean

Private mWeakRef As A2SQLWeakRef

Private Property Get mObjType() As A2SQLObjType
    If mObjTypeRef Is Nothing Then
        Set mObjType = Nothing
    Else
        Set mObjType = mObjTypeRef.Target
    End If
End Property

Private Property Get mDS() As A2SQLDataSource
    If mDSRef Is Nothing Then
        Set mDS = Nothing
    Else
        Set mDS = mDSRef.Target
    End If
End Property

Friend Sub SetDS(iDS As A2SQLDataSource, iAlias As String, _
    iDesc As String, iCommandText As String, iObjType As A2SQLObjType, _
    iReturnsIdent As Boolean, iNoReturnVal As Boolean, _
    iIdent As Long, Optional iParmArray As Variant = -1)

    'Set mDS = iDS
    Set mDSRef = iDS.GetWeakReference
    
    mDesc = iDesc
    mCommandText = iCommandText
    mAlias = iAlias
    mIdent = iIdent
    mReturnsIdent = iReturnsIdent
    mNoReturnVal = iNoReturnVal
    'Set mObjType = iObjType
    Set mObjTypeRef = iObjType.GetWeakReference
    
    Set mParms = New A2SQLLookupTypeParms
    
    If IsArray(iParmArray) Then
        mParmArray = iParmArray
        mParms.SetDS mDS, Me, UBound(iParmArray, 2)
    Else
        mParmArray = -1
        mParms.SetDS mDS, Me, -1
    End If

End Sub

Friend Property Get Alias() As String
    Alias = A2ILookupType_Alias
End Property

Private Property Get A2ILookupType_Alias() As String
    A2ILookupType_Alias = mAlias
End Property

Private Property Get A2ILookupType_Desc() As String
    A2ILookupType_Desc = mDesc
End Property

Private Property Get A2ILookupType_EqualTo(iLookupType As Attend2C.A2ILookupType) As Boolean
    If mAlias = iLookupType.Alias Then
        A2ILookupType_EqualTo = True
    Else
        A2ILookupType_EqualTo = False
    End If
End Property

Friend Property Get ReturnsIdent() As Boolean
    ReturnsIdent = mReturnsIdent
End Property

Private Property Get A2ILookupType_HasReturnValue() As Boolean
    If mNoReturnVal = True Then
        A2ILookupType_HasReturnValue = False
    Else
        A2ILookupType_HasReturnValue = True
    End If
End Property

Private Property Get A2ILookupType_IsUnique() As Boolean
    A2ILookupType_IsUnique = False
End Property

Private Property Get A2ILookupType_ObjectType() As Attend2C.A2IObjType
   Set A2ILookupType_ObjectType = mObjType
End Property

Friend Property Get CommandText() As String
    CommandText = mCommandText
End Property

Friend Function ParmInfo(iParmSeq As Integer, iValSeq As Integer) As Variant
    If Not IsArray(mParmArray) Then
        Err.Raise Attend2C.a2ErrNoAttributes, "A2SQLDS.A2SQLLookupType", "Lookup type has no parameters"
    Else
        ParmInfo = mParmArray(iValSeq, iParmSeq)
    End If
End Function


Private Property Get A2ILookupType_Parameters() As Attend2C.A2ILookupTypeParms
    Set A2ILookupType_Parameters = mParms
End Property

Private Sub Class_Initialize()
    Set mWeakRef = New A2SQLWeakRef
    mWeakRef.Initialize Me
End Sub

Private Sub Class_Terminate()
    mWeakRef.Destroy
End Sub

Friend Function GetWeakReference() As A2SQLWeakRef
    Set GetWeakReference = mWeakRef
End Function
