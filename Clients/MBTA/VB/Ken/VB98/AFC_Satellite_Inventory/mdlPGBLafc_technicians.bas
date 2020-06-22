Attribute VB_Name = "mdlPGBLafc_technicians"
 
Option Explicit
'
' These are Public Temporary Variables and Their Data Types. For table: afc_technicians
 
 
    Public tAT_ID As Long
    Public tAT_Empno As Long
    Public tAT_Password As String
    Public tAT_Branch As Long
    Public tAT_EmpLName As String
    Public tAT_EmpFname As String
    Public tAT_Access_level As Long
    Public tAT_CellPhone As String
 
 
' this section of code is a Public SubRoutine
' it probably should be placed in a Form or module...
 
 
Public Sub PGBLinsertintoafc_technicians()
' in this subroutine the Insert into afc_technicians
'   logic is found..  Please note that all fields are first checked
'    for a single quote and re-formated for SQL

 

    tAT_ID = Replace(tAT_ID, "'", "''")
    tAT_Empno = Replace(tAT_Empno, "'", "''")
    tAT_Password = Replace(tAT_Password, "'", "''")
    tAT_Branch = Replace(tAT_Branch, "'", "''")
    tAT_EmpLName = Replace(tAT_EmpLName, "'", "''")
    tAT_EmpFname = Replace(tAT_EmpFname, "'", "''")
    tAT_Access_level = Replace(tAT_Access_level, "'", "''")
    tAT_CellPhone = Replace(tAT_CellPhone, "'", "''")



sSql = "Insert into afc_technicians" _
  & "(AT_Empno,AT_Password,at_branch,AT_EmpLName,AT_EmpFname,AT_Access_level,AT_CellPhone)" _
  & "Values (" & "'" & tAT_Empno & "'" & ",encryptbypassphrase('blind','Today')," & tAT_Branch & ",'" & tAT_EmpLName & "'" & "," & "'" & tAT_EmpFname & "'" & "," & tAT_Access_level & "," & "'" & tAT_CellPhone & "'" & ")"
 
End Sub
 
 
' ++++   FIRST OPTIONAL   ++++
 
' this section of code was generated in case you needed it
' it is the temp fields that you will populate with your data...
' somewhere inside your program, probably just before the call
'  to the subroutine to insert...
 
 
 
 
Public Sub PGBLDummyInitTVars_afc_technicians()
' **** This should be commented out*******
' in this subroutine Initilization of the temp Variablesfor afc_technicians
'   logic is found..
 
 
'    tAT_ID =
'    tAT_Empno =
'    tAT_Password =
'    tAT_EmpLName =
'    tAT_EmpFname =
'    tAT_Access_level =
'    tAT_CellPhone =
 
End Sub
 
 
' this section of code is a Public SubRoutine
' it probably should be placed in a Form or module...
 
 
Public Sub PGBLUpdateafc_technicians()
' in this subroutine the Update afc_technicians
'   logic is found..  Please note that all fields are first checked
'    for a single quote and re-formated for SQL

  

    tAT_ID = Replace(tAT_ID, "'", "''")
    tAT_Empno = Replace(tAT_Empno, "'", "''")
    tAT_Password = Replace(tAT_Password, "'", "''")
    tAT_Branch = Replace(tAT_Branch, "'", "''")
    tAT_EmpLName = Replace(tAT_EmpLName, "'", "''")
    tAT_EmpFname = Replace(tAT_EmpFname, "'", "''")
    tAT_Access_level = Replace(tAT_Access_level, "'", "''")
    tAT_CellPhone = Replace(tAT_CellPhone, "'", "''")


'now we format the Update sub routine here


sSql = "Update afc_technicians set " _
  & "at_branch = " & tAT_Branch & ", AT_Empno = " & tAT_Empno & " , AT_EmpLName = " & "'" & tAT_EmpLName & "'" & " , " _
  & "AT_EmpFname = " & "'" & tAT_EmpFname & "'" & " , AT_Access_level = " & tAT_Access_level & " , AT_CellPhone = " & "'" & tAT_CellPhone & "'"

