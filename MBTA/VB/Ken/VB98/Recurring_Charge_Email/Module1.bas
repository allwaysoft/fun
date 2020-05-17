Attribute VB_Name = "Module1"
Option Explicit

Public SQLDataTO As ADODB.Connection
Public SQLData As ADODB.Connection
Public OraData As ADODB.Connection

Public RSWork As ADODB.Recordset
Public sSql As String
Public Report_Name
Public vdate As Date
Public Proc_date As Date
Dim Application As New CRAXDRT.Application
Dim Outside_Report As New CRAXDRT.Report
Dim CRXParamDefs As CRAXDRT.ParameterFieldDefinitions
Dim CRXParamDef As CRAXDRT.ParameterFieldDefinition




Public Sub Main()


    'Set SQLData = New ADODB.Connection
    'SQLData.Open "dsn=MBTA2005", "mbta", "mbtadb"

    Set OraData = New ADODB.Connection
    OraData.Open "dsn=MBTA_nwcd", "mbta", "hallo"
    
    'Set SQLData = New ADODB.Connection
    'SQLData.Open "dsn=MBTA_nwcd_dw", "mbta", "hallo"

    Call Mail_Charge
    
    OraData.Close
    Set OraData = Nothing

End Sub



Public Sub Mail_Charge()
Dim lobj_cdomsg As CDO.Message
Dim smonth As String
Dim sday As Integer
Dim Longdate As String
Dim StPos As Long
Dim EndPos As Long
Dim HoldSerial As String
Dim counter As Long


    Dim contractdate As String
    Dim monthpass As String
    Proc_date = DateAdd("m", 1, Date)
    contractdate = Month(Proc_date) & "/1/" & Year(Proc_date)
    Longdate = Format(Proc_date, "Long Date")
    StPos = InStr(1, Longdate, ",") + 1
    EndPos = InStr(StPos + 1, Longdate, " ")
    monthpass = Trim(Mid(Longdate, StPos, EndPos - StPos + 1))

    Proc_date = DateAdd("d", -20, Proc_date)
    Longdate = Format(Proc_date, "Long Date")
    StPos = InStr(1, Longdate, ",") + 1
    EndPos = InStr(StPos + 1, Longdate, " ")
    smonth = Trim(Mid(Longdate, StPos, EndPos - StPos + 1))
    sday = Day(Proc_date)
    HoldSerial = "1"
    
