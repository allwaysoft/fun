VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2SQLDataSource"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements Attend2C.A2IDataSource

Private mConn As ADODB.Connection
Private mIsLoggedOn As Boolean
Private mUsername As String
Private mConnString As String
Private mLiaison As Attend2C.A2DSLiaison
Private mSysLiaison As A2SQLSysLiaison

Private mObjCache As Scripting.Dictionary

Private mObjTypes As A2SQLObjTypes
Private mLookupTypes As A2SQLLookupTypes

Private mWeakRef As A2SQLWeakRef

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Dest As Any, Source As Any, ByVal Bytes As Long)

Private Property Let A2IDataSource_CacheSeconds(RHS As Long)
    CACHE_SECS = RHS
End Property

Private Property Get A2IDataSource_CacheSeconds() As Long
    A2IDataSource_CacheSeconds = CACHE_SECS
End Property

Private Property Let A2IDataSource_CacheSize(RHS As Long)
    CACHE_OBJ_MAX = RHS
End Property

Private Property Get A2IDataSource_CacheSize() As Long
    A2IDataSource_CacheSize = CACHE_OBJ_MAX
End Property

Private Property Let A2IDataSource_ConnectionString(iStr As String)
    If mIsLoggedOn Then
        RaiseErr Attend2C.a2ErrAlreadyLoggedOn, "Logged on as " & mUsername
    End If
    
    mConnString = iStr

End Property

Private Property Get A2IDataSource_ConnectionString() As String
    A2IDataSource_ConnectionString = mConnString
End Property

