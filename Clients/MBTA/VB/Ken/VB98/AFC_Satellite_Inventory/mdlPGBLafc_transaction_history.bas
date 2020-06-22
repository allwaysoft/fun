Attribute VB_Name = "mdlPGBLAFC_Transaction_History"
 
Option Explicit
'
' These are Public Temporary Variables and Their Data Types. For table: AFC_Transaction_History
 
 
    Public tATH_index As Long
    Public tATH_Partno As Long
    Public tATH_Part_Serialno As String
    Public tATH_Empno As Long
    Public tATH_Machine As String
    Public tATH_Tran_type As Long
    Public tATH_Qty As Long
    Public tATH_Location As Long
    Public tATH_Tran_Location As Long
    Public tATH_Tran_Date As Date
    Public tATH_Time As Date
    Public tATH_CanDate As Date
    Public tATH_Closed As Byte
    Public tATH_First4 As String
    Public tATH_PackList As Long
    Public tATH_Comments As String
 
 
' this section of code is a Public SubRoutine
' it probably should be placed in a Form or module...
 
 
Public Sub PGBLinsertintoAFC_Transaction_History()
' in this subroutine the Insert into AFC_Transaction_History
'   logic is found..  Please note that all fields are first checked
'    for a single quote and re-formated for SQL

 

    tATH_Partno = Replace(tATH_Partno, "'", "''")
    tATH_Part_Serialno = Replace(tATH_Part_Serialno, "'", "''")
    tATH_Empno = Replace(tATH_Empno, "'", "''")
    tATH_Machine = Replace(tATH_Machine, "'", "''")
    tATH_Tran_type = Replace(tATH_Tran_type, "'", "''")
    tATH_Qty = Replace(tATH_Qty, "'", "''")
    tATH_Location = Replace(tATH_Location, "'", "''")
    tATH_Tran_Location = Replace(tATH_Tran_Location, "'", "''")
    tATH_Tran_Date = Replace(tATH_Tran_Date, "'", "''")
    tATH_Time = Replace(tATH_Time, "'", "''")
    tATH_Closed = Replace(tATH_Closed, "'", "''")
    tATH_First4 = Replace(tATH_First4, "'", "''")
    tATH_PackList = Replace(tATH_PackList, "'", "''")
    tATH_Comments = Replace(tATH_Comments, "'", "''")



sSql = "Insert into AFC_Transaction_History" _
  & "(ATH_Partno,ATH_Part_Serialno,ATH_Empno,ATH_Machine,ATH_Tran_type,ATH_Qty,ATH_Location,ATH_Tran_Location,ATH_Tran_Date,ATH_Time," _
  & "ATH_Closed,ath_first4,ATH_PackList,ATH_Comments)" _
  & "Values (" & tATH_Partno & "," & "'" & tATH_Part_Serialno & "'" & "," & tATH_Empno & "," & "'" & tATH_Machine & "'" & "," & tATH_Tran_type & "," & tATH_Qty & "," & tATH_Location & "," _
  & tATH_Tran_Location & "," & "'" & tATH_Tran_Date & "'" & "," & "'" & tATH_Time & "'" & "," & tATH_Closed & ", '" & tATH_First4 & "'," & tATH_PackList & ",'" & tATH_Comments & "')"
 
End Sub
 
 
' ++++   FIRST OPTIONAL   ++++
 
' this section of code was generated in case you needed it
' it is the temp fields that you will populate with your data...
' somewhere inside your program, probably just before the call
'  to the subroutine to insert...
 
 
 
 
Public Sub PGBLDummyInitTVars_AFC_Transaction_History()
' **** This should be commented out*******
' in this subroutine Initilization of the temp Variablesfor AFC_Transaction_History
'   logic is found..
 
 
'    tATH_index =
'    tATH_Partno =
'    tATH_Part_Serialno =
'    tATH_Empno =
'    tATH_Machine =
'    tATH_Tran_type =
'    tATH_Qty =
'    tATH_Location =
'    tATH_Tran_Location =
'    tATH_Tran_Date =
'    tATH_Time =
'    tATH_CanDate =
'    tATH_Closed =
'    tATH_Comments =
 
