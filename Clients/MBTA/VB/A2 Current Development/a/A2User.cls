VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "A2User"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements A2IObject
Private mAttrs As A2IObjAttrs
Private mSys As A2System


Private Property Get A2IObject_AsIDefault() As Object
    Dim iDef As A2User
    Set iDef = Me
    Set A2IObject_AsIDefault = iDef

End Property

Private Property Set A2IObject_Attributes(RHS As A2IObjAttrs)
    If mAttrs Is Nothing Then
        Set mAttrs = RHS
    End If
End Property

Private Function A2IObject_IsEqualTo(iObj As A2IObject) As Boolean
    If Me.ObjectType.EqualTo(iObj.ObjectType) Then
        If Me.Identifier = iObj.Identifier Then
            A2IObject_IsEqualTo = True
        Else
            A2IObject_IsEqualTo = False
        End If
    Else
        A2IObject_IsEqualTo = False
    End If
End Function



Private Property Get A2IObject_AsA2IObject() As A2IObject
    Set A2IObject_AsA2IObject = Me
End Property

Private Property Get A2IObject_AsIDispatch() As Object
    Set A2IObject_AsIDispatch = Me
End Property

Private Property Get A2IObject_Attributes() As A2IObjAttrs
    Set A2IObject_Attributes = mAttrs
End Property

Private Property Get A2IObject_Identifier() As Variant
    A2IObject_Identifier = mAttrs(mAttrs.ObjectType.IdentAttribute.Alias).Value
End Property

Private Property Get A2IObject_ObjectType() As A2IObjType
    Set A2IObject_ObjectType = mAttrs.ObjectType
End Property

Private Property Set A2IObject_System(RHS As A2System)
    If mSys Is Nothing Then
        Set mSys = RHS
    End If
End Property

Private Property Get A2IObject_System() As A2System
    Set A2IObject_System = mSys
End Property

Public Property Get UserName() As String
    UserName = mAttrs(OAA_USER_USERNAME).Value
End Property

Public Property Get TKSUserName() As String
    TKSUserName = mAttrs(OAA_USER_TKS_USERNAME).Value
End Property

'Public Const LTA_SET_USER_TKS_NAME As String = "SetUserTKSName"
'    Public Const LTPA_SET_USER_TKS_NAME_USER As String = "user"
'    Public Const LTPA_SET_USER_TKS_NAME_TO As String = "tksUserName"

Public Property Let TKSUserName(iNewName As String)

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_SET_USER_TKS_NAME)
Dim gopUser As A2GetObjParm

Dim gopUsername As A2GetObjParm, gopDispName As A2GetObjParm, gopSortName As A2GetObjParm

Set gopUser.parm = lookup.Parameters(LTPA_SET_USER_TKS_NAME_USER)
Set gopUser.Val = Me

Set gopUsername.parm = lookup.Parameters(LTPA_SET_USER_TKS_NAME_TO)
 gopUsername.Val = iNewName

mSys.Execute Array(gopUser, gopUsername)
Me.Attributes.Refresh

End Property


Public Property Get UserType() As A2UserType
    Set UserType = mAttrs(OAA_USER_TYPE).Value
End Property

Public Property Get Employee() As A2Employee
    Set Employee = mAttrs(OAA_USER_EMP).Value
End Property

Public Property Get DisplayName() As String
    DisplayName = mAttrs(OAA_USER_DISPLAY_NAME).Value
End Property

Public Property Get SortName() As String
    SortName = mAttrs(OAA_USER_SORT_NAME).Value
End Property

Public Property Get CanAlterSecurity() As Boolean
    CanAlterSecurity = mAttrs(OAA_USER_CAN_ALTER_SECURITY).Value
End Property

Public Property Get IsDisabled() As Boolean
    IsDisabled = mAttrs(OAA_USER_IS_DISABLED).Value
End Property

Public Property Get CanAlterOwnWatches() As Boolean
    CanAlterOwnWatches = mAttrs(OAA_USER_CAN_ALTER_OWN_WATCHES).Value
End Property

Public Property Let CanAlterSecurity(iCanAlter As Boolean)

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_SET_ADMIN_RIGHT)
Dim gopUser As A2GetObjParm, gopVal As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_SET_ADMIN_RIGHT_USER)
Set gopUser.Val = Me
Set gopVal.parm = lookup.Parameters(LTPA_SET_ADMIN_RIGHT_TO)
gopVal.parm = iCanAlter

