VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2SQLObjTypes"
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

Implements Attend2C.A2IObjTypes

Private Property Get mDS() As A2SQLDataSource
    If mDSRef Is Nothing Then
        Set mDS = Nothing
    Else
        Set mDS = mDSRef.Target
    End If
End Property

Public Property Get A2IObjTypes_Count() As Long
    A2IObjTypes_Count = mCol.Count
End Property

Friend Function Item(vIndex As Variant) As Attend2C.A2IObjType
    Set Item = A2IObjTypes_Item(vIndex)
End Function

Private Function A2IObjTypes_Item(vIndex As Variant) As Attend2C.A2IObjType
    Set A2IObjTypes_Item = mCol.Item(vIndex)
End Function

Friend Function ObjTypeById(iId As Long) As A2SQLObjType
    Set ObjTypeById = mColById(CStr(iId))
End Function

Public Property Get A2IObjTypes_NewEnum() As stdole.IUnknown
    Set A2IObjTypes_NewEnum = mCol.[_NewEnum]
End Property

Private Sub Class_Initialize()
    Set mCol = New Collection
    Set mWeakRef = New A2SQLWeakRef
    mWeakRef.Initialize Me
End Sub

Friend Sub SetDS(iDS As A2SQLDataSource)
    Dim rst As ADODB.Recordset, rstAttrs As ADODB.Recordset
    Dim cmd As ADODB.Command, cmdAttrs As ADODB.Command
    Dim flds As ADODB.Fields, fldsAttrs As ADODB.Fields
    Dim prm As ADODB.Parameter, prmAttrs As ADODB.Parameter
    
    'Set mDS = iDS
    Set mDSRef = iDS.GetWeakReference
    
    
    
    Set cmdAttrs = New ADODB.Command
    cmdAttrs.Name = PROC_ALL_OBJ_ATTR
    cmdAttrs.CommandText = PROC_ALL_OBJ_ATTR
    cmdAttrs.CommandType = adCmdStoredProc
    Set cmdAttrs.ActiveConnection = mDS.Conn
    Set rstAttrs = cmdAttrs.Execute
    
    Dim allAttrArray As Variant
    
    allAttrArray = rstAttrs.GetRows()
    rstAttrs.Close
    Set rstAttrs = Nothing
        
    
    
    Set cmd = New ADODB.Command
    Set cmd.ActiveConnection = mDS.Conn
    cmd.CommandText = "dbo." & PROC_OBJ_TYPE
    'cmd. = PROC_OBJ_TYPE
    'cmd.NamedParameters
    Set prm = cmd.CreateParameter("@testParm", adInteger, adParamInput, 4, 1224)
    cmd.Parameters.Append prm
    'cmd.CommandType = adCmdText
   ' cmd.CommandTimeout = 15
    
    Set rst = cmd.Execute
    Set flds = rst.Fields
    
    Dim coll As Collection
    Set coll = New Collection
    
    Dim byIdColl As Collection
    Set byIdColl = New Collection
    
    Dim otype As A2SQLObjType
    Dim attrArray As Variant
    
    attrArray = -1
    

    
    Dim tmpAttrArray As Variant
    Dim v As Variant
    Dim i As Long, x As Integer
    
    
    Dim numColsInAttrs As Long
    numColsInAttrs = UBound(allAttrArray, 1)
    Dim numAttrs As Long
    numAttrs = UBound(allAttrArray, 2)
    
    While Not rst.EOF
        Set otype = New A2SQLObjType
        tmpAttrArray = Null
        
        For i = 0 To numAttrs
            If allAttrArray(FLD_ATTR_OBJTYPEID, i) = rst(FLD_OBJ_TYPE_ID).Value Then
                If IsNull(tmpAttrArray) Then
                    ReDim tmpAttrArray(numColsInAttrs, 0)
                Else
                    ReDim Preserve tmpAttrArray(numColsInAttrs, UBound(tmpAttrArray, 2) + 1)
                End If
                'tmpAttrArray(UBound(tmpAttrArray, 2)) = allAttrArray(i)
                For x = 0 To numColsInAttrs
                    tmpAttrArray(x, UBound(tmpAttrArray, 2)) = allAttrArray(x, i)
                Next
            End If
        Next
        
        If IsEmpty(tmpAttrArray) Then
            attrArray = -1
        Else
            attrArray = tmpAttrArray
        End If
        
        otype.SetDS mDS, rst(FLD_OBJ_TYPE_ENUM).Value, _
            rst(FLD_OBJ_TYPE_DESC).Value, _
            rst(FLD_OBJ_TYPE_SHORT_DESC).Value, _
            rst(FLD_OBJ_TYPE_IDENT_PROC).Value, _
            rst(FLD_OBJ_TYPE_ALIAS).Value, _
            rst(FLD_OBJ_TYPE_ID).Value, Me, _
            attrArray

        coll.Add otype, rst(FLD_OBJ_TYPE_ALIAS).Value
        byIdColl.Add otype, CStr(rst(FLD_OBJ_TYPE_ID).Value)
        rst.MoveNext
    Wend
    
    rst.Close
    
    Set rst = Nothing
    Set cmd = Nothing
    Set mCol = coll
    Set mColById = byIdColl
