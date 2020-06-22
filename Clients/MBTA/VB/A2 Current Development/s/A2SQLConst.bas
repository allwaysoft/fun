Attribute VB_Name = "A2SQLConst"
Option Explicit

'Public cntCreated As Long


Public Const OTA_OBJ_TYPE As String = "ObjType"
Public Const OTA_OBJ_ATTR As String = "ObjAttr"
Public Const OTA_FIND_TYPE As String = "FindType"
Public Const OTA_FIND_TYPE_PARM As String = "FindTypeParm"
Public Const OTA_KEY_TYPE As String = "KeyType"
Public Const OTA_KEY_TYPE_PARM As String = "KeyTypeParm"

Public Const OTA_USER As String = "User"

Public Const DEFAULT_ODBC As String = "Attend2SQLDS"

Public Const DB_USERNAME As String = "A2SQLUser"
Public Const DB_PASSWORD As String = "bzr923"

Public Const USERNAME_LENGTH As Integer = 8
Public Const PASSWORD_LENGTH As Integer = 32

Public Const CACHE_SECS_DEFAULT As Long = 30
Public CACHE_SECS As Long

Public Const CACHE_OBJ_MAX_DEFAULT As Long = 3000
Public CACHE_OBJ_MAX As Long

Public Const FUNCT_CURRENT_USER_ID As String = "dbo.GetCurrentUserId()"

Public Const PROC_LOGON As String = "a2_DoLogon"
Public Const PROC_LOGON_USERNAME As String = "@userNameParm"
Public Const PROC_LOGON_PASSWORD As String = "@passwordParm"

Public Const PROC_LOGONPROXY As String = "a2_LogonAsProxy"
Public Const PROC_LOGONPROXY_USERNAME As String = "@userNameParm"
Public Const PROC_LOGONPROXY_PASSWORD As String = "@passwordParm"
Public Const PROC_LOGONPROXY_PROXY_USERNAME As String = "@proxyUserName"

Public Const PROC_OBJ_TYPE As String = "a2_GetObjectTypes"
Public Const PROC_OBJ_ATTR As String = "a2_GetAttrsForObjType"
Public Const PARM_PROC_OBJ_ATTR As String = "@ObjTypeIdParm"

Public Const PROC_ALL_OBJ_ATTR As String = "a2_GetAllObjAttrs"

Public Const PROC_LOOKUP_TYPES As String = "a2_GetLookupTypes"
Public Const PROC_LOOKUP_TYPE_PARMS As String = "a2_GetParmsForLookupType"
Public Const PARM_LOOKUP_TYPE_PARMS_ID As String = "@LookupTypeIdParm"

Public Const PROC_ALL_LOOKUP_PARMS As String = "a2_GetAllLookupParms"

Public Const FLD_LOOKUP_TYPE_SYSKEY As Integer = 0
Public Const FLD_LOOKUP_TYPE_ID As Integer = 1
Public Const FLD_LOOKUP_TYPE_ALIAS As Integer = 2
Public Const FLD_LOOKUP_TYPE_DESC As Integer = 3
Public Const FLD_LOOKUP_TYPE_COMMAND As Integer = 4
Public Const FLD_LOOKUP_TYPE_OBJTYPEID As Integer = 5
Public Const FLD_LOOKUP_TYPE_ISUNIQUE As Integer = 6
Public Const FLD_LOOKUP_TYPE_RETURNS_IDENT As Integer = 7
Public Const FLD_LOOKUP_TYPE_NO_RETURN As Integer = 8

Public Const FLD_LOOKUP_PARM_SYSKEY As Integer = 0
Public Const FLD_LOOKUP_PARM_ID As Integer = 1
Public Const FLD_LOOKUP_PARM_KEYTYPEID As Integer = 2
Public Const FLD_LOOKUP_PARM_ALIAS As Integer = 3
Public Const FLD_LOOKUP_PARM_SEQ As Integer = 4
Public Const FLD_LOOKUP_PARM_DESC As Integer = 5
Public Const FLD_LOOKUP_PARM_PARAMNAME As Integer = 6
Public Const FLD_LOOKUP_PARM_DATATYPE As Integer = 7
Public Const FLD_LOOKUP_PARM_REFOBJTYPEID As Integer = 8
Public Const FLD_LOOKUP_PARM_IS_IDENT_OUTPUT As Integer = 9

Public Const FLD_OBJ_TYPE_SYSKEY As Integer = 0
Public Const FLD_OBJ_TYPE_ID As Integer = 1
Public Const FLD_OBJ_TYPE_ENUM As Integer = 2
Public Const FLD_OBJ_TYPE_DESC As Integer = 3
Public Const FLD_OBJ_TYPE_SHORT_DESC As Integer = 4
Public Const FLD_OBJ_TYPE_IDENT_PROC As Integer = 5
Public Const FLD_OBJ_TYPE_ALIAS As Integer = 6
Public Const FLD_OBJ_TYPE_INS_UPD_VIEW As Integer = 7

Public Const FLD_ATTR_SYSKEY As Integer = 0
Public Const FLD_ATTR_ID As Integer = 1
Public Const FLD_ATTR_OBJTYPEID As Integer = 2
Public Const FLD_ATTR_SHORT_NAME As Integer = 3
Public Const FLD_ATTR_LONG_NAME As Integer = 4
Public Const FLD_ATTR_FIELD_NAME As Integer = 5
Public Const FLD_ATTR_DATA_TYPE As Integer = 6
Public Const FLD_ATTR_OBJ_REF_OBJ_TYPE_ID As Integer = 7
Public Const FLD_ATTR_IS_NULLABLE As Integer = 8
Public Const FLD_ATTR_SEQUENCE As Integer = 9
Public Const FLD_ATTR_IS_GUID As Integer = 10
Public Const FLD_ATTR_IS_IDENTITY As Integer = 11
Public Const FLD_ATTR_ALIAS As Integer = 12


Public Const PARM_DEFAULT_IDENT_PROC As String = "@IdentParm"

Public Const PARM_OUTPUT_IDENT As String = "@IdentOut"
