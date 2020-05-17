Attribute VB_Name = "Main_Module"
Option Explicit

Public SQLData As ADODB.Connection
Public ORAData As ADODB.Connection

Public RSwork As ADODB.Recordset
Public RSData As ADODB.Recordset

Public sSql As String

Dim Startdate As String
Dim Enddate As String
Dim Enddate1 As String



Public Sub Main()
    
    ' need to kill the first 1089 records in device availability table next week
    
    Set SQLData = New ADODB.Connection
    'SQLData.Open "dsn=MBTACopy", "mbta", "mbtadb"
    SQLData.Open "dsn=MBTA2005", "mbta", "mbtadb"
    'SQLData.Open "dsn=local2005", "mbta", "mbtadb"
    
    Set ORAData = New ADODB.Connection
    ORAData.Open "dsn=mbta_nwcd", "mbta", "hallo"
    'ORAData.Open "dsn=mbta_nwcd_dw", "mbta", "hallo"
    'ORAData.Open "dsn=mbta_nwcd_test", "mbta", "hallo"
    
    Call Check_Cards
    SQLData.Close
    Set SQLData = Nothing
    ORAData.Close
    Set ORAData = Nothing
End Sub
Public Sub Check_Cards()
Dim stuff As String



Startdate = "2010-04-01"
Enddate = "2010-05-01"
Enddate1 = "2010-05-04"

stuff = Mid((Startdate), 1, 4)
stuff = Mid((Startdate), 6, 2)

Call Load_Farebox
Call Load_Gates
Call Load_Validators

End Sub

Public Sub Load_Farebox()

    sSql = "SELECT /*+ ORDERED FULL (mcm) FULL (ms) FULL (sd) FULL (st) USE_Hash (mcm) USE_Hash (ms) USE_Hash (sd) USE_Hash (st) USE_NL (sub) " & _
    "USE_NL(tvm) USE_NL (sta) */ tt.description Product, " & _
    "To_Char(Nvl(sd.BranchLineId, 0)) BranchLineid, tst.description tickettype, sd.fareoptamount amount,"

    sSql = sSql & "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '03', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider3am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '04', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider4am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '05', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider5am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '06', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider6am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '07', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider7am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '08', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider8am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '09', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider9am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '10', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider10am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '11', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider11am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '12', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider12pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '13', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider1pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '14', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider2pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '15', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider3pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '16', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider4pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '17', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider5pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '18', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider6pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '19', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider7pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '20', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider8pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '21', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider9pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '22', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider10pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '23', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider11pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '00', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider12am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '01', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider1am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '02', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider2am "

    sSql = sSql & " From MiscCardMovement mcm ,SalesDetail sd ,SalesDetail sub ,SalesTransaction st, tICKETTYPE TT, " & _
    "TVMTable tvm, tvmStation sta, ticketstocktype tst Where 1 = 1 AND tvm.TVMID=st.DeviceID " & _
    "AND tvm.DeviceClassID = st.DeviceClassID AND sta.StationID(+) =tvm.TVMTariffLocationID " & _
    "AND sub.DeviceClassId (+) = sd.DeviceClassId AND sub.DeviceId (+) = sd.DeviceId " & _
    "AND sub.Uniquemsid (+) = sd.Uniquemsid AND sub.SalestransactionNo (+) = sd.SalesTransactionNo " & _
    "AND sub.SalesDetailEvSequNo (+) = sd.SalesDetailEvSequNo+1 AND sub.CorrectionCounter(+) = sd.CorrectionCounter " & _
    "AND sub.PartitioningDate (+) = sd.PartitioningDate AND mcm.DeviceClassId = sd.DeviceClassId " & _
    "AND mcm.DeviceId = sd.DeviceId AND mcm.Uniquemsid = sd.Uniquemsid AND mcm.SalestransactionNo = sd.SalesTransactionNo " & _
    "AND mcm.SequenceNo = Decode(sub.SalesDetailEvSequNo ,NULL   ,sd.SalesDetailEvSequNo,sub.SalesDetailEvSequNo) "
    
    sSql = sSql & "AND mcm.CorrectionCounter = sd.CorrectionCounter AND mcm.PartitioningDate= sd.PartitioningDate " & _
    "AND mcm.TimeStamp = sd.CreaDate AND sd.DeviceID = st.DeviceID AND sd.DeviceClassID = st.DeviceClassID " & _
    "AND sd.UniqueMSID = st.UniqueMSID AND sd.SalesTransactionNo = st.SalesTransactionNo AND sd.PartitioningDate = st.PartitioningDate " & _
    "AND sd.articleno = tt.tickettypeid AND sd.tariffversion = tt.versionid AND tst.inttickettype (+) = sd.ticketstocktype and sd.CreaDate = st.CreaDate " & _
    "AND mcm.TimeStamp >= To_Date('" & Startdate & "-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND mcm.TimeStamp < To_Date('" & Enddate & "-02-59-59', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND mcm.PartitioningDate >= To_Date('" & Startdate & "-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND mcm.PartitioningDate < To_Date('" & Enddate1 & "-00-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND sd.PartitioningDate >= To_Date('" & Startdate & "-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND sd.PartitioningDate < To_Date('" & Enddate1 & "-00-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND st.PartitioningDate >= To_Date('" & Startdate & "-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND st.PartitioningDate < To_Date('" & Enddate1 & "-00-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND mcm.MovementType IN (7,20) AND sd.ArticleNo > 100000 AND sd.CorrectionFlag = 0 " & _
    "AND sd.RealStatisticArticle = 0 AND sd.TempBooking = 0 AND sd.ArticleNo <> 607900100  and sd.ticketstocktype <> 40"
    
    sSql = sSql & " AND sub.ArticleNo (+) =607900100 AND st.TestSaleFlag = 0 AND sta.StationType (+) = 1 " & _
    "AND mcm.DeviceClassID = 501 " & _
    "Group By tt.description,sd.BranchLineId,tst.description, sd.fareoptamount"