End Sub
 
 
' this section of code is a Public SubRoutine
' it probably should be placed in a Form or module...
 
 
Public Sub PGBLUpdateAFC_Transaction_History()
' in this subroutine the Update AFC_Transaction_History
'   logic is found..  Please note that all fields are first checked
'    for a single quote and re-formated for SQL

  

    tATH_index = Replace(tATH_index, "'", "''")
    tATH_Partno = Replace(tATH_Partno, "'", "''")
    tATH_Part_Serialno = Replace(tATH_Part_Serialno, "'", "''")
    tATH_Empno = Replace(tATH_Empno, "'", "''")
    tATH_Machine = Replace(tATH_Machine, "'", "''")
    tATH_Tran_type = Replace(tATH_Tran_type, "'", "''")
    tATH_Qty = Replace(tATH_Qty, "'", "''")
    tATH_Location = Replace(tATH_Location, "'", "''")
    tATH_Tran_Location = Replace(tATH_Tran_Location, "'", "''")
    tATH_Tran_Date = Replace(tATH_Tran_Date, "'", "''")
    tATH_Time = Replace(tATH_Time, "'", "''")
    tATH_CanDate = Replace(tATH_CanDate, "'", "''")
    tATH_Closed = Replace(tATH_Closed, "'", "''")
    tATH_First4 = Replace(tATH_First4, "'", "''")
    tATH_PackList = Replace(tATH_PackList, "'", "''")
    tATH_Comments = Replace(tATH_Comments, "'", "''")


'now we format the Update sub routine here


sSql = "Update AFC_Transaction_History set " _
  & "ATH_Partno = " & tATH_Partno & " , ATH_Part_Serialno = " & "'" & tATH_Part_Serialno & "'" & " , ATH_Empno = " & tATH_Empno & " , " _
  & "ATH_Machine = " & "'" & tATH_Machine & "'" & " , ATH_Tran_type = " & tATH_Tran_type & " , ATH_Qty = " & tATH_Qty & " , ATH_Location = " & tATH_Location & " , " _
  & "ATH_Tran_Location = " & tATH_Tran_Location & " , ATH_Tran_Date = " & "'" & tATH_Tran_Date & "'" & " , ATH_Time = " & "'" & tATH_Time & "'" & " , ATH_CanDate = " & "'" & tATH_CanDate & "'" & " , " _
  & "ATH_Closed = " & tATH_Closed & " , ATH_Comments = " & "'" & tATH_Comments & "'" & " , ATH_first4 = " & "'" & tATH_First4 & "', tATH_packlist = " & tATH_PackList

End Sub
 
 
 
Public Sub PGBLInitTVars_AFC_Transaction_History()
' This Subroutine will Initialize the Public Temporary Variables to Default
'       type Values for: AFC_Transaction_History
'
 
 
    tATH_index = " "
    tATH_Partno = " "
    tATH_Part_Serialno = " "
    tATH_Empno = 0
    tATH_Machine = " "
    tATH_Tran_type = 0
    tATH_Qty = 0
    tATH_Location = 0
    tATH_Tran_Location = 0
    tATH_Tran_Date = " "
    tATH_Time = " "
    tATH_CanDate = " "
    tATH_Closed = False
    tATH_First4 = ""
    tATH_PackList = 0
    tATH_Comments = " "
 
End Sub
 
 
 
 
Public Sub PGBLRecToTemp_AFC_Transaction_History(ByVal RmsDb As Object)
' This subroutine will load the Temporary Variables from the
'    Record Set Data. The Record Set Name is passed to it..
 
 
    tATH_index = IIf(IsNull(RmsDb("ATH_index")) = True, "", RmsDb("ATH_index"))
    tATH_Partno = IIf(IsNull(RmsDb("ATH_Partno")) = True, 0, RmsDb("ATH_Partno"))
    tATH_Part_Serialno = IIf(IsNull(RmsDb("ATH_Part_Serialno")) = True, "", RmsDb("ATH_Part_Serialno"))
    tATH_Empno = IIf(IsNull(RmsDb("ATH_Empno")) = True, "", RmsDb("ATH_Empno"))
    tATH_Machine = IIf(IsNull(RmsDb("ATH_Machine")) = True, "", RmsDb("ATH_Machine"))
    tATH_Tran_type = IIf(IsNull(RmsDb("ATH_Tran_type")) = True, "", RmsDb("ATH_Tran_type"))
    tATH_Qty = IIf(IsNull(RmsDb("ATH_Qty")) = True, "", RmsDb("ATH_Qty"))
    tATH_Location = IIf(IsNull(RmsDb("ATH_Location")) = True, "", RmsDb("ATH_Location"))
    tATH_Tran_Location = IIf(IsNull(RmsDb("ATH_Tran_Location")) = True, "", RmsDb("ATH_Tran_Location"))
    tATH_Tran_Date = IIf(IsNull(RmsDb("ATH_Tran_Date")) = True, "", RmsDb("ATH_Tran_Date"))
    tATH_Time = IIf(IsNull(RmsDb("ATH_Time")) = True, "", RmsDb("ATH_Time"))
    'tATH_CanDate = IIf(IsNull(RmsDb("ATH_CanDate")) = True, "", RmsDb("ATH_CanDate"))
    'tATH_Closed = IIf(IsNull(RmsDb("ATH_Closed")) = True, "", RmsDb("ATH_Closed"))
    tATH_Comments = IIf(IsNull(RmsDb("ATH_Comments")) = True, "", RmsDb("ATH_Comments"))
    tATH_First4 = IIf(IsNull(RmsDb("ATH_first4")) = True, "", RmsDb("ATH_first4"))
