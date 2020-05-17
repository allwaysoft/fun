Attribute VB_Name = "mdlPGBLafc_inventory"
 
Option Explicit
'
' These are Public Temporary Variables and Their Data Types. For table: afc_inventory
 
 
    Public tAI_Index As Long
    Public tAI_Partno As String
    Public tAI_Description As String
    Public tAI_PartType As String
    Public tAI_OEMPartno As String
    Public tAI_CurrentCost As Currency
    Public tAI_AltPartno As String
    Public tAI_Satellite As String
    Public tAI_Required As Long
    Public tAI_Onhand As Long
    Public tAI_Damaged As Long
    Public tAI_MinROP As Long
    Public tAI_MaxROP As Long
    Public tAI_RLBase As Long
    Public tAI_RLSatellite As Long
    Public tAI_rolledout As String
    Public tAI_Order1 As Long
    Public tAI_Order2 As Long
    Public tAI_Order3 As Long
    Public tAI_Order4 As Long
    Public tAI_Tom_Order As Long
    Public tAI_Scim_Order As Long
    Public tAI_Order_Other As Long
    Public tAI_Farebox_Order1 As Long
    Public tAI_Farebox_Order2 As Long
    Public tAI_FMV_Order As Long
    Public tAI_Received As Long
    Public tAI_SettelingSB As Long
    Public tAI_Unit_Type As Long
    Public tAI_Usage As Long
    Public tAI_Notes As String
 
 
' this section of code is a Public SubRoutine
' it probably should be placed in a Form or module...
 
 
Public Sub PGBLinsertintoafc_inventory()
' in this subroutine the Insert into afc_inventory
'   logic is found..  Please note that all fields are first checked
'    for a single quote and re-formated for SQL

 

    tAI_Index = Replace(tAI_Index, "'", "''")
    tAI_Partno = Replace(tAI_Partno, "'", "''")
    tAI_Description = Replace(tAI_Description, "'", "''")
    tAI_PartType = Replace(tAI_PartType, "'", "''")
    tAI_OEMPartno = Replace(tAI_OEMPartno, "'", "''")
    tAI_CurrentCost = Replace(tAI_CurrentCost, "'", "''")
    tAI_AltPartno = Replace(tAI_AltPartno, "'", "''")
    tAI_Satellite = Replace(tAI_Satellite, "'", "''")
    tAI_Required = Replace(tAI_Required, "'", "''")
    tAI_Onhand = Replace(tAI_Onhand, "'", "''")
    tAI_Damaged = Replace(tAI_Damaged, "'", "''")
    tAI_MinROP = Replace(tAI_MinROP, "'", "''")
    tAI_MaxROP = Replace(tAI_MaxROP, "'", "''")
    tAI_RLBase = Replace(tAI_RLBase, "'", "''")
    tAI_RLSatellite = Replace(tAI_RLSatellite, "'", "''")
    tAI_rolledout = Replace(tAI_rolledout, "'", "''")
    tAI_Order1 = Replace(tAI_Order1, "'", "''")
    tAI_Order2 = Replace(tAI_Order2, "'", "''")
    tAI_Order3 = Replace(tAI_Order3, "'", "''")
    tAI_Order4 = Replace(tAI_Order4, "'", "''")
    tAI_Tom_Order = Replace(tAI_Tom_Order, "'", "''")
    tAI_Scim_Order = Replace(tAI_Scim_Order, "'", "''")
    tAI_Order_Other = Replace(tAI_Order_Other, "'", "''")
    tAI_Farebox_Order1 = Replace(tAI_Farebox_Order1, "'", "''")
    tAI_Farebox_Order2 = Replace(tAI_Farebox_Order2, "'", "''")
    tAI_FMV_Order = Replace(tAI_FMV_Order, "'", "''")
    tAI_Received = Replace(tAI_Received, "'", "''")
    tAI_SettelingSB = Replace(tAI_SettelingSB, "'", "''")
    tAI_Usage = Replace(tAI_Usage, "'", "''")
    tAI_Unit_Type = Replace(tAI_Unit_Type, "'", "''")
    tAI_Notes = Replace(tAI_Notes, "'", "''")



