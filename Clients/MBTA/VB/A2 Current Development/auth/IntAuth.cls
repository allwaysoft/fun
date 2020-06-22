VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "IntAuth"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True

Public Function IsValid(iUserName As String, iPassword As String) As Boolean

Dim entry As NWEntry

Dim Check As Boolean

NWIDir1.FullName = "ldap://mbtaportal.mbta.com/o=MBTA"

Set entry = NWIDir1.Entries.Item("cn=" & iUserName)

Check = entry.ValidatePassword("iPassword")

IsValid = Check

End Function
