Attribute VB_Name = "mdlPGBLafc_phyreceipt"
 
Option Explicit
'
' These are Public Temporary Variables and Their Data Types. For table: afc_phyreceipt
 
 
    Public tAPR_Index As Long
    Public tAPR_Location As Long
    Public tAPR_Partno As Long
    Public tAPR_Qty As Long
    Public tAPR_Trantype As String
    Public tAPR_Exsists As String
    Public tAPR_Empno As Long
    Public tAPR_Machine As String
    Public tAPR_First4 As String
    Public tAPR_PackList As Long
    Public tAPR_Setteling As String
 
 
' this section of code is a Public SubRoutine
' it probably should be placed in a Form or module...
 
 
Public Sub PGBLinsertintoafc_phyreceipt()
' in this subroutine the Insert into afc_phyreceipt
'   logic is found..  Please note that all fields are first checked
'    for a single quote and re-formated for SQL

 

    tAPR_Location = Replace(tAPR_Location, "'", "''")
    tAPR_Partno = Replace(tAPR_Partno, "'", "''")
    tAPR_Qty = Replace(tAPR_Qty, "'", "''")
    tAPR_Trantype = Replace(tAPR_Trantype, "'", "''")
    tAPR_Exsists = Replace(tAPR_Exsists, "'", "''")
    tAPR_Empno = Replace(tAPR_Empno, "'", "''")
    tAPR_Machine = Replace(tAPR_Machine, "'", "''")
    tAPR_First4 = Replace(tAPR_First4, "'", "''")
    tAPR_PackList = Replace(tAPR_PackList, "'", "''")
    tAPR_Setteling = Replace(tAPR_Setteling, "'", "''")



sSql = "Insert into afc_phyreceipt" _
  & "(APR_Location,APR_Partno,APR_Qty,APR_Trantype,APR_Exsists,APR_Empno,APR_Machine,APR_First4,APR_PackList, Apr_Setteling)" _
  & "Values (" & tAPR_Location & "," & tAPR_Partno & "," & tAPR_Qty & "," & "'" & tAPR_Trantype & "'" & "," & "'" & tAPR_Exsists & "'" & "," & tAPR_Empno & "," & "'" & tAPR_Machine & "'" & "," & "'" & tAPR_First4 & "'" & "," & tAPR_PackList & ",'" & tAPR_Setteling & "')"
 
End Sub
 
 
' ++++   FIRST OPTIONAL   ++++
 
' this section of code was generated in case you needed it
' it is the temp fields that you will populate with your data...
' somewhere inside your program, probably just before the call
'  to the subroutine to insert...
 
 
 
 
Public Sub PGBLDummyInitTVars_afc_phyreceipt()
' **** This should be commented out*******
' in this subroutine Initilization of the temp Variablesfor afc_phyreceipt
'   logic is found..
 
 
'    tAPR_Index =
'    tAPR_Location =
'    tAPR_Partno =
'    tAPR_Qty =
'    tAPR_Trantype =
'    tAPR_Exsists =
'    tAPR_Empno =
'    tAPR_Machine =
 
End Sub
 
 
' this section of code is a Public SubRoutine
' it probably should be placed in a Form or module...
 
 
Public Sub PGBLUpdateafc_phyreceipt()
' in this subroutine the Update afc_phyreceipt
'   logic is found..  Please note that all fields are first checked
'    for a single quote and re-formated for SQL

  

    tAPR_Location = Replace(tAPR_Location, "'", "''")
    tAPR_Partno = Replace(tAPR_Partno, "'", "''")
    tAPR_Qty = Replace(tAPR_Qty, "'", "''")
    tAPR_Trantype = Replace(tAPR_Trantype, "'", "''")
    tAPR_Exsists = Replace(tAPR_Exsists, "'", "''")
    tAPR_Empno = Replace(tAPR_Empno, "'", "''")
    tAPR_Machine = Replace(tAPR_Machine, "'", "''")
    tAPR_First4 = Replace(tAPR_First4, "'", "''")
    tAPR_PackList = Replace(tAPR_PackList, "'", "''")
    tAPR_Setteling = Replace(tAPR_Setteling, "'", "''")


'now we format the Update sub routine here


sSql = "Update afc_phyreceipt set " _
  & "APR_Location = " & tAPR_Location & " , APR_Partno = " & "'" & tAPR_Partno & "'" & " , APR_Qty = " & tAPR_Qty & " , " _
  & "APR_Trantype = " & "'" & tAPR_Trantype & "'" & " , APR_Exsists = " & "'" & tAPR_Exsists & "'" & " , APR_Empno = " & tAPR_Empno & " , APR_Machine = " & "'" & tAPR_Machine & "', APR_first4 = " & "'" & tAPR_First4 & "'" & ", APR_packlist = " & tAPR_PackList & ", APR_Setteling = '" & tAPR_Setteling & "'"
  
End Sub
 
 
 
