VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2IDataSource"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit


Public Property Get ConnectionString() As String
Attribute ConnectionString.VB_UserMemId = 0
End Property

Public Property Let ConnectionString(iStr As String)
End Property

Public Function Logon(iLiaison As A2DSLiaison, iUserName As String, iPassword As String) As A2ISysLiaison
End Function

Public Function LogonByProxy(iLiaison As A2DSLiaison, iUserName As String, _
        iPassword As String, iAsUserName As String) As A2ISysLiaison
End Function

Public Sub Logoff()
End Sub

Public Property Get CacheSize() As Long
End Property

Public Property Let CacheSize(iCacheSize As Long)
End Property

Public Property Get CacheSeconds() As Long
End Property

Public Property Let CacheSeconds(iCacheSeconds As Long)
End Property