mSys.Execute Array(gopUser, gopVal)
Me.Attributes.Refresh

End Property

Public Function GetProxies() As A2IObjSet

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_PROXIES_FOR_USER)
Dim gopUser As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_PROXIES_FOR_USER)
Set gopUser.Val = Me

Set GetProxies = mSys.GetObjects(gopUser)

End Function

Public Sub AddProxy(iUser As A2User)

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_SET_PROXY)
Dim gopUserActing As A2GetObjParm, gopUserToActAs As A2GetObjParm, gopVal As A2GetObjParm
Set gopUserActing.parm = lookup.Parameters(LTPA_SET_PROXY_ACTING)
Set gopUserActing.Val = iUser
Set gopUserToActAs.parm = lookup.Parameters(LTPA_SET_PROXY_ACT_AS)
Set gopUserToActAs.Val = Me
Set gopVal.parm = lookup.Parameters(LTPA_SET_PROXY_CAN_ACT)
gopVal.parm = True

mSys.Execute Array(gopUserActing, gopUserToActAs, gopVal)

End Sub

Public Sub RemoveProxy(iUser As A2User)

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_SET_PROXY)
Dim gopUserActing As A2GetObjParm, gopUserToActAs As A2GetObjParm, gopVal As A2GetObjParm
Set gopUserActing.parm = lookup.Parameters(LTPA_SET_PROXY_ACTING)
Set gopUserActing.Val = iUser
Set gopUserToActAs.parm = lookup.Parameters(LTPA_SET_PROXY_ACT_AS)
Set gopUserToActAs.Val = Me
Set gopVal.parm = lookup.Parameters(LTPA_SET_PROXY_CAN_ACT)
gopVal.parm = False

mSys.Execute Array(gopUserActing, gopUserToActAs, gopVal)

End Sub

Public Function GetUsersProxyableAs() As A2IObjSet

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_PROXYABLE_BY_USER)
Dim gopUser As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_PROXYABLE_BY_USER)
Set gopUser.Val = Me

Set GetUsersProxyableAs = mSys.GetObjects(gopUser)
End Function

Public Function GetViewableEmployees() As A2IObjSet


Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_VIEWABLE_BY_SPEC_USER)
Dim gopUser As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_VIEWABLE_BY_SPEC_USER)
Set gopUser.Val = Me

Set GetViewableEmployees = mSys.GetObjects(gopUser)

End Function

Public Function GetAlterableEmployees() As A2IObjSet

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_ALTERABLE_BY_SPEC_USER)
Dim gopUser As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_ALTERABLE_BY_SPEC_USER)
Set gopUser.Val = Me

Set GetAlterableEmployees = mSys.GetObjects(gopUser)

End Function


Public Function GetWatchPreferences() As A2IObjSet
Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_GET_WATCH_PREFS_FOR_USER)
Dim gopUser As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_GET_WATCH_PREFS_FOR_USER)
Set gopUser.Val = Me

Set GetWatchPreferences = mSys.GetObjects(gopUser)

End Function

Public Function GetExtWatchPreferences() As A2IObjSet
Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_GET_EXT_WATCH_PREFS_FOR_USER)
Dim gopUser As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_GET_EXT_WATCH_PREFS_FOR_USER)
Set gopUser.Val = Me

Set GetExtWatchPreferences = mSys.GetObjects(gopUser)

End Function
Public Function GetWatchedEmployees() As A2IObjSet

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_WATCHED_BY_SPEC_USER)
Dim gopUser As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_WATCHED_BY_SPEC_USER)
Set gopUser.Val = Me

Set GetWatchedEmployees = mSys.GetObjects(gopUser)

End Function

Public Sub StartWatchingEmployee(iEmp As A2Employee)

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_SET_WATCH)
Dim gopUser As A2GetObjParm, gopEmp As A2GetObjParm, gopVal As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_SET_WATCH_USER)
Set gopUser.Val = Me
Set gopEmp.parm = lookup.Parameters(LTPA_SET_WATCH_EMP)
Set gopEmp.Val = iEmp
Set gopVal.parm = lookup.Parameters(LTPA_SET_WATCH_TO)
gopVal.Val = True

mSys.Execute Array(gopUser, gopEmp, gopVal)

End Sub

Public Sub StopWatchingEmployee(iEmp As A2Employee)

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_SET_WATCH)
Dim gopUser As A2GetObjParm, gopEmp As A2GetObjParm, gopVal As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_SET_WATCH_USER)
Set gopUser.Val = Me
Set gopEmp.parm = lookup.Parameters(LTPA_SET_WATCH_EMP)
Set gopEmp.Val = iEmp
Set gopVal.parm = lookup.Parameters(LTPA_SET_WATCH_TO)
gopVal.Val = False