Debug.Print sSql
    Set RSData = New ADODB.Recordset
    Set RSData = ORAData.Execute(sSql)
    
    
Do While RSData.EOF = False
        sSql = "insert into Ridership_Farebox (year, month,signcode, Product, stocktype, cashValue, rider3am, " & _
        "rider4am, rider5am, rider6am, rider7am, rider8am, rider9am, rider10am, rider11am, rider12pm, " & _
        "rider1pm, rider2pm, rider3pm, rider4pm, rider5pm, rider6pm, rider7pm, rider8pm, rider9pm, " & _
        "rider10pm, rider11pm, rider12am, rider1am, rider2am) Values" & _
        "(" & Mid((Startdate), 1, 4) & "," & Mid((Startdate), 6, 2) & "," & RSData("Branchlineid") & ",'" & _
        RSData("Product") & "','" & RSData("tickettype") & "'," & RSData("amount") & "," & RSData("Rider3am") & "," & RSData("Rider4am") & "," & _
        RSData("Rider5am") & "," & RSData("Rider6am") & "," & RSData("Rider7am") & "," & RSData("Rider8am") & "," & _
        RSData("Rider9am") & "," & RSData("Rider10am") & "," & RSData("Rider11am") & "," & RSData("Rider12pm") & "," & _
        RSData("Rider1pm") & "," & RSData("Rider2pm") & "," & RSData("Rider3pm") & "," & RSData("Rider4pm") & "," & _
        RSData("Rider5pm") & "," & RSData("Rider6pm") & "," & RSData("Rider7pm") & "," & RSData("Rider8pm") & "," & _
        RSData("Rider9pm") & "," & RSData("Rider10pm") & "," & RSData("Rider11pm") & "," & RSData("Rider12am") & "," & _
        RSData("Rider1am") & "," & RSData("Rider2am") & ")"
        Debug.Print sSql
        SQLData.Execute (sSql)
        RSData.MoveNext
    Loop
    RSData.Close
    Set RSData = Nothing
    

End Sub

