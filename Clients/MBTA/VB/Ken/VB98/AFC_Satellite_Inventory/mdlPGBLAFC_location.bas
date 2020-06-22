Attribute VB_Name = "mdlPGBLAFC_Location"
 
Option Explicit
'
' These are Public Temporary Variables and Their Data Types. For table: AFC_Location
 
 
    Public tAL_ID As Long
    Public tAL_Abrv As String
    Public tAL_Location_Name As String
    Public tAL_Location_type As Long
    Public tAL_Line As Long
    Public tAL_Maint_Section As Integer
    Public tAL_PM_Section As Integer
 
 
' this section of code is a Public SubRoutine
' it probably should be placed in a Form or module...
 
 
Public Sub PGBLinsertintoAFC_Location()
' in this subroutine the Insert into AFC_Location
'   logic is found..  Please note that all fields are first checked
'    for a single quote and re-formated for SQL

 
    tAL_Abrv = Replace(tAL_Abrv, "'", "''")
    tAL_Location_Name = Replace(tAL_Location_Name, "'", "''")
    tAL_Location_type = Replace(tAL_Location_type, "'", "''")
    tAL_Line = Replace(tAL_Line, "'", "''")
    tAL_Maint_Section = Replace(tAL_Maint_Section, "'", "''")
    tAL_PM_Section = Replace(tAL_PM_Section, "'", "''")



sSql = "Insert into AFC_Location" _
  & "(AL_Abrv,AL_Location_Name,AL_Location_type,AL_Line, AL_Maint_Section, AL_PM_Section)" _
  & "Values (" & "'" & tAL_Abrv & "'" & "," & "'" & tAL_Location_Name & "'" & "," & tAL_Location_type & "," & tAL_Line & "," & tAL_Maint_Section & "," & tAL_PM_Section & ")"
 
End Sub
 
 
' ++++   FIRST OPTIONAL   ++++
 
' this section of code was generated in case you needed it
' it is the temp fields that you will populate with your data...
' somewhere inside your program, probably just before the call
'  to the subroutine to insert...
 
 
 
 
Public Sub PGBLDummyInitTVars_AFC_Location()
' **** This should be commented out*******
' in this subroutine Initilization of the temp Variablesfor AFC_Location
'   logic is found..
 
 
'    tAL_ID =
'    tAL_Abrv =
'    tAL_Location_Name =
'    tAL_Location_type =
'    tAL_Line =
 
End Sub
 
 
' this section of code is a Public SubRoutine
' it probably should be placed in a Form or module...
 
 
Public Sub PGBLUpdateAFC_Location()
' in this subroutine the Update AFC_Location
'   logic is found..  Please note that all fields are first checked
'    for a single quote and re-formated for SQL

  
    tAL_Abrv = Replace(tAL_Abrv, "'", "''")
    tAL_Location_Name = Replace(tAL_Location_Name, "'", "''")
    tAL_Location_type = Replace(tAL_Location_type, "'", "''")
    tAL_Line = Replace(tAL_Line, "'", "''")
    tAL_Maint_Section = Replace(tAL_Maint_Section, "'", "''")
    tAL_PM_Section = Replace(tAL_PM_Section, "'", "''")


'now we format the Update sub routine here


sSql = "Update AFC_Location set " _
  & "AL_Abrv = " & "'" & tAL_Abrv & "'" & " , AL_Location_Name = " & "'" & tAL_Location_Name & "'" & " , AL_Location_type = " & tAL_Location_type & " , " _
  & "AL_Line = " & tAL_Line & ", AL_Maint_Section = " & tAL_Maint_Section & ", AL_PM_Section = " & tAL_PM_Section
 
End Sub
 
 
 
Public Sub PGBLInitTVars_AFC_Location()
' This Subroutine will Initialize the Public Temporary Variables to Default
'       type Values for: AFC_Location
'
 
 
    tAL_ID = 0
    tAL_Abrv = " "
    tAL_Location_Name = " "
    tAL_Location_type = 0
    tAL_Line = 0
    tAL_Maint_Section = 0
    tAL_PM_Section = 0
End Sub
 
 
 
 
Public Sub PGBLRecToTemp_AFC_Location(ByVal RmsDb As Object)
' This subroutine will load the Temporary Variables from the
'    Record Set Data. The Record Set Name is passed to it..
 
 
    tAL_ID = IIf(IsNull(RmsDb("AL_ID")) = True, "", RmsDb("AL_ID"))
    tAL_Abrv = IIf(IsNull(RmsDb("AL_Abrv")) = True, "", RmsDb("AL_Abrv"))
    tAL_Location_Name = IIf(IsNull(RmsDb("AL_Location_Name")) = True, "", RmsDb("AL_Location_Name"))
    tAL_Location_type = IIf(IsNull(RmsDb("AL_Location_type")) = True, 0, RmsDb("AL_Location_type"))
    tAL_Line = IIf(IsNull(RmsDb("AL_Line")) = True, 0, RmsDb("AL_Line"))
    tAL_Maint_Section = IIf(IsNull(RmsDb("AL_Maint_Section")) = True, 0, RmsDb("AL_Maint_Section"))
    tAL_PM_Section = IIf(IsNull(RmsDb("AL_PM_Section")) = True, 0, RmsDb("AL_PM_Section"))
 
End Sub
 
 
 
Public Function PGBLAddOrChange_AFC_Location(ByVal RmsDb As Object, ByVal UpdMode As String) As String
' This Function will either AddNew for Inserts into or
'             will change Table AFC_Location
'   The RecordSet Name Used is Passed in the First Parameter, and
'        the Mode Type (A=AddNew or U=Just an Update) in the Second Parameter ..
'        What gets returned is 0 for clean function or N + error description
Dim myerror As String
Dim mydescript As String
 On Error GoTo addorchangeerror_AFC_Location
 
 If UpdMode = "A" Or UpdMode = "U" Then
   Else
     MsgBox "Invalid Mode Type being passed to AddOrChange Subroutine...  Must be A or U"
     Exit Function
 End If
 
 'Now let's check for the Update mode Specified and do the right thing.
   If UpdMode = "A" Then
       RmsDb.AddNew
   End If
 

    RmsDb("AL_Abrv") = tAL_Abrv
    RmsDb("AL_Location_Name") = tAL_Location_Name
    RmsDb("AL_Location_type") = tAL_Location_type
    RmsDb("AL_Line") = tAL_Line
 
    RmsDb.Update
    PGBLAddOrChange_AFC_Location = "0"
Exit Function
 
addorchangeerror_AFC_Location:
 
    myerror = Err.Number
    mydescript = Err.Description
    PGBLAddOrChange_AFC_Location = "10 The Actual Error Number:" & myerror & " Error Description:" & mydescript
 
Exit Function
 
 
 
 
 
' End of AddNew Function
End Function
 
 
 
Public Sub PGBLPrintFieldValues_AFC_Location()
' This section of code was generated in case you needed it
' it will print the Temporary Field Name then Its Data Value..
 
 
 
Print #7, "tAL_ID :"; tAL_ID
Print #7, "tAL_Abrv :"; tAL_Abrv
Print #7, "tAL_Location_Name :"; tAL_Location_Name
Print #7, "tAL_Location_type :"; tAL_Location_type
Print #7, "tAL_Line :"; tAL_Line
 
End Sub
