Attribute VB_Name = "mdlPGBLAFC_WorkBench"
 
Option Explicit
'
' These are Public Temporary Variables and Their Data Types. For table: AFC_WorkBench
 
 
    Public tAWB_Id As Long
    Public tAWB_Partno As Long
    Public tAWB_Serialno As String
    Public tAWB_Location As Long
    Public tAWB_Date_collected As Date
    Public tAWB_Verified As String
    Public tAWB_Date_Sent As Date
    Public tAWB_Date_Back As Date
    Public tAWB_AltSerialno As String
    Public tAWB_Selected As String
    Public tAWB_Notes As String
    Public tAWB_Fleet_Swap As String
    Public tAWB_Work_Branch As Long
    
 
 
' this section of code is a Public SubRoutine
' it probably should be placed in a Form or module...
 
 
Public Sub PGBLinsertintoAFC_WorkBench()
' in this subroutine the Insert into AFC_WorkBench
'   logic is found..  Please note that all fields are first checked
'    for a single quote and re-formated for SQL

 


    tAWB_Partno = Replace(tAWB_Partno, "'", "''")
    tAWB_Serialno = Replace(tAWB_Serialno, "'", "''")
    tAWB_Location = Replace(tAWB_Location, "'", "''")
    tAWB_Date_collected = Replace(tAWB_Date_collected, "'", "''")
    tAWB_Date_Sent = Replace(tAWB_Date_Sent, "'", "''")
    tAWB_Date_Back = Replace(tAWB_Date_Back, "'", "''")
    tAWB_AltSerialno = Replace(tAWB_AltSerialno, "'", "''")
    tAWB_Selected = Replace(tAWB_Selected, "'", "''")
    tAWB_Notes = Replace(tAWB_Notes, "'", "''")
    tAWB_Fleet_Swap = Replace(tAWB_Fleet_Swap, "'", "''")
    tAWB_Work_Branch = Replace(tAWB_Work_Branch, "'", "''")



sSql = "Insert into AFC_WorkBench" _
  & "(AWB_Partno,AWB_Serialno,AWB_Location,AWB_Date_collected,AWB_Verified,AWB_Date_Sent,AWB_Date_Back,AWB_AltSerialno,AWB_Selected,AWB_Work_Branch,awb_fleet_swap,AWB_Notes)" _
  & "Values (" & tAWB_Partno & "," & "'" & tAWB_Serialno & "'" & "," & tAWB_Location & "," & "'" & tAWB_Date_collected & "'" & ",'" & tAWB_Verified & "','" & tAWB_Date_Sent & "'" & "," & "'" & tAWB_Date_Back & "'" & "," & "'" & tAWB_AltSerialno & "'" & "," _
  & "'" & tAWB_Selected & "'" & "," & tAWB_Work_Branch & ",'" & tAWB_Fleet_Swap & "','" & tAWB_Notes & "'" & ")"
End Sub
 
 
' ++++   FIRST OPTIONAL   ++++
 
' this section of code was generated in case you needed it
' it is the temp fields that you will populate with your data...
' somewhere inside your program, probably just before the call
'  to the subroutine to insert...
 
 
 
 
Public Sub PGBLDummyInitTVars_AFC_WorkBench()
' **** This should be commented out*******
' in this subroutine Initilization of the temp Variablesfor AFC_WorkBench
'   logic is found..
 
 
'    tAWB_Id =
'    tAWB_Partno =
'    tAWB_Serialno =
'    tAWB_Location =
'    tAWB_Date_collected =
'    tAWB_Date_Sent =
'    tAWB_Date_Back =
'    tAWB_AltSerialno =
'    tAWB_Selected =
'    tAWB_Notes =
 
End Sub
 
 
' this section of code is a Public SubRoutine
' it probably should be placed in a Form or module...
 
 
Public Sub PGBLUpdateAFC_WorkBench()
' in this subroutine the Update AFC_WorkBench
'   logic is found..  Please note that all fields are first checked
'    for a single quote and re-formated for SQL

  

    tAWB_Id = Replace(tAWB_Id, "'", "''")
    tAWB_Partno = Replace(tAWB_Partno, "'", "''")
    tAWB_Serialno = Replace(tAWB_Serialno, "'", "''")
    tAWB_Location = Replace(tAWB_Location, "'", "''")
    tAWB_Date_collected = Replace(tAWB_Date_collected, "'", "''")
    tAWB_Date_Sent = Replace(tAWB_Date_Sent, "'", "''")
    tAWB_Date_Back = Replace(tAWB_Date_Back, "'", "''")
    tAWB_AltSerialno = Replace(tAWB_AltSerialno, "'", "''")
    tAWB_Selected = Replace(tAWB_Selected, "'", "''")
    tAWB_Work_Branch = Replace(tAWB_Work_Branch, "'", "''")
    tAWB_Fleet_Swap = Replace(tAWB_Fleet_Swap, "'", "''")
    tAWB_Notes = Replace(tAWB_Notes, "'", "''")


'now we format the Update sub routine here


sSql = "Update AFC_WorkBench set " _
  & "AWB_Partno = " & tAWB_Partno & " , AWB_Serialno = " & "'" & tAWB_Serialno & "'" & " , AWB_Location = " & tAWB_Location & " , " _
  & "AWB_Date_collected = " & "'" & tAWB_Date_collected & "'" & " ,awb_verified = '" & tAWB_Verified & "', AWB_Date_Sent = " & "'" & tAWB_Date_Sent & "'" & " , AWB_Date_Back = " & "'" & tAWB_Date_Back & "'" & " , AWB_AltSerialno = " & "'" & tAWB_AltSerialno & "'" & " , " _
  & "AWB_Selected = " & "'" & tAWB_Selected & "'" & " , AWB_Work_Branch= " & tAWB_Work_Branch & ", awb_fleet_swap = '" & tAWB_Fleet_Swap & "', AWB_Notes = " & "'" & tAWB_Notes & "'" _
  & " Where "
 