' GetObjects(A2LookupType) finds all matching objects -- no parms provided
' GetObjects(A2GetObjParm) finds objects by a single named parameter
' GetObjects(Array) finds objects by several named parameters
Friend Function GetObjects(iParms As Variant) As Attend2C.A2IObjSet

    Dim cmd As ADODB.Command
    Dim rst As ADODB.Recordset
    Dim prm As ADODB.Parameter
    
    Dim parmArr() As Attend2C.A2GetObjParm
    
    Dim gop As Attend2C.A2GetObjParm
    Dim fParm As A2SQLLookupTypeParm
    Dim fParmObjType As Attend2C.A2IObjType
    Dim fParmObj As Attend2C.A2IObject
    
    Dim fLookupType As A2SQLLookupType
    Dim fLookupTypeX As A2ILookupType  ' Alternate interface to this object
    Dim fLookupTypeObjType As A2SQLObjType
    Dim i As Long, x As Long
    
    Dim fIdentParm As Long
    
    Dim valArray As Variant
    Dim objSet As A2SQLObjSet
    
    Dim singleValArray As Variant
    
    Dim obj As Attend2C.A2IObject
    Dim objAttrs As A2SQLObjAttrs
    Dim maxAttrIndex As Integer
    
    Dim identColIndex As Integer
    Dim identVal As Long
    
    Dim coll As Collection
    
    Dim adoErr As ADODB.Error

    If VarType(iParms) = vbObject Then
        Set fLookupType = iParms
        Set fLookupTypeX = fLookupType
         Set fLookupTypeObjType = fLookupTypeX.ObjectType
         maxAttrIndex = fLookupTypeObjType.Attributes.Count - 1
         identColIndex = fLookupTypeObjType.IdentAttribute.Sequence
        
         Set cmd = New ADODB.Command
         cmd.CommandText = fLookupType.CommandText
         cmd.Name = fLookupType.CommandText
    
    Else
    
         If VarType(iParms) = vbUserDefinedType Then
             ' Should be an A2GetObjParm
             gop = iParms
             ReDim parmArr(0)
             parmArr(0) = iParms
         Else
             If Not IsArray(iParms) Then
                 ' Error
                 Err.Raise a2ErrGetObjectsOpts, "A2SQLDS.A2SQLDataSource", "GetObjects requires a lookup type, a single parameter/value pair, or an array of parameter/value pairs"
             Else
                 ReDim parmArr(UBound(iParms))
                 For i = LBound(iParms) To UBound(iParms)
                     parmArr(i) = iParms(i)
                 Next
             End If
         
         End If
         
         gop = parmArr(LBound(parmArr))
         Set fParm = gop.parm
         Set fLookupType = gop.parm.LookupType
         Set fLookupTypeX = fLookupType
         Set fLookupTypeObjType = gop.parm.LookupType.ObjectType
         maxAttrIndex = fLookupTypeObjType.Attributes.Count - 1
         identColIndex = fLookupTypeObjType.IdentAttribute.Sequence
         
         Set cmd = New ADODB.Command
         cmd.CommandText = fLookupType.CommandText
         cmd.Name = fLookupType.CommandText
        ' cmd.CommandType = adCmdStoredProc
         
         For i = LBound(parmArr) To UBound(parmArr)
             gop = parmArr(i)
             Set fParm = gop.parm
             If Not gop.parm.LookupType.EqualTo(fLookupType) Then
                 ' error!
                Err.Raise a2ErrGetObjParmMismatch, "A2SQLDS.A2SQLDataSource", "Only parameters of the same lookup type can be grouped together to Get Objects"
             End If
             
             Select Case fParm.DataType
                 Case Attend2C.a2DataType.a2DataTypeBit
                     Set prm = cmd.CreateParameter(fParm.ParameterName, adBoolean, adParamInput, Len(gop.Val), gop.Val)
                    If Not IsNumeric(gop.Val) Then
                        Err.Raise a2ErrDataTypeMismatch, "A2SQLDS.A2SQLDataSource", "Parameter value must evaluate to True or False"
                    End If
                 Case Attend2C.a2DataType.a2DataTypeDateTime
                    If Not IsDate(gop.Val) Then
                        Err.Raise a2ErrDataTypeMismatch, "A2SQLDS.A2SQLDataSource", "Parameter value must be a date"
                    End If
                     Set prm = cmd.CreateParameter(fParm.ParameterName, adDBTimeStamp, adParamInput, Len(gop.Val), gop.Val)
                 Case Attend2C.a2DataType.a2DataTypeDecimal
                    If Not IsNumeric(gop.Val) Then
                        Err.Raise a2ErrDataTypeMismatch, "A2SQLDS.A2SQLDataSource", "Parameter value must be a decimal/numeric"
                    End If
                     Set prm = cmd.CreateParameter(fParm.ParameterName, adDouble, adParamInput, Len(gop.Val), gop.Val)
                 Case Attend2C.a2DataType.a2DataTypeGUID
                     Set prm = cmd.CreateParameter(fParm.ParameterName, adGUID, adParamInput, Len(gop.Val), gop.Val)
                 Case Attend2C.a2DataType.a2DataTypeInt
                    If Not IsNumeric(gop.Val) Then
                        Err.Raise a2ErrDataTypeMismatch, "A2SQLDS.A2SQLDataSource", "Parameter value must be an integer/numeric"
                    End If
                     Set prm = cmd.CreateParameter(fParm.ParameterName, adInteger, adParamInput, Len(gop.Val), gop.Val)
                 Case Attend2C.a2DataType.a2DataTypeLargeText
                     Set prm = cmd.CreateParameter(fParm.ParameterName, adVarChar, adParamInput, Len(gop.Val), gop.Val)
                 Case Attend2C.a2DataType.a2DataTypeObjRef
                     Set fParmObjType = gop.parm.ObjectType
                     If Not IsObject(gop.Val) Then
                         ' error!
                         Err.Raise a2ErrGetObjMissing, "A2SQLDS.A2SQLDataSource", "A required object parameter for a lookup was not provided or is not an object"
                     Else
                        If gop.Val Is Nothing Then
                            Err.Raise a2ErrGetObjMissing, "A2SQLDS.A2SQLDataSource", "A required object parameter for a lookup was not provided or is not an object"
                        End If
                         Set fParmObj = gop.Val
                         If Not fParmObj.ObjectType.EqualTo(fParmObjType) Then
                             ' error!
                             Err.Raise a2ErrGetObjTypeMismatch, "A2SQLDS.A2SQLDataSource", "Object type passed as parameter value does not match required object type"
                         End If
                         fIdentParm = CLng(fParmObj.Identifier)
                     End If
                     Set prm = cmd.CreateParameter(fParm.ParameterName, adInteger, adParamInput, Len(fIdentParm), fIdentParm)
                 Case Attend2C.a2DataType.a2DataTypeText
                     Set prm = cmd.CreateParameter(fParm.ParameterName, adVarChar, adParamInput, 255, gop.Val)
             End Select
             
             cmd.Parameters.Append prm
         Next
    End If
    
    If fLookupType.ReturnsIdent = True Then
        Set prm = cmd.CreateParameter(PARM_OUTPUT_IDENT, adInteger, adParamOutput)
        cmd.Parameters.Append prm
    End If
    
    Set cmd.ActiveConnection = Me.Conn
    
    Set objSet = New A2SQLObjSet
    Set coll = New Collection
    Dim countADO As Integer, countReq As Integer
    countReq = fLookupTypeX.Parameters.Count
    countADO = cmd.Parameters.Count
    
    If countADO < countReq Then
        Err.Raise a2ErrParmMissing, "A2SQLDS.A2SQLDataSource", countReq & " parameters required but only " & countADO & " supplied"
    End If
    
    If fLookupType.ReturnsIdent = True Or fLookupTypeX.HasReturnValue = False Then
        cmd.CommandType = adCmdStoredProc
        
        On Error Resume Next
        Err.Clear
        cmd.ActiveConnection.Errors.Clear
        cmd.Execute
        If Err.Number <> 0 Then
            On Error GoTo 0
            If cmd.ActiveConnection.Errors.Count >= 1 Then
                Set adoErr = cmd.ActiveConnection.Errors(0)
                Err.Raise a2ErrDataOperationFailed, "A2SQLDS.A2SQLDataSource", TrimODBCError(adoErr.Description)
            Else
                Err.Raise a2ErrDataOperationFailed, "A2SQLDS.A2SQLDataSource", "Data operation failed."
            End If
        End If
        
        On Error GoTo 0
        
        If fLookupTypeX.HasReturnValue Then
            If Not IsNull(cmd.Parameters(PARM_OUTPUT_IDENT).Value) Then
                identVal = CLng(cmd.Parameters(PARM_OUTPUT_IDENT).Value)
                coll.Add Me.GetObject(fLookupTypeObjType, identVal)
            End If
        End If
    Else
        On Error Resume Next
        Err.Clear
        cmd.ActiveConnection.Errors.Clear
        cmd.CommandType = adCmdStoredProc
        Set rst = cmd.Execute
        
        If Err.Number <> 0 Then
            On Error GoTo 0
            Err.Clear
            If cmd.ActiveConnection.Errors.Count >= 1 Then
                Set adoErr = cmd.ActiveConnection.Errors(0)
                Err.Raise a2ErrDataOperationFailed, "A2SQLDS.A2SQLDataSource", TrimODBCError(adoErr.Description)
            Else
                Err.Raise a2ErrDataOperationFailed, "A2SQLDS.A2SQLDataSource", "Data operation failed."
            End If
        End If
        
        
        On Error GoTo 0
        
        
        If Not rst.EOF Then
            valArray = rst.GetRows()
            
            rst.Close
            Set rst = Nothing
            Set cmd = Nothing
            Set prm = Nothing
            
            For i = LBound(valArray, 2) To UBound(valArray, 2)
                Set objAttrs = New A2SQLObjAttrs
                ReDim singleValArray(UBound(valArray, 1), 0)
                For x = LBound(valArray, 1) To UBound(valArray, 1)
                    singleValArray(x, 0) = valArray(x, i)
                Next
                objAttrs.SetDS Me, False, False, fLookupTypeObjType, maxAttrIndex, CLng(valArray(identColIndex, i)), singleValArray
                Set obj = Me.GetCachedObject(fLookupTypeObjType, CLng(valArray(identColIndex, i)))
                
                If obj Is Nothing Then
                    Set obj = mLiaison.BuildObject(fLookupTypeObjType, objAttrs)
                    Me.AddToCache obj
                End If
                
                coll.Add obj
            Next
        End If
        Set rst = Nothing
        
    End If
    
    Set cmd = Nothing
    
    objSet.SetColl coll
    
    Set GetObjects = objSet

