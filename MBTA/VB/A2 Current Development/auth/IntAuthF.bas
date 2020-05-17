Attribute VB_Name = "IntAuthF"

Public Static Function IsValid(iUsername As String, iPassword As String) As Boolean

Dim dir As NWIDir
Dim entry As NWEntry
Dim results As NWEntries
Dim Check As Boolean

Set dir = New NWIDir

dir.FullName = "ldap://mbtaportal.mbta.com/o=MBTA"
dir.Connect
dir.Filter = "(cn=" & iUsername & ")"
dir.Fields = "cn, givenName, surname"
dir.SearchScope = dirSearchSubtree
dir.TimeLimit = 4
dir.MaximumResults = 2
Set results = dir.Search
IsValid = False
If Not results.Count = 1 Then
    IsValid = False
Else
    Set entry = results.Item(0)
    Check = entry.ValidatePassword(iPassword)
    IsValid = Check
End If

End Function

