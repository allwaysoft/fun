VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Class1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Implements A2IAuthenticator
Private Const LDAP_SERVER As String = "ldap://mbtaportal.mbta.com/o=MBTA"
Private Const AUTH_TIMEOUT As Long = 5

Private Function A2IAuthenticator_CheckLogon(iUsername As String, iPassword As String) As A2AuthResult

    Dim oAuthResult As A2AuthResult
    Dim oDir As NWIDir
    Dim oSearchResults As NWEntries
    Dim oLDAPUserObject As NWEntry
    Dim usernameFixed As String
    
    'usernameFixed = Defang(iUsername)
    usernameFixed = iUsername
    Set oDir = New NWIDir
    Set oAuthResult = New A2AuthResult
    
    With oDir
        .FullName = LDAP_SERVER
        .Connect
        .Filter = "(cn=" & usernameFixed & ")"
        .Fields = "cn"
        .SearchScope = dirSearchSubtree
        .TimeLimit = AUTH_TIMEOUT
        .MaximumResults = 2
    End With
    
    Set oSearchResults = Nothing
    Set oSearchResults = oDir.Search
    If oSearchResults Is Nothing Then
        oAuthResult.LogonSuccessful = False
    Else
        If Not oSearchResults.Count = 1 Then
            oAuthResult.LogonSuccessful = False
        Else
            Set oLDAPUserObject = oSearchResults.Item(0)
            If oLDAPUserObject.ValidatePassword(iPassword) = True Then
                '... actual forced logon + local password reset happens here
            Else
                oAuthResult.LogonSuccessful = False
            End If
        End If
    End If
    
    Set A2IAuthenticator_CheckLogon = oAuthResult

End Function