Public Sub Load_Gates()

    sSql = "SELECT /*+ ORDERED FULL (mcm) FULL (ms) FULL (sd) FULL (st) USE_Hash (mcm) USE_Hash (ms) USE_Hash (sd) USE_Hash (st) USE_NL (sub) " & _
    "USE_NL(tvm) USE_NL (sta) */  tt.description Product, " & _
    "sta.name Location, tst.description tickettype, rt.description route,sd.fareoptamount amount,"

    sSql = sSql & "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '03', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider3am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '04', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider4am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '05', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider5am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '06', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider6am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '07', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider7am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '08', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider8am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '09', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider9am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '10', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider10am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '11', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider11am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '12', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider12pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '13', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider1pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '14', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider2pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '15', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider3pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '16', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider4pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '17', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider5pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '18', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider6pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '19', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider7pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '20', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider8pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '21', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider9pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '22', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider10pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '23', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider11pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '00', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider12am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '01', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider1am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '02', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider2am "

    sSql = sSql & "From MiscCardMovement mcm , SalesDetail sd ,SalesDetail sub ,SalesTransaction st, tICKETTYPE TT, " & _
    "TVMTable tvm, tvmStation sta, ticketstocktype tst, routes rt Where 1 = 1 AND tvm.TVMID=st.DeviceID " & _
    "AND tvm.DeviceClassID = st.DeviceClassID AND sta.StationID(+) =tvm.TVMTariffLocationID " & _
    "AND sub.DeviceClassId (+) = sd.DeviceClassId AND sub.DeviceId (+) = sd.DeviceId " & _
    "AND sub.Uniquemsid (+) = sd.Uniquemsid AND sub.SalestransactionNo (+) = sd.SalesTransactionNo " & _
    "AND sub.SalesDetailEvSequNo (+) = sd.SalesDetailEvSequNo+1 AND sub.CorrectionCounter(+) = sd.CorrectionCounter " & _
    "AND sub.PartitioningDate (+) = sd.PartitioningDate AND mcm.DeviceClassId = sd.DeviceClassId " & _
    "AND mcm.DeviceId = sd.DeviceId AND mcm.Uniquemsid = sd.Uniquemsid AND mcm.SalestransactionNo = sd.SalesTransactionNo " & _
    "AND mcm.SequenceNo = Decode(sub.SalesDetailEvSequNo ,NULL   ,sd.SalesDetailEvSequNo,sub.SalesDetailEvSequNo) "
    
    sSql = sSql & "AND mcm.CorrectionCounter = sd.CorrectionCounter AND mcm.PartitioningDate= sd.PartitioningDate " & _
    "AND mcm.TimeStamp = sd.CreaDate AND sd.DeviceID = st.DeviceID AND sd.DeviceClassID = st.DeviceClassID " & _
    "AND sd.UniqueMSID = st.UniqueMSID AND sd.SalesTransactionNo = st.SalesTransactionNo AND sd.PartitioningDate = st.PartitioningDate " & _
    "AND sd.articleno = tt.tickettypeid AND sd.tariffversion = tt.versionid AND tst.inttickettype = sd.ticketstocktype and sd.CreaDate = st.CreaDate " & _
    "AND mcm.TimeStamp >= To_Date('" & Startdate & "-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND mcm.TimeStamp < To_Date('" & Enddate & "-02-59-59', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND mcm.PartitioningDate >= To_Date('" & Startdate & "-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND mcm.PartitioningDate < To_Date('" & Enddate1 & "-00-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND sd.PartitioningDate >= To_Date('" & Startdate & "-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND sd.PartitioningDate < To_Date('" & Enddate1 & "-00-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND st.PartitioningDate >= To_Date('" & Startdate & "-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND st.PartitioningDate < To_Date('" & Enddate1 & "-00-00 -00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND mcm.MovementType IN (7,20) AND sd.ArticleNo > 100000 AND sd.CorrectionFlag = 0 " & _
    "AND sd.RealStatisticArticle = 0 AND sd.TempBooking = 0 AND sd.ArticleNo <> 607900100 "
    
    sSql = sSql & " AND sub.ArticleNo (+) =607900100 AND st.TestSaleFlag = 0 AND rt.routeid = tvm.routeid AND sta.StationType =0 " & _
    "AND mcm.DeviceClassID in (411,441) " & _
    "Group By tt.description,sta.name,tst.description, rt.description, sd.fareoptamount"