Public Sub PGBLInitTVars_afc_phyreceipt()
' This Subroutine will Initialize the Public Temporary Variables to Default
'       type Values for: afc_phyreceipt
'
 
 
    tAPR_Index = 0
    tAPR_Location = 0
    tAPR_Partno = " "
    tAPR_Qty = 0
    tAPR_Trantype = " "
    tAPR_Exsists = " "
    tAPR_Empno = 0
    tAPR_Machine = " "
    tAPR_First4 = " "
    tAPR_PackList = 0
    
End Sub
 
 
 
 
Public Sub PGBLRecToTemp_afc_phyreceipt(ByVal RmsDb As Object)
' This subroutine will load the Temporary Variables from the
'    Record Set Data. The Record Set Name is passed to it..
 
 
    tAPR_Index = IIf(IsNull(RmsDb("APR_Index")) = True, 0, RmsDb("APR_Index"))
    tAPR_Location = IIf(IsNull(RmsDb("APR_Location")) = True, 0, RmsDb("APR_Location"))
    tAPR_Partno = IIf(IsNull(RmsDb("APR_Partno")) = True, 0, RmsDb("APR_Partno"))
    tAPR_Qty = IIf(IsNull(RmsDb("APR_Qty")) = True, 0, RmsDb("APR_Qty"))
    tAPR_Trantype = IIf(IsNull(RmsDb("APR_Trantype")) = True, "", RmsDb("APR_Trantype"))
    tAPR_Exsists = IIf(IsNull(RmsDb("APR_Exsists")) = True, "", RmsDb("APR_Exsists"))
    tAPR_Empno = IIf(IsNull(RmsDb("APR_Empno")) = True, 0, RmsDb("APR_Empno"))
    tAPR_Machine = IIf(IsNull(RmsDb("APR_Machine")) = True, "", RmsDb("APR_Machine"))
    tAPR_First4 = IIf(IsNull(RmsDb("APR_first4")) = True, "", RmsDb("APR_first4"))
    tAPR_PackList = IIf(IsNull(RmsDb("APR_PackList")) = True, 0, RmsDb("APR_PackList"))
    tAPR_Setteling = IIf(IsNull(RmsDb("APR_setteling")) = True, 0, RmsDb("APR_setteling"))
 
End Sub
 
 
 
Public Function PGBLAddOrChange_afc_phyreceipt(ByVal RmsDb As Object, ByVal UpdMode As String) As String
' This Function will either AddNew for Inserts into or
'             will change Table afc_phyreceipt
'   The RecordSet Name Used is Passed in the First Parameter, and
'        the Mode Type (A=AddNew or U=Just an Update) in the Second Parameter ..
'        What gets returned is 0 for clean function or N + error description
Dim myerror As String
Dim mydescript As String
 On Error GoTo addorchangeerror_afc_phyreceipt
 
 If UpdMode = "A" Or UpdMode = "U" Then
   Else
     MsgBox "Invalid Mode Type being passed to AddOrChange Subroutine...  Must be A or U"
     Exit Function
 End If
 
 'Now let's check for the Update mode Specified and do the right thing.
   If UpdMode = "A" Then
       RmsDb.AddNew
   End If
 
    RmsDb("APR_Location") = tAPR_Location
    RmsDb("APR_Partno") = tAPR_Partno
    RmsDb("APR_Qty") = tAPR_Qty
    RmsDb("APR_Trantype") = tAPR_Trantype
    RmsDb("APR_Exsists") = tAPR_Exsists
    RmsDb("APR_Empno") = tAPR_Empno
    RmsDb("APR_Machine") = tAPR_Machine
    RmsDb("APR_first4") = tAPR_First4
    RmsDb("APR_packlist") = tAPR_PackList
 
    RmsDb.Update
    PGBLAddOrChange_afc_phyreceipt = "0"
Exit Function
 
addorchangeerror_afc_phyreceipt:
 
    myerror = Err.Number
    mydescript = Err.Description
    PGBLAddOrChange_afc_phyreceipt = "10 The Actual Error Number:" & myerror & " Error Description:" & mydescript
 
Exit Function
 
 
 
 
 
' End of AddNew Function
End Function
 
 
 
Public Sub PGBLPrintFieldValues_afc_phyreceipt()
' This section of code was generated in case you needed it
' it will print the Temporary Field Name then Its Data Value..
 
 
 
Print #7, "tAPR_Index :"; tAPR_Index
Print #7, "tAPR_Location :"; tAPR_Location
Print #7, "tAPR_Partno :"; tAPR_Partno
Print #7, "tAPR_Qty :"; tAPR_Qty
Print #7, "tAPR_Trantype :"; tAPR_Trantype
Print #7, "tAPR_Exsists :"; tAPR_Exsists
Print #7, "tAPR_Empno :"; tAPR_Empno
Print #7, "tAPR_Machine :"; tAPR_Machine
 
End Sub