End Function

Friend Property Get LookupTypes() As Attend2C.A2ILookupTypes

    If mLookupTypes Is Nothing Then
        Set mLookupTypes = New A2SQLLookupTypes
        mLookupTypes.SetDS Me
    End If
    
    Set LookupTypes = mLookupTypes
End Property

Friend Function CreateObject(iObjType As A2IObjType) As Attend2C.A2IObject
    Dim cmd As ADODB.Command
    Dim rst As ADODB.Recordset
    Dim prm As ADODB.Parameter
   
    Dim o As Attend2C.A2IObject
    
    Dim oAttrs As A2SQLObjAttrs
    Set oAttrs = New A2SQLObjAttrs
    oAttrs.SetDS Me, False, True, iObjType, iObjType.Attributes.Count - 1
    
    Set o = mLiaison.BuildObject(iObjType, oAttrs)
    Set CreateObject = o
End Function

Public Function GetObjFromIdent(iObjType As A2SQLObjType, iIdent As Long) As Attend2C.A2IObject
    Dim cmd As ADODB.Command
    Dim rst As ADODB.Recordset
    Dim prm As ADODB.Parameter
   
    Dim o As Attend2C.A2IObject
    
    Set o = Me.GetCachedObject(iObjType, iIdent)
    
    If Not o Is Nothing Then
        Set GetObjFromIdent = o
        Exit Function
    End If
    
    Dim oAttrs As A2SQLObjAttrs
    Set oAttrs = New A2SQLObjAttrs
    oAttrs.SetDS Me, False, False, iObjType, iObjType.Attributes.Count - 1, _
        iIdent
    
    Set o = mLiaison.BuildObject(iObjType, oAttrs)
    
    Me.AddToCache o
    
    Set GetObjFromIdent = o