tATH_PackList = IIf(IsNull(RmsDb("ATH_PackList")) = True, "", RmsDb("ATH_PackList"))
End Sub
 
 
 
Public Function PGBLAddOrChange_AFC_Transaction_History(ByVal RmsDb As Object, ByVal UpdMode As String) As String
' This Function will either AddNew for Inserts into or
'             will change Table AFC_Transaction_History
'   The RecordSet Name Used is Passed in the First Parameter, and
'        the Mode Type (A=AddNew or U=Just an Update) in the Second Parameter ..
'        What gets returned is 0 for clean function or N + error description
Dim myerror As String
Dim mydescript As String
 On Error GoTo addorchangeerror_AFC_Transaction_History
 
 If UpdMode = "A" Or UpdMode = "U" Then
   Else
     MsgBox "Invalid Mode Type being passed to AddOrChange Subroutine...  Must be A or U"
     Exit Function
 End If
 
 'Now let's check for the Update mode Specified and do the right thing.
   If UpdMode = "A" Then
       RmsDb.AddNew
   End If
 
    RmsDb("ATH_Partno") = tATH_Partno
    RmsDb("ATH_Part_Serialno") = tATH_Part_Serialno
    RmsDb("ATH_Empno") = tATH_Empno
    RmsDb("ATH_Machine") = tATH_Machine
    RmsDb("ATH_Tran_type") = tATH_Tran_type
    RmsDb("ATH_Qty") = tATH_Qty
    RmsDb("ATH_Location") = tATH_Location
    RmsDb("ATH_Tran_Location") = tATH_Tran_Location
    RmsDb("ATH_Tran_Date") = tATH_Tran_Date
    RmsDb("ATH_Time") = tATH_Time
    RmsDb("ATH_CanDate") = tATH_CanDate
    RmsDb("ATH_Closed") = tATH_Closed
    RmsDb("ATH_Comments") = tATH_Comments
    RmsDb("ATH_first4") = tATH_First4
    RmsDb("ATH_PackList") = tATH_PackList
    RmsDb.Update
    PGBLAddOrChange_AFC_Transaction_History = "0"
Exit Function
 
addorchangeerror_AFC_Transaction_History:
 
    myerror = Err.Number
    mydescript = Err.Description
    PGBLAddOrChange_AFC_Transaction_History = "10 The Actual Error Number:" & myerror & " Error Description:" & mydescript
 
Exit Function
 
 
 
 
 
' End of AddNew Function
End Function
 
 
 
Public Sub PGBLPrintFieldValues_AFC_Transaction_History()
' This section of code was generated in case you needed it
' it will print the Temporary Field Name then Its Data Value..
 
 
 
Print #7, "tATH_index :"; tATH_index
Print #7, "tATH_Partno :"; tATH_Partno
Print #7, "tATH_Part_Serialno :"; tATH_Part_Serialno
Print #7, "tATH_Empno :"; tATH_Empno
Print #7, "tATH_Machine :"; tATH_Machine
Print #7, "tATH_Tran_type :"; tATH_Tran_type
Print #7, "tATH_Qty :"; tATH_Qty
Print #7, "tATH_Location :"; tATH_Location
Print #7, "tATH_Tran_Location :"; tATH_Tran_Location
Print #7, "tATH_Tran_Date :"; tATH_Tran_Date
Print #7, "tATH_Time :"; tATH_Time
Print #7, "tATH_CanDate :"; tATH_CanDate
Print #7, "tATH_Closed :"; tATH_Closed
Print #7, "tATH_Comments :"; tATH_Comments
 
End Sub
