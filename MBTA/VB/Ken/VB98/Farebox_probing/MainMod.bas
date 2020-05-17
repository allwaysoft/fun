Attribute VB_Name = "MainMod"
Public SQLData As ADODB.Connection
Public ORAData As ADODB.Connection
Public MCRSData As ADODB.Connection

Public RsWork As ADODB.Recordset
Public RsData As ADODB.Recordset

Public ssql As String


Public Sub Main()

    Set SQLData = New ADODB.Connection
    SQLData.Open "dsn=MBTA2005", "mbta", "mbtadb"
    
    Set ORAData = New ADODB.Connection
    'ORAData.Open "dsn=mbta_nwcd", "mbta", "hallo"
    ORAData.Open "dsn=nwcd", "mbta", "hallo"

    Set MCRSData = New ADODB.Connection
    MCRSData.Open "dsn=MCRS", "afc", "MaXimus2008"

    Call Load_Poll_Data
    Call Load_Bus_Status
    Call Load_GL_Status
    
    SQLData.Close
    Set SQLData = Nothing
    ORAData.Close
    Set ORAData = Nothing
    MCRSData.Close
    Set MCRSData = Nothing
    
End Sub

Public Sub Load_Poll_Data()

Dim today As Date
Dim tomorrow As Date
Dim hold_device As Long
Dim Garage As Long
    
    today = Date - 1
    tomorrow = Date
    
    ssql = "SELECT je.deviceid, je.jobtype, sc.sclocation2, Max(je.jobstarttime) AS lastdate FROM journalentries je, stationcontroller sc, tvmtable t " & _
    "WHERE sc.scid = je.scid AND t.tvmid = je.scid and je.deviceclassid = 501 and t.fieldstate <> 2 and je.jobstarttime >= To_Date('" & today & "','mm/dd/yyyy') and  je.jobstarttime < To_Date('" & tomorrow & "','mm/dd/yyyy')" & _
    " GROUP BY je.deviceid, je.jobtype, sc.sclocation2 ORDER BY je.deviceid, Max(je.jobstarttime)"
    
    Debug.Print ssql
    Set RsWork = New ADODB.Recordset
    Set RsWork = ORAData.Execute(ssql)
    Do While RsWork.EOF = False
        ssql = "select * from farebox_probing where fareboxno = " & CInt(RsWork("deviceid"))
        Set RsData = SQLData.Execute(ssql)
        If RsData.EOF = True Then
            ssql = "insert into farebox_probing (fareboxno, fareboxtype, lastprobe, lastlocation) " & _
            "values(" & RsWork("deviceid") & ",' ','" & RsWork("lastdate") & "','" & RsWork("sclocation2") & "')"
            
            SQLData.Execute (ssql)
        Else
            If RsWork("jobtype") = 4 Then
            
                ssql = "update farebox_probing set priorprobe = '" & RsData("lastprobe") & "', priorlocation = '" & RsData("lastlocation") & "', lastprobe = '" & _
                RsWork("lastdate") & "', lastlocation = '" & RsWork("sclocation2") & "', lastvault = '" & RsWork("lastdate") & "', lastvaultlocation = '" & RsWork("sclocation2") & "' where fareboxno = " & CInt(RsWork("deviceid"))
                hold_device = RsWork("deviceid")
            End If
            If RsWork("jobtype") = 6 Then
                If hold_device = RsWork("deviceid") Then GoTo SkipIt
                
                ssql = "update farebox_probing set priorprobe = '" & RsData("lastprobe") & "', priorlocation = '" & RsData("lastlocation") & "', lastprobe = '" & _
                RsWork("lastdate") & "', lastlocation = '" & RsWork("sclocation2") & "' where fareboxno = " & CInt(RsWork("deviceid"))
                hold_device = RsWork("deviceid")

            End If

            SQLData.Execute (ssql)
    
            Garage = 0
            Select Case RsWork("sclocation2")
            Case "Albany"
                Garage = 1
            Case "Arborway"
                Garage = 13
            Case "Southampton Garage"
                Garage = 11
            Case "Charlestown"
                Garage = 8
            Case "Fellsway"
                Garage = 4
            Case "Everett"
                Garage = 12
            Case "Lynn"
                Garage = 5
            Case "Cabot"
                Garage = 3
            Case "NCambridge"
                Garage = 7
            Case "Quincy"
                Garage = 6
            End Select
            
            If Garage <> 0 Then
                ssql = "Update tvmtable set tvmtarifflocationid = " & Garage & " WHERE TVMID = " & hold_device
                ORAData.Execute (ssql)
            End If
            
SkipIt:
        
        End If
        RsWork.MoveNext
    Loop
    
    RsWork.Close
    Set RsWork = Nothing

    

End Sub

