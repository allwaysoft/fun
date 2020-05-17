Attribute VB_Name = "mdlPGBLafc_trans"
 
Option Explicit
'
' These are Public Temporary Variables and Their Data Types. For table: afc_trans
 
 
    Public tATR_id As Long
    Public tATR_Partno As Long
    Public tATR_Part_Serialno As String
    Public tATR_Empno As Long
    Public tATR_Tran_type As Long
    Public tATR_Qty As Long
    Public tATR_Location As Long
    Public tATR_Tran_Location As Long
    Public tATR_Tran_Date As Date
    Public tATR_Time As Date
    Public tATR_Comments As String
 
 
' this section of code is a Public SubRoutine
' it probably should be placed in a Form or module...
 
 
Public Sub PGBLinsertintoafc_trans()
' in this subroutine the Insert into afc_trans
'   logic is found..  Please note that all fields are first checked
'    for a single quote and re-formated for SQL

 

    tATR_id = Replace(tATR_id, "'", "''")
    tATR_Partno = Replace(tATR_Partno, "'", "''")
    tATR_Part_Serialno = Replace(tATR_Part_Serialno, "'", "''")
    tATR_Empno = Replace(tATR_Empno, "'", "''")
    tATR_Tran_type = Replace(tATR_Tran_type, "'", "''")
    tATR_Qty = Replace(tATR_Qty, "'", "''")
    tATR_Location = Replace(tATR_Location, "'", "''")
    tATR_Tran_Location = Replace(tATR_Tran_Location, "'", "''")
    tATR_Tran_Date = Replace(tATR_Tran_Date, "'", "''")
    tATR_Time = Replace(tATR_Time, "'", "''")
    tATR_Comments = Replace(tATR_Comments, "'", "''")



sSQL = "Insert into afc_trans" _
  & "(ATR_Partno,ATR_Part_Serialno,ATR_Empno,ATR_Tran_type,ATR_Qty,ATR_Location,ATR_Tran_Location,ATR_Tran_Date,ATR_Time,ATR_Comments)" _
  & "Values (" & tATR_Partno & "," & "'" & tATR_Part_Serialno & "'" & "," & "'" & tATR_Empno & "'" & "," & tATR_Tran_type & "," & tATR_Qty & "," & tATR_Location & "," & tATR_Tran_Location & "," _
  & "'" & tATR_Tran_Date & "'" & "," & "'" & tATR_Time & "'" & "," & "'" & tATR_Comments & "'" & ")"
 
End Sub
 
 
' ++++   FIRST OPTIONAL   ++++
 
' this section of code was generated in case you needed it
' it is the temp fields that you will populate with your data...
' somewhere inside your program, probably just before the call
'  to the subroutine to insert...
 
 
 
 
Public Sub PGBLDummyInitTVars_afc_trans()
' **** This should be commented out*******
' in this subroutine Initilization of the temp Variablesfor afc_trans
'   logic is found..
 
 
'    tATR_id =
'    tATR_Partno =
'    tATR_Part_Serialno =
'    tATR_Empno =
'    tATR_Tran_type =
'    tATR_Qty =
'    tATR_Location =
'    tATR_Tran_Location =
'    tATR_Tran_Date =
'    tATR_Time =
'    tATR_Comments =
 
End Sub
 
 
' this section of code is a Public SubRoutine
' it probably should be placed in a Form or module...
 
 
Public Sub PGBLUpdateafc_trans()
' in this subroutine the Update afc_trans
'   logic is found..  Please note that all fields are first checked
'    for a single quote and re-formated for SQL

  

    tATR_Partno = Replace(tATR_Partno, "'", "''")
    tATR_Part_Serialno = Replace(tATR_Part_Serialno, "'", "''")
    tATR_Empno = Replace(tATR_Empno, "'", "''")
    tATR_Tran_type = Replace(tATR_Tran_type, "'", "''")
    tATR_Qty = Replace(tATR_Qty, "'", "''")
    tATR_Location = Replace(tATR_Location, "'", "''")
    tATR_Tran_Location = Replace(tATR_Tran_Location, "'", "''")
    tATR_Tran_Date = Replace(tATR_Tran_Date, "'", "''")
    tATR_Time = Replace(tATR_Time, "'", "''")
    tATR_Comments = Replace(tATR_Comments, "'", "''")


'now we format the Update sub routine here


sSQL = "Update afc_trans set " _
  & "ATR_id = " & "'" & tATR_id & "'" & " , ATR_Partno = " & tATR_Partno & " , ATR_Part_Serialno = " & "'" & tATR_Part_Serialno & "'" & " , ATR_Empno = " & "'" & tATR_Empno & "'" & " , " _
  & "ATR_Tran_type = " & tATR_Tran_type & " , ATR_Qty = " & tATR_Qty & " , ATR_Location = " & tATR_Location & " , ATR_Tran_Location = " & tATR_Tran_Location & " , " _
  & "ATR_Tran_Date = " & "'" & tATR_Tran_Date & "'" & " , ATR_Time = " & "'" & tATR_Time & "'" & " , ATR_Comments = " & "'" & tATR_Comments & "'"
 
End Sub
 
 
 