sSql = "SELECT distinct C.SerialNumber,C.MediaType,C.CardValidUntil,C.CardIssued,C.Cardstatus, FUC.ApplFunctionId, " & _
       "FUC.ApplUserId,FUC.ApplFuncType,FUC.ValidFrom,FUC.ValidUntil ,FUC.LastBonusCheck ,PC.PaymentContractId,cc.contractcreditcardid, " & _
       "Decode(PC.PaymentUsageType,1, '1 - STORED_VALUE_RECURRING',2, '2 - STORED_VALUE_THRESHOLD',5, '5 - TIME_BASED_AUTOEXTENSION'," & _
       "6, '6 - TIME_BASED_RECURRING',To_Char(PC.PaymentUsageType) || ' - UNKNOWN!!!') AS PaymentUsageType, " & _
       "PC.PeriodStart ,Decode(PC.PeriodType, 0, '0 - PERIOD_DAY', 1, '1 - PERIOD_WEEK', " & _
       "2, '2 - PERIOD_2WEEKS',3, '3 - PERIOD_MONTH',  4, '4 - PERIOD_QUATER',  5, '5 - PERIOD_HALFYEAR',  6, '6 - PERIOD_YEAR', " & _
       "99, '99 - PERIOD_NOT_PERIOD', To_Char(PC.PeriodType) || ' - UNKNOWN!!!') AS PeriodType,PC.PeriodValue,PC.PeriodOffset, " & _
       "PC.ValidFrom,PC.ValidUntil,PC.TopUpAmount,PC.TopUpLimit,PC.GracePeriod,PC.PutOnHotlist,Decode(PC.PaymentContractStatus, " & _
       "0,'0 - ACTIVE', 1, '1 - INACTIVE', 2, '2 - DORMANT', 3, '3 - TO BE EXPIRED', To_Char(PC.PaymentContractStatus) || ' - UNKNOWN') AS PaymentContractStatus, " & _
       "PC.PaymentContractTypeId,PC.IsCorporateContract,PC.OneChargeForSum, p.lastname , p.firstname, con.contactinfo, CC.clearcreditcardno, TT.amount, TT.Description " & _
       " FROM FuncUsageContract FUC, tickettype tt, PaymentContract PC, Card C,ApplImplElements AIE,ApplImplementation AI,ApplAccountFunction AAF, appluser au, person p, contact con, contractcreditcard cc WHERE " & _
       " FUC.ApplFunctionId IN(6,7,8) AND FUC.PaymentContractId=PC.PaymentContractId AND PC.PaymentContractId NOT IN(999,998) AND PC.PaymentContractTypeId NOT IN (3,4) AND (PC.IsCorporateContract=0 OR PC.IsCorporateContract IS NULL) " & _
       " AND c.cardstatus = 2 AND C.CardId=AIE.CardId AND AIE.ApplSerialNo=AI.ApplSerialNo AND AIE.ApplicationId=AI.ApplicationId AND AI.ApplSerialNo=AAF.ApplSerialNo AND AI.ApplicationId=AAF.ApplicationId AND FUC.ApplFunctionId=AAF.ApplFunctionId " & _
       " AND tt.tickettypeid = fuc.SalesPaketId AND FUC.ValidFrom < To_Date ('" & contractdate & "','mm/dd/yyyy') AND TT.VERSIONID = (SELECT Max(TT2.versionid) FROM tickettype TT2) AND au.appluserid = ai.appluserid AND p.personid = au.personid AND con.personid = p.personid AND cc.personid = p.personid " & _
       " AND con.contacttypeid = 1 AND FUC.FuncUsageContractId=AAF.FuncUsageContractId AND C.SerialNumber IS NOT NULL AND C.SerialNumber<>0 AND PC.PaymentContractStatus = 0 OR ( (PC.IsCorporateContract IS NOT NULL AND PC.IsCorporateContract<>0) " & _
       " AND (PC.OneChargeForSum IS NULL OR PC.OneChargeForSum=0)) ORDER BY C.SerialNumber, cc.contractcreditcardid desc "
    Debug.Print sSql
    
    Set RSWork = New ADODB.Recordset
    Set RSWork = OraData.Execute(sSql)

    smonth = "May"
    sday = 25
    
    Do While RSWork.EOF = False
        If RSWork("serialnumber") = HoldSerial Then GoTo SkipIt
        If RSWork("cardstatus") <> 2 Then GoTo SkipIt
        
        HoldSerial = RSWork("serialnumber")
        
        Set lobj_cdomsg = New CDO.Message
        lobj_cdomsg.Configuration.Fields(cdoSMTPServer) = "131.108.46.106"
        lobj_cdomsg.Configuration.Fields(cdoSMTPConnectionTimeout) = 30
        lobj_cdomsg.Configuration.Fields(cdoSendUsingMethod) = cdoSendUsingPort
        lobj_cdomsg.Configuration.Fields.Update

        lobj_cdomsg.To = RSWork("Contactinfo")
        'lobj_cdomsg.To = "kcastonguay1@verizon.net"

        lobj_cdomsg.From = "custserv@charliecard.com"
        'lobj_cdomsg.BCC = "kcastonguay@mbta.com"
        
        lobj_cdomsg.Subject = RSWork("description")
        
        lobj_cdomsg.TextBody = "Dear " & RSWork("Firstname") & ", " & vbCrLf & vbCrLf
        lobj_cdomsg.TextBody = lobj_cdomsg.TextBody & "This email is being sent to you to inform you that the recurring charge of " & FormatCurrency(RSWork("amount") / 100) & " for your " & monthpass & " " & Trim(RSWork("description")) & " will occur on " & smonth & " " & sday & " for the CharlieCard and account listed below. " & vbCrLf & vbCrLf
        lobj_cdomsg.TextBody = lobj_cdomsg.TextBody & "CharlieCard Serial Number:  5-" & Trim(RSWork("serialnumber")) & vbCrLf
        lobj_cdomsg.TextBody = lobj_cdomsg.TextBody & "Account: ####-####-####-" & RSWork("CLEARCREDITCARDNO") & vbCrLf & vbCrLf
        lobj_cdomsg.TextBody = lobj_cdomsg.TextBody & "If you no longer wish to participate in the Recurring Pass Program, please remove the recurring program from this CharlieCard in your registered MyCharlie account on or before " & smonth & ", " & sday - 1 & " to avoid credit card charges." & vbCrLf & vbCrLf
        lobj_cdomsg.TextBody = lobj_cdomsg.TextBody & "Please retain this email as a receipt for your purchase." & vbCrLf & vbCrLf

        lobj_cdomsg.TextBody = lobj_cdomsg.TextBody & "To receive your purchase, tap your CharlieCard on any fare vending machine or gate in any MBTA subway station." & vbCrLf & vbCrLf
        lobj_cdomsg.TextBody = lobj_cdomsg.TextBody & "Thank you for riding the MBTA." & vbCrLf & vbCrLf
        lobj_cdomsg.TextBody = lobj_cdomsg.TextBody & "Sincerely," & vbCrLf & vbCrLf
        lobj_cdomsg.TextBody = lobj_cdomsg.TextBody & "CharlieCard Customer Service" & vbCrLf
        lobj_cdomsg.TextBody = lobj_cdomsg.TextBody & "custserv@charliecard.com" & vbCrLf
        lobj_cdomsg.TextBody = lobj_cdomsg.TextBody & "888-844-0355" & vbCrLf

        counter = counter + 1
        lobj_cdomsg.Send
        Set lobj_cdomsg = Nothing
        
SkipIt:
        RSWork.MoveNext
    Loop
    MsgBox ("Count  " & counter), vbOKOnly
    
    RSWork.Close
    Set RSWork = Nothing

End Sub


