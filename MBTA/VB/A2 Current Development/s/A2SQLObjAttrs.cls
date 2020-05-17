VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2SQLObjAttrs"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements Attend2C.A2IObjAttrs
Private mMetaDataMode As Boolean
'Private mWrefDS As Long
'Private mDS As A2SQLDataSource
Private mWrefDS As A2SQLWeakRef

Private mTime1 As Double
'Private mObjType As A2SQLObjType
Private mObjTypeRef As A2SQLWeakRef

Private mValues As Variant
Private mIdent As Long
Private mCol As Collection

Private mEditMode As Boolean
Private mIsNew As Boolean

Private mWeakRef As A2SQLWeakRef

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" ( _
        pDest As Any, pSrc As Any, ByVal ByteLen As Long)

Private Property Get mObjType() As A2SQLObjType
    If mObjTypeRef Is Nothing Then
        Set mObjType = Nothing
    Else
        Set mObjType = mObjTypeRef.Target
    End If
End Property

Private Property Get mDS() As A2SQLDataSource
    Set mDS = mWrefDS.Target
End Property

Friend Property Get IdentAttribute() As A2SQLObjAttr
    Dim v As Variant, oa As A2SQLObjAttr
    For Each v In Me
        Set oa = v
        If oa.IsIdentifier = True Then
            Set IdentAttribute = oa
            Exit Function
        End If
    Next
    
    Err.Raise a2ErrNoIdentAttribute, "A2SQLDS.A2SQLObjAttrs", "Object type has no identifier attribute"
End Property

Friend Property Get Count() As Long
Count = A2IObjAttrs_Count
End Property
Private Property Get A2IObjAttrs_Count() As Long
    A2IObjAttrs_Count = mCol.Count
End Property

Friend Function Item(vIndex) As A2SQLObjAttr
    Set Item = A2IObjAttrs_Item(vIndex)
End Function

Private Function A2IObjAttrs_Item(vIndex As Variant) As Attend2C.A2IObjAttr
    Set A2IObjAttrs_Item = mCol.Item(vIndex)
End Function

Private Property Get A2IObjAttrs_NewEnum() As stdole.IUnknown
    Set A2IObjAttrs_NewEnum = mCol.[_NewEnum]
End Property

Friend Sub SetDS(iDS As A2SQLDataSource, iIsMetaDataMode As Boolean, iIsNewObjectMode As Boolean, _
    iObjTypeX As A2SQLObjType, iMaxAttrSeq As Integer, Optional iIdent As Long = -1, Optional iValueArray As Variant = -1)
    
    Dim iObjType As Attend2C.A2IObjType
    Set iObjType = iObjTypeX
    
    'Set mDS = iDS
    Set mWrefDS = iDS.GetWeakReference
    mMetaDataMode = iIsMetaDataMode
    mIsNew = iIsNewObjectMode
    mEditMode = False
    mIdent = iIdent
    'Set mObjType = iObjType
    Set mObjTypeRef = iObjTypeX.GetWeakReference
    mTime1 = Timer
    
    Set mCol = Nothing
    Set mCol = New Collection
    Dim i As Integer
    Dim oAttr As A2SQLObjAttr
    If iMaxAttrSeq >= 0 Then
        For i = 0 To iMaxAttrSeq
            Set oAttr = New A2SQLObjAttr
            oAttr.SetDS mDS, Me, i
            mCol.Add oAttr, oAttr.Alias
        Next
    End If
    
    If mMetaDataMode Then
        mValues = -1
    Else
        If mIsNew Then
            mValues = -1
        Else
            If IsArray(iValueArray) Then
                mValues = iValueArray
            Else
                mValues = GetValueArray()
            End If
        End If
    End If
End Sub

Private Function GetValueArray() As Variant()
    Dim rst As ADODB.Recordset
    Dim cmd As ADODB.Command
    Dim parm As ADODB.Parameter
    
    Set cmd = New ADODB.Command
    
    cmd.Name = mObjType.IdentProcName
    cmd.CommandText = mObjType.IdentProcName
    
    Set parm = cmd.CreateParameter(PARM_DEFAULT_IDENT_PROC, _
        adInteger, adParamInput, 4, mIdent)
        
    cmd.CommandType = adCmdStoredProc
    Set cmd.ActiveConnection = mDS.Conn
    cmd.Parameters.Append parm
    Set rst = cmd.Execute
    
    If rst.EOF Then
        Err.Raise Attend2C.a2ErrObjNotFound, "A2SQLDS.A2SQLObjAttrs", "Object not found"
    Else
        GetValueArray = rst.GetRows(1)
    End If
End Function

Private Property Get A2IObjAttrs_ObjectType() As Attend2C.A2IObjType
    Set A2IObjAttrs_ObjectType = mObjType
End Property

Friend Property Get ObjType() As A2SQLObjType
    Set ObjType = mObjType
End Property

Private Sub A2IObjAttrs_Refresh()
        mTime1 = Timer
        mValues = GetValueArray()
End Sub

Private Sub Class_Initialize()
    Set mCol = New Collection
    'Set mDS = Nothing
    mTime1 = 0
    'Set mObjType = Nothing
    mValues = Empty
    mIdent = 0

    mEditMode = False
    mIsNew = False
    mMetaDataMode = False
    'Debug.Print " A2SQLObjAttrs Init " & cntCreated
    'cntCreated = cntCreated + 1
    
    Set mWeakRef = New A2SQLWeakRef
    mWeakRef.Initialize Me
End Sub

Friend Sub UpdateValues(iValues() As Variant)
    If mMetaDataMode Then
        Err.Raise Attend2C.a2ErrMetaDataMode, "A2SQLDS.A2SQLObjAttrs", "Values not available in meta-data mode"
    End If

    mTime1 = Timer
    mValues = iValues
End Sub

Friend Property Get Values() As Variant()
    If mMetaDataMode Then
        Err.Raise Attend2C.a2ErrMetaDataMode, "A2SQLDS.A2SQLObjAttrs", "Values not available in meta-data mode"
    End If

    Dim mTime2 As Double
    mTime2 = Timer
    
    If Abs(mTime2 - mTime1) > CACHE_SECS Then
        mTime1 = Timer
        mValues = GetValueArray()
    End If
    
    Values = mValues
    
End Property

Friend Property Get EditMode() As Boolean
    EditMode = mEditMode
End Property

Friend Property Let EditMode(iEditMode As Boolean)
    Dim v As Variant, oAttr As A2SQLObjAttr
    If mEditMode = True And iEditMode = False Then
        For Each v In mCol
            Set oAttr = v
            oAttr.Revert
        Next
        
        mEditMode = iEditMode
    End If
End Property

Friend Property Get IsNew() As Boolean
    IsNew = mIsNew
End Property

Friend Sub Save()
    If Me.EditMode Then
        If Me.IsNew Then
        
            ' do insert
        
            mIsNew = False
        Else
        
            ' do update
            
        End If
        Me.EditMode = False
    Else
        Err.Raise a2ErrNotEditMode, "A2SQLDS.A2SQLObjAttrs", "Attributes can only be saved from edit mode"
    End If
End Sub

Private Sub Class_Terminate()
    'Debug.Print " A2SQLObjAttrs Term " & cntCreated
    'cntCreated = cntCreated - 1
    mWeakRef.Destroy
End Sub


Friend Function GetWeakReference() As A2SQLWeakRef
    Set GetWeakReference = mWeakRef
End Function