Debug.Print sSql
    Set RSData = New ADODB.Recordset
    Set RSData = ORAData.Execute(sSql)
    Debug.Print sSql
    Do While RSData.EOF = False
        sSql = "insert into ridership_gates (year, month, Location, route, Product, stocktype, cashValue, rider3am, " & _
        "rider4am, rider5am, rider6am, rider7am, rider8am, rider9am, rider10am, rider11am, rider12pm, " & _
        "rider1pm, rider2pm, rider3pm, rider4pm, rider5pm, rider6pm, rider7pm, rider8pm, rider9pm, " & _
        "rider10pm, rider11pm, rider12am, rider1am, rider2am) Values" & _
        "(" & Mid((Startdate), 1, 4) & "," & Mid((Startdate), 6, 2) & ",'" & RSData("location") & "','" & _
        Replace(RSData("route"), "'", "''") & "','" & RSData("Product") & "','" & RSData("tickettype") & "'," & RSData("amount") & "," & RSData("Rider3am") & "," & RSData("Rider4am") & "," & _
        RSData("Rider5am") & "," & RSData("Rider6am") & "," & RSData("Rider7am") & "," & RSData("Rider8am") & "," & _
        RSData("Rider9am") & "," & RSData("Rider10am") & "," & RSData("Rider11am") & "," & RSData("Rider12pm") & "," & _
        RSData("Rider1pm") & "," & RSData("Rider2pm") & "," & RSData("Rider3pm") & "," & RSData("Rider4pm") & "," & _
        RSData("Rider5pm") & "," & RSData("Rider6pm") & "," & RSData("Rider7pm") & "," & RSData("Rider8pm") & "," & _
        RSData("Rider9pm") & "," & RSData("Rider10pm") & "," & RSData("Rider11pm") & "," & RSData("Rider12am") & "," & _
        RSData("Rider1am") & "," & RSData("Rider2am") & ")"

        SQLData.Execute (sSql)
        RSData.MoveNext
    Loop
    RSData.Close
    Set RSData = Nothing

End Sub