End Function

Friend Function GetObject(iObjType As Attend2C.A2IObjType, iParms As Variant) As Attend2C.A2IObject
    
    Dim objSet As A2IObjSet, v As Variant
    
    If IsArray(iParms) Or VarType(iParms) = vbUserDefinedType Or IsObject(iParms) Then
        Set objSet = Me.GetObjects(iParms)
        If objSet.Count = 0 Then
            Set GetObject = Nothing
            Exit Function
        Else
            For Each v In objSet
                Set GetObject = v
                Exit Function
            Next
        End If
    End If
    
    If VarType(iParms) = vbLong Or VarType(iParms) = vbInteger Then
        Set GetObject = Me.GetObjFromIdent(iObjType, CLng(iParms))
        Exit Function
    End If

End Function

Friend Property Get ObjectTypes() As A2SQLObjTypes
    If mObjTypes Is Nothing Then
        
        Set mObjTypes = New A2SQLObjTypes
        mObjTypes.SetDS Me
    End If
     
    Set ObjectTypes = mObjTypes
End Property

Public Property Get DispInterfaceX() As Attend2C.A2IDataSource
    Set DispInterfaceX = Me
End Property


Public Function A2IDataSource_Logon(iLiaison As Attend2C.A2DSLiaison, iUsername As String, iPassword As String) As Attend2C.A2ISysLiaison
    If mIsLoggedOn Then
        RaiseErr Attend2C.a2ErrAlreadyLoggedOn, "Logged on as " & mUsername
    End If
    
    Dim pUsername As String * USERNAME_LENGTH
    Dim pPassword As String * PASSWORD_LENGTH
    pUsername = Defang(iUsername)
    pPassword = Defang(iPassword)
    
    If Len(pUsername) > USERNAME_LENGTH Then
        Err.Raise Attend2C.a2ErrStringTooLong, "A2SQLDS.A2SQLDataSource", "Username limited to " & USERNAME_LENGTH & " characters"
    End If
    
    If Len(pPassword) > PASSWORD_LENGTH Then
        Err.Raise Attend2C.a2ErrStringTooLong, "A2SQLDS.A2SQLDataSource", "Password limited to " & PASSWORD_LENGTH & " characters"
    End If
    
    If Len(mConnString) = 0 Then
        mConnString = DEFAULT_ODBC
    End If
    
    Set mConn = New ADODB.Connection
    'mConn.Open mConnString, "Attend2SQLUser", "bzr923"
    mConn.Open mConnString, DB_USERNAME, DB_PASSWORD
    
    Set mLiaison = iLiaison
    
    mIsLoggedOn = True
    
    Set mSysLiaison = New A2SQLSysLiaison
    mSysLiaison.SetDS Me
    
    Set A2IDataSource_Logon = mSysLiaison
    
    Dim cmd As ADODB.Command
    Dim usernameParm As ADODB.Parameter
    Dim passwordParm As ADODB.Parameter
    Dim rst As ADODB.Recordset
    
    Set cmd = New ADODB.Command
    
    cmd.CommandText = PROC_LOGON
    Set cmd.ActiveConnection = Me.Conn
    cmd.CommandType = adCmdStoredProc

    Set usernameParm = cmd.CreateParameter(PROC_LOGON_USERNAME, adVarChar, adParamInput, USERNAME_LENGTH, pUsername)
    cmd.Parameters.Append usernameParm
    Set passwordParm = cmd.CreateParameter(PROC_LOGON_PASSWORD, adVarChar, adParamInput, PASSWORD_LENGTH, pPassword)
    cmd.Parameters.Append passwordParm
    
    On Error GoTo LogonFail
    
    cmd.Execute
    
    Exit Function
    
