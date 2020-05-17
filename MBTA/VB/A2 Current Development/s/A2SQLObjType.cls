VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2SQLObjType"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements Attend2C.A2IObjType

'Private mObjTypes As A2SQLObjTypes
Private mObjTypesRef As A2SQLWeakRef
'Private mDS As A2SQLDataSource
Private mDSRef As A2SQLWeakRef
Private mAlias As String
Private mEnum As Long
Private mDesc As String
Private mShortDesc As String
Private mIdentProcName As String
Private mIdent As Long
Private mAttrArray As Variant
Private mIdentAttr As A2SQLObjAttr
Private mInsUpdView As String

Private mWeakRef As A2SQLWeakRef

Private mObjAttrs As A2SQLObjAttrs

Private Property Get mObjTypes() As A2SQLObjTypes
    If mObjTypesRef Is Nothing Then
        Set mObjTypes = Nothing
    Else
        Set mObjTypes = mObjTypesRef.Target
    End If
End Property

Private Property Get mDS() As A2SQLDataSource
    If mDSRef Is Nothing Then
        Set mDS = Nothing
    Else
        Set mDS = mDSRef.Target
    End If
End Property

Friend Property Get Alias() As String
 Alias = A2IObjType_Alias
End Property


Private Property Get A2IObjType_Alias() As String
    A2IObjType_Alias = mAlias
End Property

Friend Property Get Attributes() As A2SQLObjAttrs
    Set Attributes = A2IObjType_Attributes
End Property

Private Property Get A2IObjType_Attributes() As Attend2C.A2IObjAttrs
    
    Set A2IObjType_Attributes = mObjAttrs
    
End Property

Friend Sub SetDS(iDS As A2SQLDataSource, iEnum As Long, _
    iDesc As String, iShortDesc As String, iIdentProcName As String, _
    iAlias As String, iIdent As Long, iObjTypes As A2SQLObjTypes, _
    Optional iAttrArray As Variant = -1)
    Dim i As Long
    Dim oAttr As A2SQLObjAttr
    Dim v As Variant
    
    Set mDSRef = iDS.GetWeakReference
    Set mObjTypesRef = iObjTypes.GetWeakReference
    
    mEnum = iEnum
    mDesc = iDesc
    mShortDesc = iShortDesc
    mIdentProcName = iIdentProcName
    mAlias = iAlias
    mIdent = iIdent
    Set mObjAttrs = New A2SQLObjAttrs
    Dim mObjAttrI As A2IObjAttrs
    
    Set mIdentAttr = Nothing
    
    If IsArray(iAttrArray) Then

        mAttrArray = iAttrArray
        mObjAttrs.SetDS mDS, True, False, Me, UBound(iAttrArray, 2)
        
        Set mObjAttrI = mObjAttrs
        For Each v In mObjAttrI
            Set oAttr = v
            If oAttr.IsIdentifier = True Then
                Set mIdentAttr = oAttr
                Exit For
            End If
        Next
    Else
        mAttrArray = -1
        mObjAttrs.SetDS mDS, True, False, Me, -1
        Set mIdentAttr = Nothing
    End If
End Sub


Private Property Get A2IObjType_EqualTo(iObjType As Attend2C.A2IObjType) As Boolean
    If Me.Alias = iObjType.Alias Then
        A2IObjType_EqualTo = True
    Else
        A2IObjType_EqualTo = False
    End If
End Property

Friend Property Get IdentAttribute() As A2SQLObjAttr
 Set IdentAttribute = A2IObjType_IdentAttribute
End Property

Private Property Get A2IObjType_IdentAttribute() As Attend2C.A2IObjAttr
    
    
    If mIdentAttr Is Nothing Then
        Err.Raise a2ErrNoIdentAttribute, "A2SQLDS.A2SQLObjType", "Object has no identifier"
    End If

    Set A2IObjType_IdentAttribute = mIdentAttr

End Property

Friend Property Get IdentProcName() As String
    IdentProcName = mIdentProcName
End Property

Private Sub Class_Initialize()
    mAlias = ""
    mEnum = 0
    mDesc = ""
    mShortDesc = ""
    mIdentProcName = ""
    mIdent = 0
    mAttrArray = -1
    Set mObjAttrs = Nothing
    Set mIdentAttr = Nothing
    Set mWeakRef = New A2SQLWeakRef
    mWeakRef.Initialize Me
End Sub

Friend Function AttrInfo(iAttrSeq As Integer, iValSeq As Integer) As Variant
    If Not IsArray(mAttrArray) Then
        Err.Raise Attend2C.a2ErrNoAttributes, "A2SQLDS.A2SQLObjType", "Object type has no attributes"
    Else
        AttrInfo = mAttrArray(iValSeq, iAttrSeq)
    End If
End Function

Friend Function objTypes() As A2SQLObjTypes
    Set objTypes = mObjTypes
End Function

Private Sub Class_Terminate()
    mWeakRef.Destroy
End Sub

Friend Function GetWeakReference() As A2SQLWeakRef
    Set GetWeakReference = mWeakRef
End Function