sSql = "Insert into afc_inventory" _
  & "(AI_Index,AI_Partno,AI_Description,AI_PartType,AI_OEMPartno,AI_CurrentCost,AI_AltPartno,AI_Satellite,AI_Required,AI_Onhand,AI_Damaged," _
  & "AI_MinROP,AI_MaxROP,AI_RLBase,AI_RLSatellite,AI_rolledout,AI_Order1,AI_Order2,AI_Order3,AI_Order4,AI_Tom_Order,AI_Scim_Order," _
  & "AI_Order_Other,AI_Farebox_Order1,AI_Farebox_Order2,AI_FMV_Order,AI_Received,AI_SettelingSB,AI_Usage,AI_Unit_Type,AI_Notes)" _
  & "Values (" & "'" & tAI_Index & "'" & "," & "'" & tAI_Partno & "'" & "," & "'" & tAI_Description & "'" & "," & "'" & tAI_PartType & "'" & "," & "'" & tAI_OEMPartno & "'" & "," & tAI_CurrentCost & "," & "'" & tAI_AltPartno & "'" & "," & "'" & tAI_Satellite & "'" & "," _
  & tAI_Required & "," & tAI_Onhand & "," & tAI_Damaged & "," & tAI_MinROP & "," & tAI_MaxROP & "," & tAI_RLBase & "," & tAI_RLSatellite & "," & "'" & tAI_rolledout & "'" & "," _
  & tAI_Order1 & "," & tAI_Order2 & "," & tAI_Order3 & "," & tAI_Order4 & "," & tAI_Tom_Order & "," & tAI_Scim_Order & "," & tAI_Order_Other & "," & tAI_Farebox_Order1 & "," _
  & tAI_Farebox_Order2 & "," & tAI_FMV_Order & "," & tAI_Received & "," & tAI_SettelingSB & "," & tAI_Usage & "," & tAI_Unit_Type & ",'" & tAI_Notes & "'" & ")"
 
End Sub
 
 
' ++++   FIRST OPTIONAL   ++++
 
' this section of code was generated in case you needed it
' it is the temp fields that you will populate with your data...
' somewhere inside your program, probably just before the call
'  to the subroutine to insert...
 
 
 
 
Public Sub PGBLDummyInitTVars_afc_inventory()
' **** This should be commented out*******
' in this subroutine Initilization of the temp Variablesfor afc_inventory
'   logic is found..
 
 
'    tAI_Index =
'    tAI_Partno =
'    tAI_Description =
'    tAI_PartType =
'    tAI_OEMPartno =
'    tAI_CurrentCost =
'    tAI_AltPartno =
'    tAI_Satellite =
'    tAI_Required =
'    tAI_Onhand =
'    tAI_Damaged =
'    tAI_MinROP =
'    tAI_MaxROP =
'    tAI_RLBase =
'    tAI_RLSatellite =
'    tAI_rolledout =
'    tAI_Order1 =
'    tAI_Order2 =
'    tAI_Order3 =
'    tAI_Order4 =
'    tAI_Tom_Order =
'    tAI_Scim_Order =
'    tAI_Order_Other =
'    tAI_Farebox_Order1 =
'    tAI_Farebox_Order2 =
'    tAI_FMV_Order =
'    tAI_Received =
'    tAI_SettelingSB =
'    tAI_Usage =
'    tAI_Notes =
 
