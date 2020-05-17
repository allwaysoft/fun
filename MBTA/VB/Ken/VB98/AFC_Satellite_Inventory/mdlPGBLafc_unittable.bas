Attribute VB_Name = "mdlPGBLafc_unittable"
 
Option Explicit
'
' These are Public Temporary Variables and Their Data Types. For table: afc_unittable
 
 
    Public tAU_Index As Long
    Public tAU_Partno As Long
    Public tAU_MBTAno As String
    Public tAU_Serialno As String
    Public tAU_DateRolledOut As Date
    Public tAU_Location As Long
    Public tAU_Moved As String
    Public tAU_RST As String
    Public tAU_Condition As Long
    Public tAU_StateFunding As Long
    Public tAU_FederalFunding As Long
 
 
' this section of code is a Public SubRoutine
' it probably should be placed in a Form or module...
 
 
Public Sub PGBLinsertintoafc_unittable()
' in this subroutine the Insert into afc_unittable
'   logic is found..  Please note that all fields are first checked
'    for a single quote and re-formated for SQL

 

    tAU_Partno = Replace(tAU_Partno, "'", "''")
    tAU_MBTAno = Replace(tAU_MBTAno, "'", "''")
    tAU_Serialno = Replace(tAU_Serialno, "'", "''")
    tAU_DateRolledOut = Replace(tAU_DateRolledOut, "'", "''")
    tAU_Location = Replace(tAU_Location, "'", "''")
    tAU_Moved = Replace(tAU_Moved, "'", "''")
    tAU_RST = Replace(tAU_RST, "'", "''")
    tAU_Condition = Replace(tAU_Condition, "'", "''")
    tAU_StateFunding = Replace(tAU_StateFunding, "'", "''")
    tAU_FederalFunding = Replace(tAU_FederalFunding, "'", "''")



sSql = "Insert into afc_unittable" _
  & "(AU_Partno,AU_MBTAno,AU_Serialno,AU_DateRolledOut,AU_Location,AU_Moved,AU_RST,AU_Condition,AU_StateFunding,AU_FederalFunding)" _
  & "Values (" & tAU_Partno & "," & "'" & tAU_MBTAno & "'" & "," & "'" & tAU_Serialno & "'" & "," & "'" & tAU_DateRolledOut & "'" & "," & tAU_Location & "," & "'" & tAU_Moved & "'" & "," & "'" & tAU_RST & "'" & "," _
  & tAU_Condition & "," & tAU_StateFunding & "," & tAU_FederalFunding & ")"
 
End Sub
 
 
' ++++   FIRST OPTIONAL   ++++
 
' this section of code was generated in case you needed it
' it is the temp fields that you will populate with your data...
' somewhere inside your program, probably just before the call
'  to the subroutine to insert...
 
 
 
 
Public Sub PGBLDummyInitTVars_afc_unittable()
' **** This should be commented out*******
' in this subroutine Initilization of the temp Variablesfor afc_unittable
'   logic is found..
 
 
'    tAU_Index =
'    tAU_Partno =
'    tAU_MBTAno =
'    tAU_Serialno =
'    tAU_DateRolledOut =
'    tAU_Location =
'    tAU_Moved =
'    tAU_RST =
'    tAU_Condition =
'    tAU_StateFunding =
'    tAU_FederalFunding =
 
End Sub
 
 
' this section of code is a Public SubRoutine
' it probably should be placed in a Form or module...
 
 
Public Sub PGBLUpdateafc_unittable()
' in this subroutine the Update afc_unittable
'   logic is found..  Please note that all fields are first checked
'    for a single quote and re-formated for SQL

  

    tAU_Partno = Replace(tAU_Partno, "'", "''")
    tAU_MBTAno = Replace(tAU_MBTAno, "'", "''")
    tAU_Serialno = Replace(tAU_Serialno, "'", "''")
    tAU_DateRolledOut = Replace(tAU_DateRolledOut, "'", "''")
    tAU_Location = Replace(tAU_Location, "'", "''")
    tAU_Moved = Replace(tAU_Moved, "'", "''")
    tAU_RST = Replace(tAU_RST, "'", "''")
    tAU_Condition = Replace(tAU_Condition, "'", "''")
    tAU_StateFunding = Replace(tAU_StateFunding, "'", "''")
    tAU_FederalFunding = Replace(tAU_FederalFunding, "'", "''")


'now we format the Update sub routine here


sSql = "Update afc_unittable set " _
  & " AU_Partno = " & tAU_Partno & " , AU_MBTAno = " & "'" & tAU_MBTAno & "'" & " , AU_Serialno = " & "'" & tAU_Serialno & "'" & " , " _
  & "AU_DateRolledOut = " & "'" & tAU_DateRolledOut & "'" & " , AU_Location = " & tAU_Location & " , AU_Moved = " & "'" & tAU_Moved & "'" & " , AU_RST = " & "'" & tAU_RST & "'" & " , " _
  & "AU_Condition = " & tAU_Condition & " , AU_StateFunding = " & tAU_StateFunding & " , AU_FederalFunding = " & tAU_FederalFunding
 
End Sub
 
 
 