LogonFail:
    
    mIsLoggedOn = False
    Err.Raise Attend2C.a2ErrLogonFailed, "A2SQLDS.S2SQLDataSource", "Logon failed"
    
End Function

Public Sub A2IDataSource_Logoff()
    Set mLiaison = Nothing
    mIsLoggedOn = False
    Set mConn = Nothing
End Sub


Friend Function GetCachedObject(iObjType As A2SQLObjType, iIdent As Long, Optional iVals As Variant = -1) As Attend2C.A2IObject
    Dim oAttrs As A2SQLObjAttrs
    Dim obj As A2IObject
    Dim valArr() As Variant
    Dim s As String
    s = iObjType.Alias & "/" & iIdent
    If mObjCache.Exists(s) Then
        Set obj = mObjCache(s)
        If IsArray(iVals) Then
            valArr = iVals
            Set oAttrs = obj.Attributes
            oAttrs.UpdateValues valArr
        End If
        
        Set GetCachedObject = obj
    Else
        Set GetCachedObject = Nothing
    End If
End Function

Friend Sub AddToCache(iObj As A2IObject)
    Dim ObjType As A2SQLObjType
    Set ObjType = iObj.ObjectType
    Dim ident As Long
    ident = CLng(iObj.Identifier)
    
    Dim s As String
    s = ObjType.Alias & "/" & ident
    
    If mObjCache.Exists(s) Then
        mObjCache.Remove s
    End If
    
    If mObjCache.Count >= CACHE_OBJ_MAX Then
        mObjCache.RemoveAll
        Set mObjCache = Nothing
        Set mObjCache = New Scripting.Dictionary
    End If
    
    mObjCache.Add s, iObj
End Sub

Private Function A2IDataSource_LogonByProxy(iLiaison As Attend2C.A2DSLiaison, iUsername As String, iPassword As String, iAsUserName As String) As Attend2C.A2ISysLiaison
    If mIsLoggedOn Then
        RaiseErr Attend2C.a2ErrAlreadyLoggedOn, "Logged on as " & mUsername
    End If
    
    Dim pUsername As String * USERNAME_LENGTH
    Dim pPassword As String * PASSWORD_LENGTH
    Dim pAsUsername As String * USERNAME_LENGTH
    pUsername = Defang(iUsername)
    pPassword = Defang(iPassword)
    pAsUsername = Defang(iAsUserName)
    
    If Len(pUsername) > USERNAME_LENGTH Then
        Err.Raise Attend2C.a2ErrStringTooLong, "A2SQLDS.A2SQLDataSource", "Username limited to " & USERNAME_LENGTH & " characters"
    End If
    
    If Len(pPassword) > PASSWORD_LENGTH Then
        Err.Raise Attend2C.a2ErrStringTooLong, "A2SQLDS.A2SQLDataSource", "Password limited to " & PASSWORD_LENGTH & " characters"
    End If
    
    If Len(pAsUsername) > USERNAME_LENGTH Then
        Err.Raise Attend2C.a2ErrStringTooLong, "A2SQLDS.A2SQLDataSource", "Username limited to " & USERNAME_LENGTH & " characters"
    End If
    
    
    If Len(mConnString) = 0 Then
        mConnString = DEFAULT_ODBC
    End If
    
    Set mConn = New ADODB.Connection
    mConn.Open mConnString, DB_USERNAME, DB_PASSWORD
    
    Set mLiaison = iLiaison
    
    mIsLoggedOn = True
    
    Set mSysLiaison = New A2SQLSysLiaison
    mSysLiaison.SetDS Me
    
    Set A2IDataSource_LogonByProxy = mSysLiaison
    
    Dim cmd As ADODB.Command
    Dim usernameParm As ADODB.Parameter
    Dim passwordParm As ADODB.Parameter
    Dim asUsernameParm As ADODB.Parameter
    Dim rst As ADODB.Recordset
    
    Set cmd = New ADODB.Command
    
    cmd.CommandText = PROC_LOGONPROXY
    Set cmd.ActiveConnection = Me.Conn
    cmd.CommandType = adCmdStoredProc

    Set usernameParm = cmd.CreateParameter(PROC_LOGONPROXY_USERNAME, adVarChar, adParamInput, USERNAME_LENGTH, pUsername)
    cmd.Parameters.Append usernameParm
    Set passwordParm = cmd.CreateParameter(PROC_LOGONPROXY_PASSWORD, adVarChar, adParamInput, PASSWORD_LENGTH, pPassword)
    cmd.Parameters.Append passwordParm
    Set asUsernameParm = cmd.CreateParameter(PROC_LOGONPROXY_PROXY_USERNAME, adVarChar, adParamInput, USERNAME_LENGTH, pAsUsername)
    cmd.Parameters.Append asUsernameParm
    
    On Error GoTo LogonFail
    
    cmd.Execute
    
    
    Exit Function
    