End Sub
 
 
' this section of code is a Public SubRoutine
' it probably should be placed in a Form or module...
 
 
Public Sub PGBLUpdateafc_inventory()
' in this subroutine the Update afc_inventory
'   logic is found..  Please note that all fields are first checked
'    for a single quote and re-formated for SQL

  

    tAI_Index = Replace(tAI_Index, "'", "''")
    tAI_Partno = Replace(tAI_Partno, "'", "''")
    tAI_Description = Replace(tAI_Description, "'", "''")
    tAI_PartType = Replace(tAI_PartType, "'", "''")
    tAI_OEMPartno = Replace(tAI_OEMPartno, "'", "''")
    tAI_CurrentCost = Replace(tAI_CurrentCost, "'", "''")
    tAI_AltPartno = Replace(tAI_AltPartno, "'", "''")
    tAI_Satellite = Replace(tAI_Satellite, "'", "''")
    tAI_Required = Replace(tAI_Required, "'", "''")
    tAI_Onhand = Replace(tAI_Onhand, "'", "''")
    tAI_Damaged = Replace(tAI_Damaged, "'", "''")
    tAI_MinROP = Replace(tAI_MinROP, "'", "''")
    tAI_MaxROP = Replace(tAI_MaxROP, "'", "''")
    tAI_RLBase = Replace(tAI_RLBase, "'", "''")
    tAI_RLSatellite = Replace(tAI_RLSatellite, "'", "''")
    tAI_rolledout = Replace(tAI_rolledout, "'", "''")
    tAI_Order1 = Replace(tAI_Order1, "'", "''")
    tAI_Order2 = Replace(tAI_Order2, "'", "''")
    tAI_Order3 = Replace(tAI_Order3, "'", "''")
    tAI_Order4 = Replace(tAI_Order4, "'", "''")
    tAI_Tom_Order = Replace(tAI_Tom_Order, "'", "''")
    tAI_Scim_Order = Replace(tAI_Scim_Order, "'", "''")
    tAI_Order_Other = Replace(tAI_Order_Other, "'", "''")
    tAI_Farebox_Order1 = Replace(tAI_Farebox_Order1, "'", "''")
    tAI_Farebox_Order2 = Replace(tAI_Farebox_Order2, "'", "''")
    tAI_FMV_Order = Replace(tAI_FMV_Order, "'", "''")
    tAI_Received = Replace(tAI_Received, "'", "''")
    tAI_SettelingSB = Replace(tAI_SettelingSB, "'", "''")
    tAI_Usage = Replace(tAI_Usage, "'", "''")
    tAI_Notes = Replace(tAI_Notes, "'", "''")


'now we format the Update sub routine here


sSql = "Update afc_inventory set " _
  & "AI_Partno = " & "'" & tAI_Partno & "'" & " , AI_Description = " & "'" & tAI_Description & "'" & " , AI_PartType = " & "'" & tAI_PartType & "'" & " , " _
  & "AI_OEMPartno = " & "'" & tAI_OEMPartno & "'" & " , AI_CurrentCost = " & tAI_CurrentCost & " , AI_AltPartno = " & "'" & tAI_AltPartno & "'" & " , AI_Satellite = " & "'" & tAI_Satellite & "'" & " , " _
  & "AI_Required = " & tAI_Required & " , AI_Onhand = " & tAI_Onhand & " , AI_Damaged = " & tAI_Damaged & " , AI_MinROP = " & tAI_MinROP & " , " _
  & "AI_MaxROP = " & tAI_MaxROP & " , AI_RLBase = " & tAI_RLBase & " , AI_RLSatellite = " & tAI_RLSatellite & " , AI_rolledout = " & "'" & tAI_rolledout & "'" & " , " _
  & "AI_Order1 = " & tAI_Order1 & " , AI_Order2 = " & tAI_Order2 & " , AI_Order3 = " & tAI_Order3 & " , AI_Order4 = " & tAI_Order4 & " , " _
  & "AI_Tom_Order = " & tAI_Tom_Order & " , AI_Scim_Order = " & tAI_Scim_Order & " , AI_Order_Other = " & tAI_Order_Other & " , AI_Farebox_Order1 = " & tAI_Farebox_Order1 & " , " _
  & "AI_Farebox_Order2 = " & tAI_Farebox_Order2 & " , AI_FMV_Order = " & tAI_FMV_Order & " , AI_Received = " & tAI_Received & " , AI_SettelingSB = " & tAI_SettelingSB & " , " _
  & "AI_Usage = " & tAI_Usage & " , AI_Unit_type = " & tAI_Unit_Type & ", AI_Notes = " & "'" & tAI_Notes & "' "