Public Sub PGBLInitTVars_afc_trans()
' This Subroutine will Initialize the Public Temporary Variables to Default
'       type Values for: afc_trans
'
 
 
    tATR_id = " "
    tATR_Partno = 0
    tATR_Part_Serialno = " "
    tATR_Empno = " "
    tATR_Tran_type = 0
    tATR_Qty = 0
    tATR_Location = 0
    tATR_Tran_Location = 0
    tATR_Tran_Date = " "
    tATR_Time = " "
    tATR_Comments = " "
 
End Sub
 
 
 
 
Public Sub PGBLRecToTemp_afc_trans(ByVal RmsDb As Object)
' This subroutine will load the Temporary Variables from the
'    Record Set Data. The Record Set Name is passed to it..
 
 
    tATR_id = IIf(IsNull(RmsDb("ATR_id")) = True, "", RmsDb("ATR_id"))
    tATR_Partno = IIf(IsNull(RmsDb("ATR_Partno")) = True, "", RmsDb("ATR_Partno"))
    tATR_Part_Serialno = IIf(IsNull(RmsDb("ATR_Part_Serialno")) = True, "", RmsDb("ATR_Part_Serialno"))
    tATR_Empno = IIf(IsNull(RmsDb("ATR_Empno")) = True, "", RmsDb("ATR_Empno"))
    tATR_Tran_type = IIf(IsNull(RmsDb("ATR_Tran_type")) = True, "", RmsDb("ATR_Tran_type"))
    tATR_Qty = IIf(IsNull(RmsDb("ATR_Qty")) = True, "", RmsDb("ATR_Qty"))
    tATR_Location = IIf(IsNull(RmsDb("ATR_Location")) = True, "", RmsDb("ATR_Location"))
    tATR_Tran_Location = IIf(IsNull(RmsDb("ATR_Tran_Location")) = True, "", RmsDb("ATR_Tran_Location"))
    tATR_Tran_Date = IIf(IsNull(RmsDb("ATR_Tran_Date")) = True, "", RmsDb("ATR_Tran_Date"))
    tATR_Time = IIf(IsNull(RmsDb("ATR_Time")) = True, "", RmsDb("ATR_Time"))
    tATR_Comments = IIf(IsNull(RmsDb("ATR_Comments")) = True, "", RmsDb("ATR_Comments"))
 
End Sub
 
 
 
Public Function PGBLAddOrChange_afc_trans(ByVal RmsDb As Object, ByVal UpdMode As String) As String
' This Function will either AddNew for Inserts into or
'             will change Table afc_trans
'   The RecordSet Name Used is Passed in the First Parameter, and
'        the Mode Type (A=AddNew or U=Just an Update) in the Second Parameter ..
'        What gets returned is 0 for clean function or N + error description
Dim myerror As String
Dim mydescript As String
 On Error GoTo addorchangeerror_afc_trans
 
 If UpdMode = "A" Or UpdMode = "U" Then
   Else
     MsgBox "Invalid Mode Type being passed to AddOrChange Subroutine...  Must be A or U"
     Exit Function
 End If
 
 'Now let's check for the Update mode Specified and do the right thing.
   If UpdMode = "A" Then
       RmsDb.AddNew
   End If
 
    RmsDb("ATR_Partno") = tATR_Partno
    RmsDb("ATR_Part_Serialno") = tATR_Part_Serialno
    RmsDb("ATR_Empno") = tATR_Empno
    RmsDb("ATR_Tran_type") = tATR_Tran_type
    RmsDb("ATR_Qty") = tATR_Qty
    RmsDb("ATR_Location") = tATR_Location
    RmsDb("ATR_Tran_Location") = tATR_Tran_Location
    RmsDb("ATR_Tran_Date") = tATR_Tran_Date
    RmsDb("ATR_Time") = tATR_Time
    RmsDb("ATR_Comments") = tATR_Comments
 
    RmsDb.Update
    PGBLAddOrChange_afc_trans = "0"
Exit Function
 
addorchangeerror_afc_trans:
 
    myerror = Err.Number
    mydescript = Err.Description
    PGBLAddOrChange_afc_trans = "10 The Actual Error Number:" & myerror & " Error Description:" & mydescript
 
Exit Function
 
 
 
 
 
' End of AddNew Function
End Function
 
 
 
Public Sub PGBLPrintFieldValues_afc_trans()
' This section of code was generated in case you needed it
' it will print the Temporary Field Name then Its Data Value..
 
 
 
Print #7, "tATR_id :"; tATR_id
Print #7, "tATR_Partno :"; tATR_Partno
Print #7, "tATR_Part_Serialno :"; tATR_Part_Serialno
Print #7, "tATR_Empno :"; tATR_Empno
Print #7, "tATR_Tran_type :"; tATR_Tran_type
Print #7, "tATR_Qty :"; tATR_Qty
Print #7, "tATR_Location :"; tATR_Location
Print #7, "tATR_Tran_Location :"; tATR_Tran_Location
Print #7, "tATR_Tran_Date :"; tATR_Tran_Date
Print #7, "tATR_Time :"; tATR_Time
Print #7, "tATR_Comments :"; tATR_Comments
 
End Sub
