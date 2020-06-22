VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MaxLogonResult"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True

Public AppObj As A2App
Public LogonSuccessful As Boolean

' Username + password match between Maximus and OpsTech, so information
' can be used in InfoCenter
Public ValidForReporting As Boolean

' The user logged on OK to OpsTech, but the user's password does not match
' in Maximus (and they ARE a Maximus user)
Public BadMaximusPassword As Boolean

' OpsTech password was reset to match the Maximus password
Public OpsTechPasswordReset As Boolean