End Sub
 
 
 
Public Sub PGBLInitTVars_AFC_WorkBench()
' This Subroutine will Initialize the Public Temporary Variables to Default
'       type Values for: AFC_WorkBench
'
 
 
    tAWB_Id = " "
    tAWB_Partno = 0
    tAWB_Serialno = " "
    tAWB_Location = 0
    tAWB_Date_collected = " "
    tAWB_Date_Sent = " "
    tAWB_Date_Back = " "
    tAWB_AltSerialno = " "
    tAWB_Selected = " "
    tAWB_Work_Branch = 0
    tAWB_Fleet_Swap = ""
    tAWB_Notes = " "
 
End Sub
 
 
 
 
Public Sub PGBLRecToTemp_AFC_WorkBench(ByVal RmsDb As Object)
' This subroutine will load the Temporary Variables from the
'    Record Set Data. The Record Set Name is passed to it..
 
 
    tAWB_Id = IIf(IsNull(RmsDb("AWB_Id")) = True, 0, RmsDb("AWB_Id"))
    tAWB_Partno = IIf(IsNull(RmsDb("AWB_Partno")) = True, 0, RmsDb("AWB_Partno"))
    tAWB_Serialno = IIf(IsNull(RmsDb("AWB_Serialno")) = True, "", RmsDb("AWB_Serialno"))
    tAWB_Location = IIf(IsNull(RmsDb("AWB_Location")) = True, 0, RmsDb("AWB_Location"))
    tAWB_Date_collected = IIf(IsNull(RmsDb("AWB_Date_collected")) = True, "", RmsDb("AWB_Date_collected"))
    tAWB_Date_Sent = IIf(IsNull(RmsDb("AWB_Date_Sent")) = True, "", RmsDb("AWB_Date_Sent"))
    tAWB_Date_Back = IIf(IsNull(RmsDb("AWB_Date_Back")) = True, "", RmsDb("AWB_Date_Back"))
    tAWB_AltSerialno = IIf(IsNull(RmsDb("AWB_AltSerialno")) = True, "", RmsDb("AWB_AltSerialno"))
    tAWB_Selected = IIf(IsNull(RmsDb("AWB_Selected")) = True, "", RmsDb("AWB_Selected"))
    tAWB_Work_Branch = IIf(IsNull(RmsDb("AWB_work_branch")) = True, "", RmsDb("AWB_Work_Branch"))
    tAWB_Fleet_Swap = IIf(IsNull(RmsDb("AWB_fleet-swap")) = True, 0, RmsDb("AWB_Work_Branch"))
    tAWB_Notes = IIf(IsNull(RmsDb("AWB_Notes")) = True, "", RmsDb("AWB_Notes"))
 
End Sub
 
 
 
Public Function PGBLAddOrChange_AFC_WorkBench(ByVal RmsDb As Object, ByVal UpdMode As String) As String
' This Function will either AddNew for Inserts into or
'             will change Table AFC_WorkBench
'   The RecordSet Name Used is Passed in the First Parameter, and
'        the Mode Type (A=AddNew or U=Just an Update) in the Second Parameter ..
'        What gets returned is 0 for clean function or N + error description
Dim myerror As String
Dim mydescript As String
 On Error GoTo addorchangeerror_AFC_WorkBench
 
 If UpdMode = "A" Or UpdMode = "U" Then
   Else
     MsgBox "Invalid Mode Type being passed to AddOrChange Subroutine...  Must be A or U"
     Exit Function
 End If
 
 'Now let's check for the Update mode Specified and do the right thing.
   If UpdMode = "A" Then
       RmsDb.AddNew
   End If
 

    RmsDb("AWB_Partno") = tAWB_Partno
    RmsDb("AWB_Serialno") = tAWB_Serialno
    RmsDb("AWB_Location") = tAWB_Location
    RmsDb("AWB_Date_collected") = tAWB_Date_collected
    RmsDb("AWB_Date_Sent") = tAWB_Date_Sent
    RmsDb("AWB_Date_Back") = tAWB_Date_Back
    RmsDb("AWB_AltSerialno") = tAWB_AltSerialno
    RmsDb("AWB_Selected") = tAWB_Selected
    RmsDb("AWB_Notes") = tAWB_Notes
 
    RmsDb.Update
    PGBLAddOrChange_AFC_WorkBench = "0"
Exit Function
 
addorchangeerror_AFC_WorkBench:
 
    myerror = Err.Number
    mydescript = Err.Description
    PGBLAddOrChange_AFC_WorkBench = "10 The Actual Error Number:" & myerror & " Error Description:" & mydescript
 
Exit Function
 
 
 
 
 
' End of AddNew Function
End Function
 
 
 
Public Sub PGBLPrintFieldValues_AFC_WorkBench()
' This section of code was generated in case you needed it
' it will print the Temporary Field Name then Its Data Value..
 
 
 
Print #7, "tAWB_Id :"; tAWB_Id
Print #7, "tAWB_Partno :"; tAWB_Partno
Print #7, "tAWB_Serialno :"; tAWB_Serialno
Print #7, "tAWB_Location :"; tAWB_Location
Print #7, "tAWB_Date_collected :"; tAWB_Date_collected
Print #7, "tAWB_Date_Sent :"; tAWB_Date_Sent
Print #7, "tAWB_Date_Back :"; tAWB_Date_Back
Print #7, "tAWB_AltSerialno :"; tAWB_AltSerialno
Print #7, "tAWB_Selected :"; tAWB_Selected
Print #7, "tAWB_Notes :"; tAWB_Notes
 
End Sub