LogonFail:
    
    mIsLoggedOn = False
    Err.Raise Attend2C.a2ErrLogonFailed, "A2SQLDS.S2SQLDataSource", "Logon failed"
    


End Function

Private Sub Class_Initialize()
    mIsLoggedOn = False
    mUsername = ""
    Set mConn = Nothing
    mConnString = ""
    Set mObjTypes = Nothing
    Set mLookupTypes = Nothing
    
    Set mObjCache = New Scripting.Dictionary
    
    Set mWeakRef = New A2SQLWeakRef
    mWeakRef.Initialize Me
    
    CACHE_OBJ_MAX = CACHE_OBJ_MAX_DEFAULT
    CACHE_SECS = CACHE_SECS_DEFAULT
    
    'cntCreated = 0
End Sub

Friend Property Get ProjName() As String
    ProjName = "A2SQLDS"
End Property

Friend Sub RaiseErr(iErrType As Attend2C.a2Err, iErrDetails As String)
    Err.Raise iErrType, "A2SQLDataSource", "A2SQLDataSource Error " & iErrType
End Sub

Friend Function Defang(iStr As String) As String
    Defang = iStr
End Function

Friend Property Get Conn() As ADODB.Connection
    CheckLogon
    Set Conn = mConn
End Property

Friend Sub CheckLogon()
    If Not mIsLoggedOn Then
        Err.Raise a2ErrNotLoggedOn, "A2SQLDS.A2SQLDataSource", "Not logged on"
    End If
End Sub

Private Sub Class_Terminate()
    Set mObjCache = Nothing
    Set mLookupTypes = Nothing
    Set mObjTypes = Nothing
    
    If mIsLoggedOn Then
        Me.A2IDataSource_Logoff
    End If
    
    mWeakRef.Destroy
    
    Set mWeakRef = Nothing
    'Debug.Print "DS TERMINATE " & cntCreated
End Sub


Private Function TrimODBCError(initErr As String) As String
    Dim s As String
    If InStr(1, initErr, "]") Then
        s = Mid(initErr, InStr(1, initErr, "]") + 1)
        TrimODBCError = TrimODBCError(s)
    Else
        s = initErr
        TrimODBCError = s
    End If
End Function

Friend Function GetWeakReference() As A2SQLWeakRef
    Set GetWeakReference = mWeakRef
End Function

Public Property Get RefCount() As Long
    RefCount = VB5GetRefCount(Me)
End Property

Private Function VB5GetRefCount(ByVal pUnk As IUnknown) As Long
    If pUnk Is Nothing Then Exit Function
    ' Get count from magic offset in object
    CopyMemory VB5GetRefCount, ByVal ObjPtr(pUnk) + 4, 4
    ' Adjust to account for references to parameter
    VB5GetRefCount = VB5GetRefCount - 3
End Function
