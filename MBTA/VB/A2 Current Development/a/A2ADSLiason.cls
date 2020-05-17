VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2ADSLiason"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements Attend2C.A2DSLiaison

Private mSys As A2System

Friend Sub SetSystem(iSys As A2System)
    Set mSys = iSys
End Sub

Public Function BuildObject(iObjType As A2IObjType, iObjAttrs As A2IObjAttrs) As A2IObject

If mSys Is Nothing Then
    Err.Raise a2ErrObjSysNotSet, _
            "Attend2A.A2ADSLiaison", _
            "Action cannot be performed because System property not set for this object."
End If

Dim sAlias As String
sAlias = iObjType.Alias

Dim iObj As A2IObject

Select Case sAlias
    Case OTA_ABS
        Set iObj = New A2Abs
    Case OTA_ABS_ABS_TYPE
        Set iObj = New A2AbsAbsType
    Case OTA_ABS_GRP
        Set iObj = New A2AbsGrp
    Case OTA_ABS_TYPE
        Set iObj = New A2AbsType
    'Case OTA_ABS_TYPE_GRP
        
    'Case OTA_ABS_TYPE_GRP_ABS_TYPE
        
    Case OTA_DIS
        Set iObj = New A2Dis
    Case OTA_DIS_ACT
        Set iObj = New A2DisAct
    Case OTA_DIS_ACT_TYPE
        Set iObj = New A2DisActType
    Case OTA_DIS_TYPE
        Set iObj = New A2DisType
    Case OTA_EMP
        Set iObj = New A2Employee
    Case OTA_NOTIF
        Set iObj = New A2Notif
    Case OTA_NOTIF_TYPE
        Set iObj = New A2NotifType
    Case OTA_RULE
        Set iObj = New A2Rule
    Case OTA_SRC
        Set iObj = New A2Source
    Case OTA_USER
        Set iObj = New A2User
    Case OTA_USER_TYPE
        Set iObj = New A2UserType
    Case OTA_USER_WATCH_EMP
    
    Case OTA_ABS_TO_REPLACE
        Set iObj = New A2AbsToReplace
    Case OTA_ABS_TO_REPL_ABS_TYPE
        Set iObj = New A2AbsToReplAbsType
        
    Case OTA_WATCH_PREF
        Set iObj = New A2WatchPref
    Case OTA_EMP_FMLA
        Set iObj = New A2EmpFMLA
    Case OTA_ABS_CAL_DAY
        Set iObj = New A2AbsCalDay
    Case OTA_EXTENDED_EMP_INFO
        Set iObj = New A2ExtendedEmpInfo
    Case OTA_SUMM_ABS_TO_REPL
        Set iObj = New A2SummAbsToRepl
    Case OTA_EXT_NOTIF
        Set iObj = New A2ExtNotif
    Case OTA_SEC_OVERRIDE
        Set iObj = New A2SecOverride
    Case OTA_AREA
        Set iObj = New A2Area
    Case OTA_EXT_WATCH_PREF
        Set iObj = New A2ExtWatchPref
    Case OTA_EXT_ABS
        Set iObj = New A2ExtAbs
    Case Else
        Err.Raise a2ErrObjTypeContext, "Attend2A.A2ADSLiaison", "Object Type not valid in this context or not defined in data source liaison"
End Select

Set iObj.Attributes = iObjAttrs
Set iObj.System = mSys

Set BuildObject = iObj

End Function

Private Function A2DSLiaison_BuildObject(iObjType As Attend2C.A2IObjType, iObjAttrs As Attend2C.A2IObjAttrs) As Attend2C.A2IObject
    Set A2DSLiaison_BuildObject = BuildObject(iObjType, iObjAttrs)
End Function

Private Sub A2DSLiaison_SetSystem(iSys As Attend2C.A2System)
    SetSystem iSys
End Sub

Private Sub Class_Initialize()
    Set mSys = Nothing
End Sub