Public Sub PGBLInitTVars_afc_unittable()
' This Subroutine will Initialize the Public Temporary Variables to Default
'       type Values for: afc_unittable
'
 
 
    tAU_Index = " "
    tAU_Partno = 0
    tAU_MBTAno = " "
    tAU_Serialno = " "
    tAU_DateRolledOut = " "
    tAU_Location = 0
    tAU_Moved = " "
    tAU_RST = " "
    tAU_Condition = 0
    tAU_StateFunding = 0
    tAU_FederalFunding = 0
 
End Sub
 
 
 
 
Public Sub PGBLRecToTemp_afc_unittable(ByVal RmsDb As Object)
' This subroutine will load the Temporary Variables from the
'    Record Set Data. The Record Set Name is passed to it..
 
 
    tAU_Index = IIf(IsNull(RmsDb("AU_Index")) = True, "", RmsDb("AU_Index"))
    tAU_Partno = IIf(IsNull(RmsDb("AU_Partno")) = True, 0, RmsDb("AU_Partno"))
    tAU_MBTAno = IIf(IsNull(RmsDb("AU_MBTAno")) = True, "", RmsDb("AU_MBTAno"))
    tAU_Serialno = IIf(IsNull(RmsDb("AU_Serialno")) = True, "", RmsDb("AU_Serialno"))
    tAU_DateRolledOut = IIf(IsNull(RmsDb("AU_DateRolledOut")) = True, "", RmsDb("AU_DateRolledOut"))
    tAU_Location = IIf(IsNull(RmsDb("AU_Location")) = True, 0, RmsDb("AU_Location"))
    tAU_Moved = IIf(IsNull(RmsDb("AU_Moved")) = True, "", RmsDb("AU_Moved"))
    tAU_RST = IIf(IsNull(RmsDb("AU_RST")) = True, "", RmsDb("AU_RST"))
    tAU_Condition = IIf(IsNull(RmsDb("AU_Condition")) = True, 0, RmsDb("AU_Condition"))
    tAU_StateFunding = IIf(IsNull(RmsDb("AU_StateFunding")) = True, 0, RmsDb("AU_StateFunding"))
    tAU_FederalFunding = IIf(IsNull(RmsDb("AU_FederalFunding")) = True, 0, RmsDb("AU_FederalFunding"))
 
End Sub
 
 
 
Public Function PGBLAddOrChange_afc_unittable(ByVal RmsDb As Object, ByVal UpdMode As String) As String
' This Function will either AddNew for Inserts into or
'             will change Table afc_unittable
'   The RecordSet Name Used is Passed in the First Parameter, and
'        the Mode Type (A=AddNew or U=Just an Update) in the Second Parameter ..
'        What gets returned is 0 for clean function or N + error description
Dim myerror As String
Dim mydescript As String
 On Error GoTo addorchangeerror_afc_unittable
 
 If UpdMode = "A" Or UpdMode = "U" Then
   Else
     MsgBox "Invalid Mode Type being passed to AddOrChange Subroutine...  Must be A or U"
     Exit Function
 End If
 
 'Now let's check for the Update mode Specified and do the right thing.
   If UpdMode = "A" Then
       RmsDb.AddNew
   End If
 
    RmsDb("AU_Index") = tAU_Index
    RmsDb("AU_Partno") = tAU_Partno
    RmsDb("AU_MBTAno") = tAU_MBTAno
    RmsDb("AU_Serialno") = tAU_Serialno
    RmsDb("AU_DateRolledOut") = tAU_DateRolledOut
    RmsDb("AU_Location") = tAU_Location
    RmsDb("AU_Moved") = tAU_Moved
    RmsDb("AU_RST") = tAU_RST
    RmsDb("AU_Condition") = tAU_Condition
    RmsDb("AU_StateFunding") = tAU_StateFunding
    RmsDb("AU_FederalFunding") = tAU_FederalFunding
 
    RmsDb.Update
    PGBLAddOrChange_afc_unittable = "0"
Exit Function
 
addorchangeerror_afc_unittable:
 
    myerror = Err.Number
    mydescript = Err.Description
    PGBLAddOrChange_afc_unittable = "10 The Actual Error Number:" & myerror & " Error Description:" & mydescript
 
Exit Function
 
 
 
 
 
' End of AddNew Function
End Function
 
 
 
Public Sub PGBLPrintFieldValues_afc_unittable()
' This section of code was generated in case you needed it
' it will print the Temporary Field Name then Its Data Value..
 
 
 
Print #7, "tAU_Index :"; tAU_Index
Print #7, "tAU_Partno :"; tAU_Partno
Print #7, "tAU_MBTAno :"; tAU_MBTAno
Print #7, "tAU_Serialno :"; tAU_Serialno
Print #7, "tAU_DateRolledOut :"; tAU_DateRolledOut
Print #7, "tAU_Location :"; tAU_Location
Print #7, "tAU_Moved :"; tAU_Moved
Print #7, "tAU_RST :"; tAU_RST
Print #7, "tAU_Condition :"; tAU_Condition
Print #7, "tAU_StateFunding :"; tAU_StateFunding
Print #7, "tAU_FederalFunding :"; tAU_FederalFunding
 
End Sub