mSys.Execute Array(gopUser, gopEmp, gopVal)

End Sub

Public Sub GrantViewRight(iEmp As A2Employee)

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_SET_VIEW_RIGHT)
Dim gopUser As A2GetObjParm, gopEmp As A2GetObjParm, gopVal As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_SET_VIEW_RIGHT_USER)
Set gopUser.Val = Me
Set gopEmp.parm = lookup.Parameters(LTPA_SET_VIEW_RIGHT_EMP)
Set gopEmp.Val = iEmp
Set gopVal.parm = lookup.Parameters(LTPA_SET_VIEW_RIGHT_TO)
gopVal.Val = True

mSys.Execute Array(gopUser, gopEmp, gopVal)

End Sub

Public Sub RemoveViewRight(iEmp As A2Employee)

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_SET_VIEW_RIGHT)
Dim gopUser As A2GetObjParm, gopEmp As A2GetObjParm, gopVal As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_SET_VIEW_RIGHT_USER)
Set gopUser.Val = Me
Set gopEmp.parm = lookup.Parameters(LTPA_SET_VIEW_RIGHT_EMP)
Set gopEmp.Val = iEmp
Set gopVal.parm = lookup.Parameters(LTPA_SET_VIEW_RIGHT_TO)
gopVal.Val = False

mSys.Execute Array(gopUser, gopEmp, gopVal)

End Sub

Public Sub GrantAlterRight(iEmp As A2Employee)

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_SET_ALTER_RIGHT)
Dim gopUser As A2GetObjParm, gopEmp As A2GetObjParm, gopVal As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_SET_ALTER_RIGHT_USER)
Set gopUser.Val = Me
Set gopEmp.parm = lookup.Parameters(LTPA_SET_ALTER_RIGHT_EMP)
Set gopEmp.Val = iEmp
Set gopVal.parm = lookup.Parameters(LTPA_SET_ALTER_RIGHT_TO)
gopVal.Val = True

mSys.Execute Array(gopUser, gopEmp, gopVal)

End Sub

Public Sub RemoveAlterRight(iEmp As A2Employee)

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_SET_ALTER_RIGHT)
Dim gopUser As A2GetObjParm, gopEmp As A2GetObjParm, gopVal As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_SET_ALTER_RIGHT_USER)
Set gopUser.Val = Me
Set gopEmp.parm = lookup.Parameters(LTPA_SET_ALTER_RIGHT_EMP)
Set gopEmp.Val = iEmp
Set gopVal.parm = lookup.Parameters(LTPA_SET_ALTER_RIGHT_TO)
gopVal.Val = False

mSys.Execute Array(gopUser, gopEmp, gopVal)

End Sub


'Public Const LTA_SET_USER_DISABLED As String = "SetUserDisabled"
'    Public Const LTPA_SET_USER_DISABLED_USER As String = "user"
'    Public Const LTPA_SET_USER_DISABLED_TO As String = "isDisabled"


Public Sub Disable()

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_SET_USER_DISABLED)
Dim gopUser As A2GetObjParm, gopEmp As A2GetObjParm, gopVal As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_SET_USER_DISABLED_USER)
Set gopUser.Val = Me
Set gopVal.parm = lookup.Parameters(LTPA_SET_USER_DISABLED_TO)
gopVal.Val = True

mSys.Execute Array(gopUser, gopVal)
Me.Attributes.Refresh
End Sub

Public Sub Enable()

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_SET_USER_DISABLED)
Dim gopUser As A2GetObjParm, gopEmp As A2GetObjParm, gopVal As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_SET_USER_DISABLED_USER)
Set gopUser.Val = Me
Set gopVal.parm = lookup.Parameters(LTPA_SET_USER_DISABLED_TO)
gopVal.Val = False

mSys.Execute Array(gopUser, gopVal)
Me.Attributes.Refresh
End Sub


'Public Const LTA_SET_ALTER_WATCHES_RIGHT As String = "SetAlterWatchesRight"
'    Public Const LTPA_SET_ALTER_WATCHES_RIGHT_USER As String = "user"
'    Public Const LTPA_SET_ALTER_WATCHES_RIGHT_TO As String = "canAlter"


