VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CVirtualNotif"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

    Public Absences As A2ObjSet
    Public Rule As A2Rule
    Public NotifType As A2NotifType
    Public SeqNum As Long
    Public TriggerNote As String

Private Sub Class_Initialize()
    Set Absences = New A2ObjSet
End Sub

