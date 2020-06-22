VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2SQLLookupTypes"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'Private mDS As A2SQLDataSource
Private mDSRef As A2SQLWeakRef

Private mCol As Collection
Private mColById As Collection

Private mWeakRef As A2SQLWeakRef

Implements Attend2C.A2ILookupTypes

Private Property Get mDS() As A2SQLDataSource
    If mDSRef Is Nothing Then
        Set mDS = Nothing
    Else
        Set mDS = mDSRef.Target
    End If
End Property

Private Property Get A2ILookupTypes_Count() As Long
    A2ILookupTypes_Count = mCol.Count
End Property

Private Function A2ILookupTypes_Item(vIndex As Variant) As Attend2C.A2ILookupType
    'Set A2ILookupTypes_Item = mCol.Item(vIndex)
    
    On Error Resume Next
    Err.Clear
    Set A2ILookupTypes_Item = mCol.Item(vIndex)
    
    If Err.Number = 5 Then
        Err.Raise Attend2C.a2ErrNotAMember, "A2SQLDS.A2SQLLookupTypes", "Item requested is not a member of the Lookup Types collection; check the alias"
    End If
End Function

Private Property Get A2ILookupTypes_NewEnum() As stdole.IUnknown
    Set A2ILookupTypes_NewEnum = mCol.[_NewEnum]
End Property

Private Sub Class_Initialize()
    Set mCol = New Collection
    Set mColById = New Collection
    Set mWeakRef = New A2SQLWeakRef
    mWeakRef.Initialize Me
End Sub


Friend Sub SetDS(iDS As A2SQLDataSource)
    Dim rst As ADODB.Recordset, rstParms As ADODB.Recordset
    Dim cmd As ADODB.Command, cmdParms As ADODB.Command
    Dim flds As ADODB.Fields, fldsParms As ADODB.Fields
    Dim prmParms As ADODB.Parameter
    
    'Set mDS = iDS
    Set mDSRef = iDS.GetWeakReference
    
    Set mCol = New Collection
    Set mColById = New Collection
    
    Dim allParmArray As Variant
    
    Dim cmdAllParms As ADODB.Command
    Set cmdAllParms = New ADODB.Command
    cmdAllParms.Name = PROC_ALL_LOOKUP_PARMS
    cmdAllParms.CommandText = PROC_ALL_LOOKUP_PARMS
    cmdAllParms.CommandType = adCmdStoredProc
    Set cmdAllParms.ActiveConnection = mDS.Conn
    
    Dim rstAllParms As ADODB.Recordset
    Set rstAllParms = cmdAllParms.Execute
    
    allParmArray = rstAllParms.GetRows()
    
    rstAllParms.Close
    Set rstAllParms = Nothing
    Set cmdAllParms = Nothing
    
    Set cmd = New ADODB.Command
    Set cmd.ActiveConnection = mDS.Conn
    cmd.CommandText = PROC_LOOKUP_TYPES

    Set rst = cmd.Execute
    
    Dim oktype As A2SQLLookupType
    Dim ObjType As A2SQLObjType
    Dim objTypes As A2SQLObjTypes
    Set objTypes = mDS.ObjectTypes
    
    Dim parmArray As Variant
    
    Dim s As String
    

    
    Dim numColsInParms As Long
    numColsInParms = UBound(allParmArray, 1)
    Dim numParms As Long
    numParms = UBound(allParmArray, 2)
    
    Dim parmArrayFinal As Variant
    Dim i As Long, x As Long
'''

While Not rst.EOF ' lookups
        Set oktype = New A2SQLLookupType
        parmArray = Null
        
        For i = 0 To numParms
            If allParmArray(FLD_LOOKUP_PARM_KEYTYPEID, i) = rst(FLD_LOOKUP_TYPE_ID).Value Then
                If IsNull(parmArray) Then
                    ReDim parmArray(numColsInParms, 0)
                Else
                    ReDim Preserve parmArray(numColsInParms, UBound(parmArray, 2) + 1)
                End If
                'tmpAttrArray(UBound(tmpAttrArray, 2)) = allAttrArray(i)
                For x = 0 To numColsInParms
                    parmArray(x, UBound(parmArray, 2)) = allParmArray(x, i)
                Next
            End If
        Next
        
        If IsEmpty(parmArray) Then
            parmArrayFinal = -1
        Else
            parmArrayFinal = parmArray
        End If
        
        Set ObjType = objTypes.ObjTypeById(rst(FLD_LOOKUP_TYPE_OBJTYPEID).Value)
        
        oktype.SetDS mDS, rst(FLD_LOOKUP_TYPE_ALIAS).Value, _
            rst(FLD_LOOKUP_TYPE_DESC).Value, _
            rst(FLD_LOOKUP_TYPE_COMMAND).Value, _
            ObjType, rst(FLD_LOOKUP_TYPE_RETURNS_IDENT).Value, _
            rst(FLD_LOOKUP_TYPE_NO_RETURN).Value, _
            rst(FLD_LOOKUP_TYPE_ID).Value, _
            parmArrayFinal
            

        s = oktype.Alias

        mCol.Add oktype, rst(FLD_LOOKUP_TYPE_ALIAS).Value
        mColById.Add oktype, CStr(rst(FLD_LOOKUP_TYPE_ID).Value)
        
        rst.MoveNext
    Wend

'''
    
End Sub

Friend Function GetWeakReference() As A2SQLWeakRef
    Set GetWeakReference = mWeakRef
End Function

Private Sub Class_Terminate()
    mWeakRef.Destroy
End Sub