Public Property Let CanAlterOwnWatches(iCanAlter As Boolean)


Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_SET_ALTER_WATCHES_RIGHT)
Dim gopUser As A2GetObjParm, gopVal As A2GetObjParm
Set gopUser.parm = lookup.Parameters(LTPA_SET_ALTER_WATCHES_RIGHT_USER)
Set gopUser.Val = Me
Set gopVal.parm = lookup.Parameters(LTPA_SET_ALTER_WATCHES_RIGHT_TO)
gopVal.Val = iCanAlter

mSys.Execute Array(gopUser, gopVal)
Me.Attributes.Refresh


End Property

Public Property Let DisplayName(iNewDisplayName As String)

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_SET_USER_NAMES)
Dim gopUser As A2GetObjParm

Dim gopUsername As A2GetObjParm, gopDispName As A2GetObjParm, gopSortName As A2GetObjParm

Set gopUser.parm = lookup.Parameters(LTPA_SET_USER_NAMES_USER)
Set gopUser.Val = Me

Set gopUsername.parm = lookup.Parameters(LTPA_SET_USER_NAMES_USERNAME)
 gopUsername.Val = Me.UserName

Set gopDispName.parm = lookup.Parameters(LTPA_SET_USER_NAMES_DISPNAME)
 gopDispName.Val = iNewDisplayName

Set gopSortName.parm = lookup.Parameters(LTPA_SET_USER_NAMES_SORTNAME)
 gopSortName.Val = Me.SortName

mSys.Execute Array(gopUser, gopUsername, gopDispName, gopSortName)
Me.Attributes.Refresh
End Property

Public Property Let SortName(iNewSortName As String)


Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_SET_USER_NAMES)
Dim gopUser As A2GetObjParm

Dim gopUsername As A2GetObjParm, gopDispName As A2GetObjParm, gopSortName As A2GetObjParm

Set gopUser.parm = lookup.Parameters(LTPA_SET_USER_NAMES_USER)
Set gopUser.Val = Me

Set gopUsername.parm = lookup.Parameters(LTPA_SET_USER_NAMES_USERNAME)
 gopUsername.Val = Me.UserName

Set gopDispName.parm = lookup.Parameters(LTPA_SET_USER_NAMES_DISPNAME)
 gopDispName.Val = Me.DisplayName

Set gopSortName.parm = lookup.Parameters(LTPA_SET_USER_NAMES_SORTNAME)
 gopSortName.Val = iNewSortName

mSys.Execute Array(gopUser, gopUsername, gopDispName, gopSortName)
Me.Attributes.Refresh
End Property

Public Property Let UserName(iNewUsername As String)


Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_SET_USER_NAMES)
Dim gopUser As A2GetObjParm

Dim gopUsername As A2GetObjParm, gopDispName As A2GetObjParm, gopSortName As A2GetObjParm

Set gopUser.parm = lookup.Parameters(LTPA_SET_USER_NAMES_USER)
Set gopUser.Val = Me

Set gopUsername.parm = lookup.Parameters(LTPA_SET_USER_NAMES_USERNAME)
 gopUsername.Val = iNewUsername

Set gopDispName.parm = lookup.Parameters(LTPA_SET_USER_NAMES_DISPNAME)
 gopDispName.Val = Me.DisplayName

Set gopSortName.parm = lookup.Parameters(LTPA_SET_USER_NAMES_SORTNAME)
 gopSortName.Val = Me.SortName

mSys.Execute Array(gopUser, gopUsername, gopDispName, gopSortName)
Me.Attributes.Refresh

End Property

Public Sub ChangePassword(iOldPassword As String, iNewPassword As String)

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_CHANGE_PASSWORD)
Dim gop1 As A2GetObjParm, gop2 As A2GetObjParm
Set gop1.parm = lookup.Parameters(LTPA_CHANGE_PASSWORD_FROM)
 gop1.Val = mSys.GetPassword(iOldPassword)
Set gop2.parm = lookup.Parameters(LTPA_CHANGE_PASSWORD_TO)
gop2.Val = mSys.GetPassword(iNewPassword)

mSys.Execute Array(gop1, gop2)
Me.Attributes.Refresh
End Sub

Public Sub ResetPassword(iNewPassword As String)

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_RESET_PASSWORD)
Dim gop1 As A2GetObjParm, gop2 As A2GetObjParm
Set gop1.parm = lookup.Parameters(LTPA_RESET_PASSWORD_USER)
Set gop1.Val = Me
Set gop2.parm = lookup.Parameters(LTPA_RESET_PASSWORD_TO)
gop2.Val = mSys.GetPassword(iNewPassword)