Public Sub Load_Bus_Status()

    ssql = "select e.eq_equip_no as unit, e.LOC_ASSIGN_PM_LOC as pm_loc, LOC_MAIN.NAME as assigned_loc, " & _
    "e.SLA_STATUS as status, coalesce(to_char(e.LAST_FUEL_DATE, 'MM/DD/YYYY'),' ') as date_last_fueled, " & _
    "coalesce (round(sysdate-(select min(j.datetime_open) from job_main j " & _
    "where j.eq_equip_no = e.eq_equip_no and j.work_order_status = 'OPEN')),0) as days_out," & _
    "coalesce ((select loc_main.name from loc_main where loc_loc_code =  (select loc_work_order_loc " & _
    "from job_main j2 where j2.eq_equip_no = e.eq_equip_no and rownum <= 1 and " & _
    "j2.datetime_open = (select min(j.datetime_open) from job_main j where " & _
    "j.eq_equip_no = e.eq_equip_no and j.work_order_status = 'OPEN'))),' ') as work_order_loc_name " & _
    "from eq_main e,loc_main where e.LOC_ASSIGN_PM_LOC=LOC_LOC_CODE AND e.PROCST_PROC_STATUS like 'A%' " & _
    "and e.LOC_ASSIGN_PM_LOC IN ('414%','442', '445', '449', '452', '453', '455', '454', '456', '464', '466', '463', '462', '462A') " & _
    "AND ASSET_TYPE <> 'COMPONENT' and eq_equip_no not like 'N%' order by eq_equip_no"
    
    Set RsWork = New ADODB.Recordset
    Set RsWork = MCRSData.Execute(ssql)
    
    Do While RsWork.EOF = False
        ssql = "update farebox_probing set Currentstatus = '" & RsWork("status") & "', currentlocation = '" & RsWork("work_order_loc_name") & "'" & _
        " ,lastfueled = '" & RsWork("date_last_fueled") & "' where fareboxno = " & CInt(RsWork("unit"))
        Debug.Print ssql
        SQLData.Execute (ssql)
        RsWork.MoveNext
    Loop
    RsWork.Close
    Set RsWork = Nothing
    
    ssql = "update farebox_probing set currentstatus = 'IN SERVICE', currentlocation = 'TEST DEVICE' where fareboxno >= 7901 and fareboxno <= 7920"
    SQLData.Execute (ssql)
    
 
 End Sub
 
 Public Sub Load_GL_Status()
 Dim Gl_num As String
 Dim Farebox As String

    ssql = "select e.eq_equip_no as unit, e.LOC_ASSIGN_PM_LOC as pm_loc, LOC_MAIN.NAME as assigned_loc, " & _
    "e.SLA_STATUS as status, coalesce(to_char(e.LAST_FUEL_DATE, 'MM/DD/YYYY'),' ') as date_last_fueled, " & _
    "coalesce (round(sysdate-(select min(j.datetime_open) from job_main j " & _
    "where j.eq_equip_no = e.eq_equip_no and j.work_order_status = 'OPEN')),0) as days_out," & _
    "coalesce ((select loc_main.name from loc_main where loc_loc_code =  (select loc_work_order_loc " & _
    "from job_main j2 where j2.eq_equip_no = e.eq_equip_no and rownum <= 1 and " & _
    "j2.datetime_open = (select min(j.datetime_open) from job_main j where " & _
    "j.eq_equip_no = e.eq_equip_no and j.work_order_status = 'OPEN'))),' ') as work_order_loc_name " & _
    "from eq_main e,loc_main where e.LOC_ASSIGN_PM_LOC=LOC_LOC_CODE AND e.PROCST_PROC_STATUS like 'A%' " & _
    "and e.LOC_ASSIGN_PM_LOC = '466' " & _
    "AND ASSET_TYPE <> 'COMPONENT' and eq_equip_no not like 'N%' order by eq_equip_no"
    
    Set RsWork = New ADODB.Recordset
    Set RsWork = MCRSData.Execute(ssql)
    
    Do While RsWork.EOF = False
        Gl_num = RsWork("unit")
        Farebox = Mid(Gl_num, 3, 5) & "1"
        ssql = "update farebox_probing set Currentstatus = '" & RsWork("status") & "', currentlocation = '" & RsWork("work_order_loc_name") & "'" & _
        " where fareboxno = " & CInt(Farebox) & " and fareboxtype <> 'Bus'"
        
        SQLData.Execute (ssql)
        
        Gl_num = RsWork("unit")
        Farebox = Mid(Gl_num, 3, 5) & "2"
        ssql = "update farebox_probing set Currentstatus = '" & RsWork("status") & "', currentlocation = '" & RsWork("work_order_loc_name") & "'" & _
        " where fareboxno = " & CInt(Farebox) & " and fareboxtype <> 'Bus'"
        
        SQLData.Execute (ssql)
        RsWork.MoveNext
    Loop
    RsWork.Close
    Set RsWork = Nothing
 
 End Sub