Public Sub Load_Validators()


    sSql = "SELECT /*+ ORDERED FULL (mcm) FULL (ms) FULL (sd) FULL (st) USE_Hash (mcm) USE_Hash (ms) USE_Hash (sd) USE_Hash (st) USE_NL (sub) " & _
    "USE_NL(tvm) USE_NL (sta) */ tt.description Product, sd.fareoptamount amount, " & _
    "sta.name location, tst.description tickettype, rt.description route, "

    sSql = sSql & "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '03', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider3am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '04', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider4am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '05', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider5am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '06', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider6am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '07', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider7am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '08', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider8am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '09', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider9am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '10', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider10am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '11', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider11am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '12', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider12pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '13', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider1pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '14', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider2pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '15', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider3pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '16', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider4pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '17', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider5pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '18', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider6pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '19', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider7pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '20', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider8pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '21', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider9pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '22', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider10pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '23', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider11pm, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '00', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider12am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '01', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider1am, " & _
    "To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '02', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider2am "

    sSql = sSql & "From MiscCardMovement mcm ,SalesDetail sd ,SalesDetail sub ,SalesTransaction st, tICKETTYPE TT, " & _
    "TVMTable tvm, tvmStation sta, ticketstocktype tst, routes rt Where 1 = 1 AND tvm.TVMID=st.DeviceID " & _
    "AND tvm.DeviceClassID = st.DeviceClassID AND sta.StationID(+) =tvm.TVMTariffLocationID " & _
    "AND sub.DeviceClassId (+) = sd.DeviceClassId AND sub.DeviceId (+) = sd.DeviceId " & _
    "AND sub.Uniquemsid (+) = sd.Uniquemsid AND sub.SalestransactionNo (+) = sd.SalesTransactionNo " & _
    "AND sub.SalesDetailEvSequNo (+) = sd.SalesDetailEvSequNo+1 AND sub.CorrectionCounter(+) = sd.CorrectionCounter " & _
    "AND sub.PartitioningDate (+) = sd.PartitioningDate AND mcm.DeviceClassId = sd.DeviceClassId " & _
    "AND mcm.DeviceId = sd.DeviceId AND mcm.Uniquemsid = sd.Uniquemsid AND mcm.SalestransactionNo = sd.SalesTransactionNo " & _
    "AND mcm.SequenceNo = Decode(sub.SalesDetailEvSequNo ,NULL   ,sd.SalesDetailEvSequNo,sub.SalesDetailEvSequNo) "
    
    sSql = sSql & "AND mcm.CorrectionCounter = sd.CorrectionCounter AND mcm.PartitioningDate= sd.PartitioningDate " & _
    "AND mcm.TimeStamp = sd.CreaDate AND sd.DeviceID = st.DeviceID AND sd.DeviceClassID = st.DeviceClassID " & _
    "AND sd.UniqueMSID = st.UniqueMSID AND sd.SalesTransactionNo = st.SalesTransactionNo AND sd.PartitioningDate = st.PartitioningDate " & _
    "AND sd.articleno = tt.tickettypeid AND sd.tariffversion = tt.versionid AND tst.inttickettype = sd.ticketstocktype AND sd.CreaDate = st.CreaDate " & _
    "AND mcm.TimeStamp >= To_Date('" & Startdate & "-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND mcm.TimeStamp < To_Date('" & Enddate & "-02-59-59', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND mcm.PartitioningDate >= To_Date('" & Startdate & "-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND mcm.PartitioningDate < To_Date('" & Enddate1 & "-00-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND sd.PartitioningDate >= To_Date('" & Startdate & "-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND sd.PartitioningDate < To_Date('" & Enddate1 & "-00-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND st.PartitioningDate >= To_Date('" & Startdate & "-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND st.PartitioningDate < To_Date('" & Enddate1 & "-00-00 -00', 'YYYY-MM-DD-HH24:MI:SS') " & _
    "AND mcm.MovementType IN (7,20) AND sd.ArticleNo > 100000 AND sd.CorrectionFlag = 0 " & _
    "AND sd.RealStatisticArticle = 0 AND sd.TempBooking = 0 AND sd.ArticleNo <> 607900100 "
    
    sSql = sSql & " AND sub.ArticleNo (+) =607900100 AND st.TestSaleFlag = 0 AND rt.routeid = tvm.routeid " & _
    "AND mcm.DeviceClassID in (801,901) " & _
    "Group By tt.description,sta.name, tst.description, rt.description, sd.fareoptamount"
    Debug.Print sSql
    Set RSData = New ADODB.Recordset
    Set RSData = ORAData.Execute(sSql)
    
    Do While RSData.EOF = False
        sSql = "insert into ridership_Validator (year, month, Location, route, Product, stocktype, cashvalue, rider3am, " & _
        "rider4am, rider5am, rider6am, rider7am, rider8am, rider9am, rider10am, rider11am, rider12pm, " & _
        "rider1pm, rider2pm, rider3pm, rider4pm, rider5pm, rider6pm, rider7pm, rider8pm, rider9pm, " & _
        "rider10pm, rider11pm, rider12am, rider1am, rider2am) Values" & _
        "(" & Mid((Startdate), 1, 4) & "," & Mid((Startdate), 6, 2) & ",'" & Replace(RSData("location"), "'", "''") & "','" & _
        Replace(RSData("route"), "'", "''") & "','" & RSData("Product") & "','" & RSData("tickettype") & "'," & RSData("amount") / 100 & "," & RSData("Rider3am") & "," & RSData("Rider4am") & "," & _
        RSData("Rider5am") & "," & RSData("Rider6am") & "," & RSData("Rider7am") & "," & RSData("Rider8am") & "," & _
        RSData("Rider9am") & "," & RSData("Rider10am") & "," & RSData("Rider11am") & "," & RSData("Rider12pm") & "," & _
        RSData("Rider1pm") & "," & RSData("Rider2pm") & "," & RSData("Rider3pm") & "," & RSData("Rider4pm") & "," & _
        RSData("Rider5pm") & "," & RSData("Rider6pm") & "," & RSData("Rider7pm") & "," & RSData("Rider8pm") & "," & _
        RSData("Rider9pm") & "," & RSData("Rider10pm") & "," & RSData("Rider11pm") & "," & RSData("Rider12am") & "," & _
        RSData("Rider1am") & "," & RSData("Rider2am") & ")"

        SQLData.Execute (sSql)
        RSData.MoveNext
    Loop
    RSData.Close
    Set RSData = Nothing

End Sub
