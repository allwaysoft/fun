VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2Globals"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Enum a2DataType
    a2DataTypeObjRef = 0
    a2DataTypeText = 1
    a2DataTypeInt = 2
    a2DataTypeDateTime = 3
    a2DataTypeDecimal = 4
    a2DataTypeGUID = 5
    a2DataTypeBit = 6
    a2DataTypeLargeText = 7
End Enum

Public Type A2GetObjParm
    parm As A2ILookupTypeParm
    Val As Variant
End Type

Public Enum a2Err
    a2ErrNotLoggedOn = vbObjectError + 1
    a2ErrAlreadyLoggedOn = vbObjectError + 2
    a2ErrObjSysNotSet = vbObjectError + 3
    a2ErrObjTypeContext = vbObjectError + 4
    a2ErrStringTooLong = vbObjectError + 5
    a2ErrObjNotFound = vbObjectError + 6
    a2ErrMetaDataMode = vbObjectError + 7
    a2ErrNoAttributes = vbObjectError + 8
    a2ErrNoIdentAttribute = vbObjectError + 9
    a2ErrNotAMember = vbObjectError + 10
    a2ErrLogonFailed = vbObjectError + 11
    a2ErrGetObjectsOpts = vbObjectError + 12
    a2ErrGetObjTypeMismatch = vbObjectError + 13
    a2ErrGetObjMissing = vbObjectError + 14
    a2ErrGetObjParmMismatch = vbObjectError + 15
    a2ErrValueNotAltered = vbObjectError + 16
    a2ErrNotEditMode = vbObjectError + 17
    a2ErrReplaceAbs = vbObjectError + 18
    a2ErrDataTypeMismatch = vbObjectError + 19
    a2ErrParmMissing = vbObjectError + 20
    a2ErrDataOperationFailed = vbObjectError + 21
    a2ErrRequestedValueNull = vbObjectError + 22
    a2ErrDisEffective = vbObjectError + 23
    a2ErrDisconnected = vbObjectError + 24
End Enum

Public Enum a2PubEventType
    a2PubEvTypeEmpAdded
    a2PubEvTypeEmpAltered
    a2PubEvTypeAbsAdded
    a2PubEvTypeAbsAltered
    a2PubEvTypeAbsReplaced
    a2PubEvTypeNotifAdded
    a2PubEvTypeNotifCancelled
    a2PubEvTypeDisAdded
    a2PubEvTypeDisAltered
End Enum