mSys.Execute Array(gop1, gop2)
Me.Attributes.Refresh
End Sub

Public Sub RegenerateWatches()

Dim lookup As A2ILookupType
Set lookup = mSys.LookupTypes(LTA_REGEN_WATCH_PREFS_FOR_USER)
Dim gop1 As A2GetObjParm
Set gop1.parm = lookup.Parameters(LTPA_REGEN_WATCH_PREFS_FOR_USER)
Set gop1.Val = Me

mSys.Execute gop1

End Sub

Public Property Get EmailEnabled() As Boolean
    EmailEnabled = mAttrs(OAA_USER_EMAIL_ENABLED).Value
End Property

Public Property Let EmailEnabled(i As Boolean)
    SetEmailOptions i, Me.EmailAddress, Me.OpenNotifEmailThreshold, Me.OpenDisEmailThreshold
End Property

Public Property Get EmailAddress() As String
    EmailAddress = mAttrs(OAA_USER_EMAIL_ADDRESS).Value
End Property

Public Property Let EmailAddress(i As String)
    SetEmailOptions Me.EmailEnabled, i, Me.OpenNotifEmailThreshold, Me.OpenDisEmailThreshold
End Property

Public Property Get OpenNotifEmailThreshold() As Long
    OpenNotifEmailThreshold = mAttrs(OAA_USER_OPEN_NOTIF_EMAIL_DAYS).Value
End Property

Public Property Let OpenNotifEmailThreshold(i As Long)
    SetEmailOptions Me.EmailEnabled, Me.EmailAddress, i, Me.OpenDisEmailThreshold
End Property

Public Property Get OpenDisEmailThreshold() As Long
    OpenDisEmailThreshold = mAttrs(OAA_USER_OPEN_DIS_EMAIL_DAYS).Value
End Property

Public Property Let OpenDisEmailThreshold(i As Long)
    SetEmailOptions Me.EmailEnabled, Me.EmailAddress, Me.OpenNotifEmailThreshold, i
End Property

Private Sub SetEmailOptions(iIsEnabled As Boolean, iAddress As String, _
        iNotifDays As Long, iDisDays As Long)


    Dim lookup As A2ILookupType
    Set lookup = mSys.LookupTypes(LTA_SET_EMAIL_OPTIONS)
    
    Dim gopUser As A2GetObjParm
    Dim gopEnabled As A2GetObjParm
    Dim gopAddress As A2GetObjParm
    Dim gopNotifDays As A2GetObjParm
    Dim gopDisDays As A2GetObjParm
    
    Set gopUser.parm = lookup.Parameters(LTPA_SET_EMAIL_OPTIONS_USER)
    Set gopEnabled.parm = lookup.Parameters(LTPA_SET_EMAIL_OPTIONS_ENABLED)
    Set gopAddress.parm = lookup.Parameters(LTPA_SET_EMAIL_OPTIONS_ADDRESS)
    Set gopNotifDays.parm = lookup.Parameters(LTPA_SET_EMAIL_OPTIONS_NOTIF_DAYS)
    Set gopDisDays.parm = lookup.Parameters(LTPA_SET_EMAIL_OPTIONS_DIS_DAYS)
    
    Set gopUser.Val = Me
    gopEnabled.Val = iIsEnabled
    gopAddress.Val = iAddress
    gopNotifDays.Val = iNotifDays
    gopDisDays.Val = iDisDays
    
    mSys.Execute Array(gopUser, gopEnabled, gopAddress, gopNotifDays, gopDisDays)
    Me.Attributes.Refresh

End Sub

' Add A2IObject methods to the default interface for convenience of users (esp VBScript)
Public Property Get Attributes() As A2IObjAttrs: Set Attributes = A2IObject_Attributes: End Property
Public Property Get Identifier() As Variant: Identifier = A2IObject_Identifier: End Property
Public Property Get AsA2IObject() As A2IObject: Set AsA2IObject = A2IObject_AsA2IObject: End Property
Public Property Get AsIDefault() As Object: Set AsIDefault = A2IObject_AsIDefault: End Property
Public Property Get AsIDispatch() As Object: Set AsIDispatch = A2IObject_AsIDispatch: End Property
Public Property Get ObjectType() As A2IObjType: Set ObjectType = A2IObject_ObjectType: End Property
Public Property Get System() As A2System: Set System = A2IObject_System: End Property