End Sub
 
 
 
Public Sub PGBLInitTVars_afc_inventory()
' This Subroutine will Initialize the Public Temporary Variables to Default
'       type Values for: afc_inventory
'
 
 
    tAI_Index = " "
    tAI_Partno = " "
    tAI_Description = " "
    tAI_PartType = " "
    tAI_OEMPartno = " "
    tAI_CurrentCost = FormatCurrency(0)
    tAI_AltPartno = " "
    tAI_Satellite = " "
    tAI_Required = 0
    tAI_Onhand = 0
    tAI_Damaged = 0
    tAI_MinROP = 0
    tAI_MaxROP = 0
    tAI_RLBase = 0
    tAI_RLSatellite = 0
    tAI_rolledout = " "
    tAI_Order1 = 0
    tAI_Order2 = 0
    tAI_Order3 = 0
    tAI_Order4 = 0
    tAI_Tom_Order = 0
    tAI_Scim_Order = 0
    tAI_Order_Other = 0
    tAI_Farebox_Order1 = 0
    tAI_Farebox_Order2 = 0
    tAI_FMV_Order = 0
    tAI_Received = 0
    tAI_SettelingSB = 0
    tAI_Usage = 0
    tAI_Unit_Type = 0
    tAI_Notes = " "
 
End Sub
 
 
 
 
Public Sub PGBLRecToTemp_afc_inventory(ByVal RmsDb As Object)
' This subroutine will load the Temporary Variables from the
'    Record Set Data. The Record Set Name is passed to it..
 
 
    tAI_Index = IIf(IsNull(RmsDb("AI_Index")) = True, 0, RmsDb("AI_Index"))
    tAI_Partno = IIf(IsNull(RmsDb("AI_Partno")) = True, "", RmsDb("AI_Partno"))
    tAI_Description = IIf(IsNull(RmsDb("AI_Description")) = True, "", RmsDb("AI_Description"))
    tAI_PartType = IIf(IsNull(RmsDb("AI_PartType")) = True, "", RmsDb("AI_PartType"))
    tAI_OEMPartno = IIf(IsNull(RmsDb("AI_OEMPartno")) = True, "", RmsDb("AI_OEMPartno"))
    tAI_CurrentCost = IIf(IsNull(RmsDb("AI_CurrentCost")) = True, 0, RmsDb("AI_CurrentCost"))
    tAI_AltPartno = IIf(IsNull(RmsDb("AI_AltPartno")) = True, "", RmsDb("AI_AltPartno"))
    tAI_Satellite = IIf(IsNull(RmsDb("AI_Satellite")) = True, "", RmsDb("AI_Satellite"))
    tAI_Required = IIf(IsNull(RmsDb("AI_Required")) = True, 0, RmsDb("AI_Required"))
    tAI_Onhand = IIf(IsNull(RmsDb("AI_Onhand")) = True, 0, RmsDb("AI_Onhand"))
    tAI_Damaged = IIf(IsNull(RmsDb("AI_Damaged")) = True, 0, RmsDb("AI_Damaged"))
    tAI_MinROP = IIf(IsNull(RmsDb("AI_MinROP")) = True, 0, RmsDb("AI_MinROP"))
    tAI_MaxROP = IIf(IsNull(RmsDb("AI_MaxROP")) = True, 0, RmsDb("AI_MaxROP"))
    tAI_RLBase = IIf(IsNull(RmsDb("AI_RLBase")) = True, 0, RmsDb("AI_RLBase"))
    tAI_RLSatellite = IIf(IsNull(RmsDb("AI_RLSatellite")) = True, 0, RmsDb("AI_RLSatellite"))
    tAI_rolledout = IIf(IsNull(RmsDb("AI_rolledout")) = True, "", RmsDb("AI_rolledout"))
    tAI_Order1 = IIf(IsNull(RmsDb("AI_Order1")) = True, 0, RmsDb("AI_Order1"))
    tAI_Order2 = IIf(IsNull(RmsDb("AI_Order2")) = True, 0, RmsDb("AI_Order2"))
    tAI_Order3 = IIf(IsNull(RmsDb("AI_Order3")) = True, 0, RmsDb("AI_Order3"))
    tAI_Order4 = IIf(IsNull(RmsDb("AI_Order4")) = True, 0, RmsDb("AI_Order4"))
    tAI_Tom_Order = IIf(IsNull(RmsDb("AI_Tom_Order")) = True, 0, RmsDb("AI_Tom_Order"))
    tAI_Scim_Order = IIf(IsNull(RmsDb("AI_Scim_Order")) = True, 0, RmsDb("AI_Scim_Order"))
    tAI_Order_Other = IIf(IsNull(RmsDb("AI_Order_Other")) = True, 0, RmsDb("AI_Order_Other"))
    tAI_Farebox_Order1 = IIf(IsNull(RmsDb("AI_Farebox_Order1")) = True, 0, RmsDb("AI_Farebox_Order1"))
    tAI_Farebox_Order2 = IIf(IsNull(RmsDb("AI_Farebox_Order2")) = True, 0, RmsDb("AI_Farebox_Order2"))
    tAI_FMV_Order = IIf(IsNull(RmsDb("AI_FMV_Order")) = True, 0, RmsDb("AI_FMV_Order"))
    tAI_Received = IIf(IsNull(RmsDb("AI_Received")) = True, 0, RmsDb("AI_Received"))
    tAI_SettelingSB = IIf(IsNull(RmsDb("AI_SettelingSB")) = True, 0, RmsDb("AI_SettelingSB"))
    tAI_Usage = IIf(IsNull(RmsDb("AI_Usage")) = True, 0, RmsDb("AI_Usage"))
    tAI_Unit_Type = IIf(IsNull(RmsDb("AI_Unit_type")) = True, 0, RmsDb("AI_Unit_type"))
    tAI_Notes = IIf(IsNull(RmsDb("AI_Notes")) = True, "", RmsDb("AI_Notes"))
 