End Sub

'
'Friend Sub SetDS(iDS As A2SQLDataSource)
'    Dim rst As ADODB.Recordset, rstAttrs As ADODB.Recordset
'    Dim cmd As ADODB.Command, cmdAttrs As ADODB.Command
'    Dim flds As ADODB.Fields, fldsAttrs As ADODB.Fields
'    Dim prm As ADODB.Parameter, prmAttrs As ADODB.Parameter
'
'    Set mDS = iDS
'
'    Set cmd = New ADODB.Command
'    Set cmd.ActiveConnection = mDS.Conn
'    cmd.CommandText = "dbo." & PROC_OBJ_TYPE
'    'cmd. = PROC_OBJ_TYPE
'    'cmd.NamedParameters
'    Set prm = cmd.CreateParameter("@testParm", adInteger, adParamInput, 4, 1224)
'    cmd.Parameters.Append prm
'    'cmd.CommandType = adCmdText
'   ' cmd.CommandTimeout = 15
'
'    Set rst = cmd.Execute
'    Set flds = rst.Fields
'
'    Dim coll As Collection
'    Set coll = New Collection
'
'    Dim byIdColl As Collection
'    Set byIdColl = New Collection
'
'    Dim otype As A2SQLObjType
'    Dim attrArray As Variant
'
'    attrArray = -1
'
'    While Not rst.EOF
'        Set otype = New A2SQLObjType
'        Set cmdAttrs = New ADODB.Command
'        cmdAttrs.Name = PROC_OBJ_ATTR
'        cmdAttrs.CommandText = PROC_OBJ_ATTR
'
'        Set prmAttrs = cmdAttrs.CreateParameter(PARM_PROC_OBJ_ATTR, _
'            adInteger, adParamInput, 4, rst(FLD_OBJ_TYPE_ID).Value)
'        cmdAttrs.Parameters.Append prmAttrs
'
'        cmdAttrs.CommandType = adCmdStoredProc
'        Set cmdAttrs.ActiveConnection = mDS.Conn
'        Set rstAttrs = cmdAttrs.Execute
'
'        If rstAttrs.EOF Then
'            attrArray = -1
'        Else
'            attrArray = rstAttrs.GetRows()
'        End If
'
'        Set cmdAttrs = Nothing
'        rstAttrs.Close
'        Set rstAttrs = Nothing
'
'        otype.SetDS mDS, rst(FLD_OBJ_TYPE_ENUM).Value, _
'            rst(FLD_OBJ_TYPE_DESC).Value, _
'            rst(FLD_OBJ_TYPE_SHORT_DESC).Value, _
'            rst(FLD_OBJ_TYPE_IDENT_PROC).Value, _
'            rst(FLD_OBJ_TYPE_ALIAS).Value, _
'            rst(FLD_OBJ_TYPE_ID).Value, Me, _
'            attrArray
'
'        coll.Add otype, rst(FLD_OBJ_TYPE_ALIAS).Value
'        byIdColl.Add otype, CStr(rst(FLD_OBJ_TYPE_ID).Value)
'        rst.MoveNext
'    Wend
'
'    rst.Close
'
'    Set rst = Nothing
'    Set cmd = Nothing
'    Set mCol = coll
'    Set mColById = byIdColl
'End Sub
Private Sub Class_Terminate()
    mWeakRef.Destroy
End Sub

Friend Function GetWeakReference() As A2SQLWeakRef
    Set GetWeakReference = mWeakRef
End Function
