Attribute VB_Name = "Module1"
Option Explicit

Public Function DoLDAP()

Dim con
Dim command
Dim rs
Dim dso
Dim cont
Dim path
Dim user

' The following path is the right search base for normal people, i.e. people
' with data in the PDB.

'ADsPath = "LDAP://ldap.rutgers.edu/ou=People,dc=rutgers,dc=edu"
Dim ADsPath As String
'ADsPath = "LDAP://mbtaportal.mbta.com/"
ADsPath = "NDS://MBTA_TREE/O=MBTA/OU=45_HIGH_ST/OU=PLANNING/CN=AJV6412"

' The following magic creates and opens a connection to the LDAP server.
' The userid and password should be replaced with the service DN and
' password that you are issued for your service.  You might check it
' using your NetID as xxxx and your password as yyyy. That won't let you
' see all the data, but it will let you start making sure this works.
' The flag of 34 means to use SSL (which we require for any connection
' that sends passwords) and "fast bind".  Note that in LDAP when you
' login, it wants a full dn, not just a username.

Set con = CreateObject("ADODB.Connection")
con.Provider = "ADsDSOObject"
con.Properties("User ID") = "uid=AJV6412,o=MBTA"
con.Properties("Password") = "yxgd229"
con.Properties("ADSI Flag") = 34

con.Open "ADSI"

' OK, now we're going to do 3 things: search for a user by uid (i.e. netid),
' check their password, and print some data that came from the directory.
Dim com As ADODB.command

Set com = CreateObject("ADODB.Command")
Set com.ActiveConnection = con

' Make up an LDAP query. the format is
' <ldap://ldap.rutgers.edu/ou=people,dc=rutgers,dc=edu>;(query);attrs;subtree
' The first defines the LDAP search base
' Then you have the actual query, using the usual LDAP filter format
'    to look for someone by netid it is (uid=xxxx)
' attrs is a list of the attributes you want to be returned.
'    You'll want to see the DN itself. Unfortunately they don't give you the
'    actual DN. They give you the "adspath".  E.g. if the dn is
'    uid=hedrick,ou=people,dc=rutgers,dc=edu, they return an adspath of
'    ldap://ldap.rutgers.edu/uid=hedrick,ou=people,dc=rutgers,dc=edu
' So the following query looks up a person by uid, and gets the
'   adspath, cn and postaladdress.  "netid" and "password" are presumed
'   to be supplied by the user.

'com.CommandText = "<" & ADsPath & ">;(uid=ajv6412);Adspath,cn,postaladdress,rulinkRutgersEduIID;subtree"
com.CommandText = "<" & ADsPath & ">;(ou=45_HIGH_ST);cn;"
Set rs = com.Execute


' Now you have to decide what to do with the results.  It's returned as
' a result set, in this case rs. Several entries can match a query, although
' in this particular case there had better only be one person with a given netid.
' Anyway, you call rs.movenext to cycle through all the entries that matched
' your query. In the code below I look through all the entries, checking the
' password and displaying cn and postaladdress.  Of course there should be
' only one entry in this case, but I thought you'd want to see how to process more
' general queries, e.g. (cn=*hedrick*), which might return more than one entry.


While Not (rs.EOF)
 path = rs.Fields("ADsPath")
 'results.AddItem path
 Debug.Print path

' Ok, we have to convert the adspath to a DN, because password checking
' is done with a DN and password. Look for the last / and take everything
' after it. What we're trying to do here is set "user" to be the DN
' for the user. That's what we'll use to check the user's password.

 user = InStrRev(path, "/")
 user = Mid(path, user + 1)
 'results.AddItem user
 Debug.Print user

' This actually opens a new connection to check the user's password.
' This opens the connection, checks the password, and doesn't do
' anything else. "user" is actually the dn that we got after looking
' up the user. As usual 34 means to do SSL and fast bind.

 Set dso = GetObject("LDAP:")
 Set cont = dso.OpenDSObject(ADsPath, "ajv6412", "yxgd229", 34)

' See if the user's password worked. If not print error message

 If Err.Number <> 0 Then
 Debug.Print Err.Description
 Else
 Debug.Print "Password OK"
 End If
 Err.Clear

' Now show three of the attributes
' Note that the IID is single-valued, so you don't want the (0).
' ADSI checks the schema to see which attributes are multivalued,
' and returns arrays only for them.
Wend
End Function


Sub EnumNDSObjects(serverName As String, userName As String, password As String)
    ' Bind to the provider.
    Dim dso
    Dim cont
    Dim obj
    Set dso = GetObject("NDS:")
    
    ' For the NDS provider, the flag is set to 0 because secure authentication
    ' is provided by default.
    Set cont = dso.OpenDSObject("NDS://" + serverName, userName, password, 0)
    
    ' Enumerate the server objects.
    For Each obj In cont
        Debug.Print obj.Name & " (" & obj.Class & ")"
    Next
End Sub

Sub SetUserSurname(ADsPath As String, newSurname As String, userName As String, password As String)
    ' Bind to the provider.
    Dim dso, usr
    Set dso = GetObject("NDS:")
    
    ' Bind to the user object.
    Set usr = dso.OpenDSObject(ADsPath, userName, password, 0)
    
    ' Display the current surname.
    Debug.Print usr.Get("Surname")
    
    ' Modify the surname in the local cache.
    usr.Put "Surname", newSurname
    
    ' Commit the change to the server.
    usr.SetInfo
End Sub

Sub SearchNDSForUser(ADsPath As String, surname As String, userName As String, password As String)
    ' Create the ADO object.
    Dim con As ADODB.Connection
    Dim com As ADODB.command
    Dim rs As ADODB.Recordset
    Set con = CreateObject("ADODB.Connection")
    
    ' Initialize the ADO object.
    con.Provider = "ADsDSOObject"
    con.Properties("User ID") = userName
    con.Properties("Password") = password
    con.Open "ADSI"
     
    ' Create the ADO command object.
    Set com = CreateObject("ADODB.Command")
    
    ' Set the command object's connection to the ADO object.
    Set com.ActiveConnection = con
    com.CommandText = "SELECT ADsPath, 'Object Class' FROM '" & ADsPath & "' WHERE Surname=" & surname
    
    ' Execute the query.
    Set rs = com.Execute
     
    ' Enumerate the results.
    While Not (rs.EOF)
       Debug.Print rs.Fields("ADsPath")
       rs.MoveNext
    Wend
End Sub

Sub b1()
Dim x As IADs
Dim Desc As IADsSecurityDescriptor
On Error GoTo ErrTest:
 
'Set x = GetObject("LDAP://CN=Administrator,CN=Users,DC=Fabrikam,DC=com")
Set x = GetObject("NDS://MBTA_TREE/.PLANNING.45_HIGH_ST.MBTA")
 
' Single-valued properties.
Debug.Print "Home Phone Number is: " & x.Get("Surname")
 
 
Exit Sub
 
ErrTest:
  Debug.Print Hex(Err.Number)
  Set x = Nothing
  Set Desc = Nothing

End Sub