End Sub
 
 
 
Public Function PGBLAddOrChange_afc_inventory(ByVal RmsDb As Object, ByVal UpdMode As String) As String
' This Function will either AddNew for Inserts into or
'             will change Table afc_inventory
'   The RecordSet Name Used is Passed in the First Parameter, and
'        the Mode Type (A=AddNew or U=Just an Update) in the Second Parameter ..
'        What gets returned is 0 for clean function or N + error description
Dim myerror As String
Dim mydescript As String
 On Error GoTo addorchangeerror_afc_inventory
 
 If UpdMode = "A" Or UpdMode = "U" Then
   Else
     MsgBox "Invalid Mode Type being passed to AddOrChange Subroutine...  Must be A or U"
     Exit Function
 End If
 
 'Now let's check for the Update mode Specified and do the right thing.
   If UpdMode = "A" Then
       RmsDb.AddNew
   End If
 
    RmsDb("AI_Index") = tAI_Index
    RmsDb("AI_Partno") = tAI_Partno
    RmsDb("AI_Description") = tAI_Description
    RmsDb("AI_PartType") = tAI_PartType
    RmsDb("AI_OEMPartno") = tAI_OEMPartno
    RmsDb("AI_CurrentCost") = tAI_CurrentCost
    RmsDb("AI_AltPartno") = tAI_AltPartno
    RmsDb("AI_Satellite") = tAI_Satellite
    RmsDb("AI_Required") = tAI_Required
    RmsDb("AI_Onhand") = tAI_Onhand
    RmsDb("AI_Damaged") = tAI_Damaged
    RmsDb("AI_MinROP") = tAI_MinROP
    RmsDb("AI_MaxROP") = tAI_MaxROP
    RmsDb("AI_RLBase") = tAI_RLBase
    RmsDb("AI_RLSatellite") = tAI_RLSatellite
    RmsDb("AI_rolledout") = tAI_rolledout
    RmsDb("AI_Order1") = tAI_Order1
    RmsDb("AI_Order2") = tAI_Order2
    RmsDb("AI_Order3") = tAI_Order3
    RmsDb("AI_Order4") = tAI_Order4
    RmsDb("AI_Tom_Order") = tAI_Tom_Order
    RmsDb("AI_Scim_Order") = tAI_Scim_Order
    RmsDb("AI_Order_Other") = tAI_Order_Other
    RmsDb("AI_Farebox_Order1") = tAI_Farebox_Order1
    RmsDb("AI_Farebox_Order2") = tAI_Farebox_Order2
    RmsDb("AI_FMV_Order") = tAI_FMV_Order
    RmsDb("AI_Received") = tAI_Received
    RmsDb("AI_SettelingSB") = tAI_SettelingSB
    RmsDb("AI_Usage") = tAI_Usage
    RmsDb("AI_Notes") = tAI_Notes
 
    RmsDb.Update
    PGBLAddOrChange_afc_inventory = "0"
