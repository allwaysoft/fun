VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2System"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mDataSource As A2IDataSource
Private mIsLoggedOn As Boolean
Private mGlobals As A2Globals
Private mSysLiaison As A2ISysLiaison
Private mSubscribers As Collection
Private mWeakRef As A2CWeakSysRef

Public Property Get ObjectTypes() As A2IObjTypes
    Set ObjectTypes = Me.Liaison.ObjectTypes
End Property

Public Property Get LookupTypes() As A2ILookupTypes
    Set LookupTypes = Me.Liaison.LookupTypes
End Property

' GetObject(int/bstr) looks up an object by identifier
' GetObject(A2GetObjParm) looks up an object by a single named parameter
' GetObject(A2LookupType) gets an object -- no parms provided
' GetObject(Array) looks up an object by several named parameters
' 'Nothing' is returned if no match exists
Public Function GetObject(iObjType As A2IObjType, iParms As Variant) As A2IObject
    Set GetObject = Me.Liaison.GetObject(iObjType, iParms)
End Function

' GetObject(A2GetObjParm) finds objects by a single named parameter
' GetObjects(A2LookupType) finds all matching objects -- no parms provided
' GetObject(Array) finds objects by several named parameters
' An empty set is returned if no match exists
Public Function GetObjects(iParms As Variant) As A2IObjSet
    Set GetObjects = Me.Liaison.GetObjects(iParms)
End Function

Public Sub Execute(iParms As Variant)
    Me.Liaison.GetObjects iParms
End Sub


' Server must implement the A2IDataSource interface
' (not enforced here to maintain compatibility with VBScript)
Public Sub Logon(iServer As A2IDataSource, iUserName As String, iPassword As String, iLiaison As A2DSLiaison)
    If mIsLoggedOn Then
        Err.Raise a2ErrAlreadyLoggedOn, "Attend2C.A2System", "Log off before logging on again"
    End If
        
    Dim oLiaison As A2DSLiaison
    'Set oLiaison = New A2DSLiaison
    Set oLiaison = iLiaison
    oLiaison.SetSystem Me
    
    'Dim pServer As A2IDataSource
    
    Set mSysLiaison = iServer.Logon(oLiaison, iUserName, GetPassword(iPassword))
    mIsLoggedOn = True
    
    Set mDataSource = iServer
End Sub

Public Sub LogonByProxy(iServer As A2IDataSource, iUserName As String, iPassword As String, iAsUserName As String)
    If mIsLoggedOn Then
        Err.Raise a2ErrAlreadyLoggedOn, "Attend2C.A2System", "Log off before logging on again"
    End If
        
    Dim oLiaison As A2DSLiaison
    Set oLiaison = New A2DSLiaison
    oLiaison.SetSystem Me
    
    'Dim pServer As A2IDataSource
    
    Set mSysLiaison = iServer.LogonByProxy(oLiaison, iUserName, GetPassword(iPassword), iAsUserName)
    mIsLoggedOn = True
    
    Set mDataSource = iServer
End Sub


Public Sub Logoff()
    If Not mDataSource Is Nothing Then
        mDataSource.Logoff
    End If
    Set mDataSource = Nothing
    mIsLoggedOn = False
    Set mSysLiaison = Nothing
End Sub

Friend Sub CheckLogon()
    If Not mIsLoggedOn Then
        Err.Raise a2ErrNotLoggedOn, "Attend2C.A2System", "Not logged on"
    End If
End Sub

Friend Property Get Liaison() As A2ISysLiaison
    CheckLogon
    Set Liaison = mSysLiaison
End Property

Public Function GetPassword(iPassword) As String
    
    Dim m5 As A2CCMD5
    Set m5 = New A2CCMD5
    
    If Len(iPassword) > 50 Then
        Err.Raise a2ErrStringTooLong, "Attend2C.A2System", "Password submitted is longer than maximum allowed"
    End If
    
    GetPassword = m5.MD5(iPassword & "Attend2C-a7&3;-@-,2~|H\**he")

End Function

Private Sub Class_Initialize()
    Set mGlobals = New A2Globals
    Set mSubscribers = New Collection
    Set mWeakRef = New A2CWeakSysRef
    mWeakRef.Initialize Me
End Sub

Friend Property Get Globals() As A2Globals
    Set Globals = mGlobals
End Property

Friend Property Get ProjName() As String
    ProjName = "Attend2C"
End Property


Public Sub Subscribe(iSubscriber As A2ISubscriber)
    mSubscribers.Add iSubscriber
End Sub

Public Sub Publish(iEventType As a2PubEventType, iObj As A2IObject)
    Dim v As Variant, oSub As A2ISubscriber
    For Each v In mSubscribers
        Set oSub = v
        oSub.Accept Me, iEventType, iObj
    Next
End Sub

Public Property Get OperatingDate() As Date
    OperatingDate = Now()
End Property


Public Function Defang(iStr As String) As String
    Defang = iStr
End Function

Friend Function GetWeakSysRef() As A2CWeakSysRef
    Set GetWeakSysRef = mWeakRef
End Function

Private Sub Class_Terminate()
    Me.Logoff
    mWeakRef.Destroy
    'Debug.Print "ASYS TERMINATED"
End Sub

Public Property Get CacheSize() As Long
End Property

Public Property Let CacheSize(iCacheSize As Long)
End Property

Public Property Get CacheSeconds() As Long
End Property

Public Property Let CacheSeconds(iCacheSeconds As Long)
End Property

Public Sub StartTransaction()
    Me.Liaison.StartTransaction
End Sub

Public Sub CommitTransaction()
    Me.Liaison.CommitTransaction
End Sub

Public Sub RollbackTransaction()
    Me.Liaison.RollbackTransaction
End Sub