End Sub
 
 
 
Public Sub PGBLInitTVars_afc_technicians()
' This Subroutine will Initialize the Public Temporary Variables to Default
'       type Values for: afc_technicians
'
 
 
    tAT_ID = 0
    tAT_Empno = " "
    tAT_Password = " "
    tAT_EmpLName = " "
    tAT_EmpFname = " "
    tAT_Access_level = 0
    tAT_CellPhone = " "
 
End Sub
 
 
 
 
Public Sub PGBLRecToTemp_afc_technicians(ByVal RmsDb As Object)
' This subroutine will load the Temporary Variables from the
'    Record Set Data. The Record Set Name is passed to it..
 
 
    tAT_ID = IIf(IsNull(RmsDb("AT_ID")) = True, "", RmsDb("AT_ID"))
    tAT_Empno = IIf(IsNull(RmsDb("AT_Empno")) = True, "", RmsDb("AT_Empno"))
    tAT_EmpLName = IIf(IsNull(RmsDb("AT_EmpLName")) = True, "", RmsDb("AT_EmpLName"))
    tAT_EmpFname = IIf(IsNull(RmsDb("AT_EmpFname")) = True, "", RmsDb("AT_EmpFname"))
    tAT_Access_level = IIf(IsNull(RmsDb("AT_Access_level")) = True, "", RmsDb("AT_Access_level"))
    tAT_CellPhone = IIf(IsNull(RmsDb("AT_CellPhone")) = True, "", RmsDb("AT_CellPhone"))
 
End Sub
 
 
 
Public Function PGBLAddOrChange_afc_technicians(ByVal RmsDb As Object, ByVal UpdMode As String) As String
' This Function will either AddNew for Inserts into or
'             will change Table afc_technicians
'   The RecordSet Name Used is Passed in the First Parameter, and
'        the Mode Type (A=AddNew or U=Just an Update) in the Second Parameter ..
'        What gets returned is 0 for clean function or N + error description
Dim myerror As String
Dim mydescript As String
 On Error GoTo addorchangeerror_afc_technicians
 
 If UpdMode = "A" Or UpdMode = "U" Then
   Else
     MsgBox "Invalid Mode Type being passed to AddOrChange Subroutine...  Must be A or U"
     Exit Function
 End If
 
 'Now let's check for the Update mode Specified and do the right thing.
   If UpdMode = "A" Then
       RmsDb.AddNew
   End If
 
    RmsDb("AT_Empno") = tAT_Empno
    RmsDb("AT_EmpLName") = tAT_EmpLName
    RmsDb("AT_EmpFname") = tAT_EmpFname
    RmsDb("AT_Access_level") = tAT_Access_level
    RmsDb("AT_CellPhone") = tAT_CellPhone
 
    RmsDb.Update
    PGBLAddOrChange_afc_technicians = "0"
Exit Function
 
addorchangeerror_afc_technicians:
 
    myerror = Err.Number
    mydescript = Err.Description
    PGBLAddOrChange_afc_technicians = "10 The Actual Error Number:" & myerror & " Error Description:" & mydescript
 
Exit Function
 
 
 
 
 
' End of AddNew Function
End Function
 
 
 
Public Sub PGBLPrintFieldValues_afc_technicians()
' This section of code was generated in case you needed it
' it will print the Temporary Field Name then Its Data Value..
 
 
 
Print #7, "tAT_ID :"; tAT_ID
Print #7, "tAT_Empno :"; tAT_Empno
Print #7, "tAT_Password :"; tAT_Password
Print #7, "tAT_EmpLName :"; tAT_EmpLName
Print #7, "tAT_EmpFname :"; tAT_EmpFname
Print #7, "tAT_Access_level :"; tAT_Access_level
Print #7, "tAT_CellPhone :"; tAT_CellPhone
 
End Sub