Exit Function
 
addorchangeerror_afc_inventory:
 
    myerror = Err.Number
    mydescript = Err.Description
    PGBLAddOrChange_afc_inventory = "10 The Actual Error Number:" & myerror & " Error Description:" & mydescript
 
Exit Function
 
 
 
 
 
' End of AddNew Function
End Function
 
 
 
Public Sub PGBLPrintFieldValues_afc_inventory()
' This section of code was generated in case you needed it
' it will print the Temporary Field Name then Its Data Value..
 
 
 
Print #7, "tAI_Index :"; tAI_Index
Print #7, "tAI_Partno :"; tAI_Partno
Print #7, "tAI_Description :"; tAI_Description
Print #7, "tAI_PartType :"; tAI_PartType
Print #7, "tAI_OEMPartno :"; tAI_OEMPartno
Print #7, "tAI_CurrentCost :"; tAI_CurrentCost
Print #7, "tAI_AltPartno :"; tAI_AltPartno
Print #7, "tAI_Satellite :"; tAI_Satellite
Print #7, "tAI_Required :"; tAI_Required
Print #7, "tAI_Onhand :"; tAI_Onhand
Print #7, "tAI_Damaged :"; tAI_Damaged
Print #7, "tAI_MinROP :"; tAI_MinROP
Print #7, "tAI_MaxROP :"; tAI_MaxROP
Print #7, "tAI_RLBase :"; tAI_RLBase
Print #7, "tAI_RLSatellite :"; tAI_RLSatellite
Print #7, "tAI_rolledout :"; tAI_rolledout
Print #7, "tAI_Order1 :"; tAI_Order1
Print #7, "tAI_Order2 :"; tAI_Order2
Print #7, "tAI_Order3 :"; tAI_Order3
Print #7, "tAI_Order4 :"; tAI_Order4
Print #7, "tAI_Tom_Order :"; tAI_Tom_Order
Print #7, "tAI_Scim_Order :"; tAI_Scim_Order
Print #7, "tAI_Order_Other :"; tAI_Order_Other
Print #7, "tAI_Farebox_Order1 :"; tAI_Farebox_Order1
Print #7, "tAI_Farebox_Order2 :"; tAI_Farebox_Order2
Print #7, "tAI_FMV_Order :"; tAI_FMV_Order
Print #7, "tAI_Received :"; tAI_Received
Print #7, "tAI_SettelingSB :"; tAI_SettelingSB
Print #7, "tAI_Usage :"; tAI_Usage
Print #7, "tAI_Notes :"; tAI_Notes
 
End Sub
