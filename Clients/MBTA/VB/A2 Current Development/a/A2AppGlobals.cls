VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2AppGlobals"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Enum a2NotifSeverity
    a2NotifSeverityViolation = 1
    a2NotifSeverityWarning = 2
    a2NotifSeverityInformation = 3
End Enum

Public Enum a2FMLALeaveReason
    a2FMLALeaveReasonBirth = 1
    a2FMLALeaveReasonSon = 2
    a2FMLALeaveReasonDaughter = 3
    a2FMLALeaveReasonMother = 4
    a2FMLALeaveReasonFather = 5
    a2FMLALeaveReasonWife = 6
    a2FMLALeaveReasonHusband = 7
    a2FMLALeaveReasonChild = 8
    a2FMLALeaveReasonFamilyMember = 9
    a2FMLALeaveReasonParent = 10
    a2FMLALeaveReasonSpouse = 11
    a2FMLALeaveReasonIllness = 12
    a2FMLALeaveReasonNotStated = 13
End Enum

Public Enum a2FMLALeaveType
    a2FMLALeaveTypeContinuous = 1
    a2FMLALeaveTypeReduced = 2
    a2FMLALeaveTypeIntermittent = 3
    a2FMLALeaveTypeNotStated = 4
    a2FMLALeaveTypeCombination = 5
    a2FMLALeaveTypeIrregularIntermittent = 6
End Enum

Public Enum a2FMLALeaveStatus
    a2FMLALeaveStatusApproved = 1
    a2FMLALeaveStatusClosed = 2
    a2FMLALeaveStatusDenied = 3
    a2FMLALeaveStatusExpected = 4
    a2FMLALeaveStatusConditional = 5
    a2FMLALeaveStatusPending = 6
End Enum

Public Enum a2DisStatus
    a2DisStatusOpen = 1
    a2DisStatusEffective = 2
    a2DisStatusCancelled = 3
    a2DisStatusWaived = 4
    a2DisStatusDeferred = 5
End Enum

