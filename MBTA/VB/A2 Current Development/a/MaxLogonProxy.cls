VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MaxLogonProxy"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Private Const PROXY_USERNAME As String = "MAXLOGON"
Private Const PROXY_PASSWORD As String = "bzr923"
Private Const MAXIMUS_USERNAME As String = "emsapp"
Private Const MAXIMUS_PASSWORD As String = "emsapp"
Private Const MAXIMUS_CONN_STRING As String = "Provider=OraOLEDB.Oracle;Data Source=fap;"

Public Function GetA2App(iServer As A2IDataSource, iUsername As String, ixPassword As String) As MaxLogonResult
    Dim iPassword As String
    iPassword = Defang(ixPassword)

    Dim proxyA2App As A2App
    Dim usersA2App As A2App
    Dim maxDbConn As ADODB.Connection
    Dim maxRst As ADODB.Recordset
    Dim maximusUnavailable As Boolean
    
    Dim logonResult As MaxLogonResult
    Set logonResult = New MaxLogonResult
    
    Dim oUser As A2User
    
    ' connect to maximus
    Set maxDbConn = New ADODB.Connection
    On Error Resume Next
    Err.Clear
    maximusUnavailable = False
    maxDbConn.Open MAXIMUS_CONN_STRING, MAXIMUS_USERNAME, MAXIMUS_PASSWORD
    If Err.Number <> 0 Then
        ' maximus unavailable
        Err.Clear
        maximusUnavailable = True
    End If
    On Error GoTo 0

    ' check username & password against Maximus
    If maximusUnavailable = False Then
    
        Set maxRst = New ADODB.Recordset
        maxRst.Open "SELECT USR_USERID, PASSWORD FROM USR_MAIN WHERE USR_USERID='" & UCase(iUsername) & "'", maxDbConn
        
        If maxRst.EOF Then
            ' user doesn't exist in maximus
            
            Set usersA2App = New A2App
            On Error Resume Next
            Err.Clear
            usersA2App.Logon iServer, iUsername, iPassword
            If Err.Number <> 0 Then
            
                ' not OK in opstech either
                Set logonResult.AppObj = Nothing
                logonResult.LogonSuccessful = False
                logonResult.ValidForReporting = False
                logonResult.BadMaximusPassword = False
                logonResult.OpsTechPasswordReset = False
            Else
                ' user exists and OK in opstech, but not in maximus at all
                Set logonResult.AppObj = usersA2App
                logonResult.LogonSuccessful = True
                logonResult.ValidForReporting = False
                logonResult.BadMaximusPassword = False
                logonResult.OpsTechPasswordReset = False
            End If
            On Error GoTo 0
            
        Else
            ' user exists in maximus
            If LCase("" & iPassword) = LCase("" & maxRst.Fields(1).Value) Then
                ' password matches in maximus
                    
                    On Error Resume Next
                    Err.Clear
                    Set usersA2App = New A2App
                    usersA2App.Logon iServer, iUsername, iPassword
                    If Err.Number <> 0 Then
    
                        ' password needs to be reset in opstech (OK in maximus)
                        usersA2App.Logoff
                        Set usersA2App = Nothing
                        
                        Set proxyA2App = New A2App
                        proxyA2App.Logon iServer, PROXY_USERNAME, PROXY_PASSWORD

                        Set oUser = GetUserByName(proxyA2App, iUsername)
                        oUser.ResetPassword iPassword
                        
                        Err.Clear
                        Set oUser = Nothing
                        proxyA2App.Logoff
                        Set proxyA2App = Nothing
                        
                        Set usersA2App = New A2App
                        usersA2App.Logon iServer, iUsername, iPassword
                        
                        If Err.Number <> 0 Then
                            ' password could not be reset
                            Set logonResult.AppObj = Nothing
                            logonResult.LogonSuccessful = False
                            logonResult.ValidForReporting = False
                            logonResult.BadMaximusPassword = False
                            logonResult.OpsTechPasswordReset = False
                        Else
                            ' password reset and logged on
                            Set logonResult.AppObj = usersA2App
                            logonResult.LogonSuccessful = True
                            logonResult.ValidForReporting = True
                            logonResult.BadMaximusPassword = False
                            logonResult.OpsTechPasswordReset = True
                        End If
                        
                    Else
                        ' user OK both places
                        Set logonResult.AppObj = usersA2App
                        logonResult.LogonSuccessful = True
                        logonResult.ValidForReporting = True
                        logonResult.BadMaximusPassword = False
                        logonResult.OpsTechPasswordReset = False
                    End If
                    
                    On Error GoTo 0
            Else
                ' password doesn't match in maximus
                Set usersA2App = New A2App
                On Error Resume Next
                Err.Clear
                usersA2App.Logon iServer, iUsername, iPassword
                If Err.Number <> 0 Then
                    ' password not ok in either
                    
                    Set logonResult.AppObj = Nothing
                    logonResult.LogonSuccessful = False
                    logonResult.ValidForReporting = False
                    logonResult.BadMaximusPassword = False
                    logonResult.OpsTechPasswordReset = False
                Else
                    ' user OK in opstech but not OK in Maximus --
                    Set logonResult.AppObj = usersA2App
                    logonResult.LogonSuccessful = True
                    logonResult.ValidForReporting = False
                    logonResult.BadMaximusPassword = True
                    logonResult.OpsTechPasswordReset = False
                End If
            End If
        End If
    
    Else ' maximus unavailable:
    
        Set usersA2App = New A2App
        On Error Resume Next
        Err.Clear
        usersA2App.Logon iServer, iUsername, iPassword
        If Err.Number <> 0 Then
        
            ' not OK in OpsTech
            Set logonResult.AppObj = Nothing
            logonResult.LogonSuccessful = False
            logonResult.ValidForReporting = False
            logonResult.BadMaximusPassword = False
            logonResult.OpsTechPasswordReset = False
        Else
            '  OK in opstech
            Set logonResult.AppObj = usersA2App
            logonResult.LogonSuccessful = True
            logonResult.ValidForReporting = False
            logonResult.BadMaximusPassword = False
            logonResult.OpsTechPasswordReset = False
        End If
        On Error GoTo 0

    End If
    
    maxRst.Close
    maxDbConn.Close
    Set GetA2App = logonResult
    
End Function

Private Function GetUserByName(oApp As A2App, iUsername As String) As A2User

    Dim lookup As A2ILookupType
    
    Set lookup = oApp.System.LookupTypes("GetUserByUsername")
    Dim parm As A2GetObjParm
    Set parm.parm = lookup.Parameters("username")
    parm.Val = iUsername
    
    Set GetUserByName = oApp.System.GetObject(oApp.System.ObjectTypes("User"), parm)

End Function

Private Function Defang(iString As String) As String
    Defang = iString
    Defang = Replace(Defang, "'", "")
    Defang = Replace(Defang, """", "")
    Defang = Replace(Defang, "--", "")
    Defang = Replace(Defang, "/", "")
    Defang = Replace(Defang, "#", "")
    Defang = Replace(Defang, "+", "")
    Defang = Replace(Defang, "]", "")
    Defang = Replace(Defang, "[", "")
    Defang = Replace(Defang, ";", "")
End Function
