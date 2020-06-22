select 'AcctNo','Name','EGB','LI','STCODE','Res','MTRloc','TARR','TNONARR','Status','BDD','Score','Segment','RandomNo','Curr','30','60','90','O90',
       'fDt fShutO','RBal','RStrat','RLevel','     DtRan',999 as Sequence1 from dual
union
select /*+ ORDERED FIRST_ROWS PARALLEL(AD, 12) PARALLEL(RMI, 12) PARALLEL(INVL1, 12) PARALLEL(FCH, 12) */ distinct
to_char(AD.CAD_ACCOUNT_NUMBER), 
to_char(AD.CAD_CUSTOMER_NAME) , 
to_char(AD.CAD_ENERGY_TYPE) , 
max(DECODE(dbms_lob.instr(cad_account_xmlstring, '<profileCode>LI<',1,1),0,'N','Y')),
to_char(AD.CAD_STATUS_CODE_CURR) , 
to_char(decode(AD . CAD_ACCOUNT_TYPE,'RES','Y','N')), 
to_char(AD.CAD_METER_LOCATION) , 
to_char(AD.CAD_TOTAL_ENERGY_ARR) ,
to_char(AD.CAD_TOTAL_NONENERGY_ARR) , 
to_char(AD.CAD_ACCOUNT_STATUS)  , 
to_char(trunc(AD.CAD_BILL_DUE_DATE)),
to_char(RMI.CRS_SCORE) , 
to_char(RMI.CRS_SEGMENT) , 
to_char(RMI.CRS_RANDOM_NUM),
to_char(sum(INVL1.CASA_CURRENT_BALANCE)) , 
to_char(sum(INVL1.CASA_THIRTY_BUCKET)) , 
to_char(sum(INVL1.CASA_SIXTY_BUCKET)) , 
to_char(sum(INVL1.CASA_NINETY_BUCKET)) , 
to_char(sum(INVL1.CASA_OVER_NINETY_BUCKET)),
to_char(INLV2.Process_date),
to_char(SUBSTR(RMI.CRS_SEGMENT,3,1)), 
to_char(SUBSTR(RMI.CRS_SEGMENT,10,1)),
to_char(SUBSTR(RMI.CRS_SEGMENT,15)),
to_char(sysdate),
1 as Sequence1
FROM ccs_account_detail AD , 
     CCS_RMI_SCORE RMI,
     ccs_account_service_agreement INVL1,
     (Select /*+ PARALLEL(FCH, 12) */ fch.cfch_cad_id cad_id,
             MAX(FCH.CFCH_PROCESS_DATE ) Process_date  
        from CCS_FIELD_CUT_HISTORY FCH 
          group by fch.cfch_cad_id ) INLV2  
where AD.CAD_IDENTIFIER = INVL1.CASA_CAD_ID(+)
  and AD.CAD_IDENTIFIER = RMI.CRS_CAD_ID(+)
  and AD.CAD_IDENTIFIER = INLV2.CAD_ID(+)
  and AD.CAD_ACCOUNT_STATUS = 'ACTIVE'
  and (RMI.CRS_MODEL = 'CO' or RMI.CRS_MODEL is null )
  and Ad.cad_identifier = 2219112
group by    (AD.CAD_ACCOUNT_NUMBER), 
            (AD.CAD_CUSTOMER_NAME) , 
            (AD.CAD_ENERGY_TYPE) ,
            (AD.CAD_STATUS_CODE_CURR) , 
(decode(AD . CAD_ACCOUNT_TYPE,'RES','Y','N')), 
(AD.CAD_METER_LOCATION) , 
(AD.CAD_TOTAL_ENERGY_ARR) ,
(AD.CAD_TOTAL_NONENERGY_ARR) , 
(AD.CAD_ACCOUNT_STATUS)  , 
(trunc(AD.CAD_BILL_DUE_DATE)),
(RMI.CRS_SCORE) , 
(RMI.CRS_SEGMENT) , 
(RMI.CRS_RANDOM_NUM), 
(INLV2.Process_date),
(SUBSTR(RMI.CRS_SEGMENT,3,1)), 
(SUBSTR(RMI.CRS_SEGMENT,10,1)),
(SUBSTR(RMI.CRS_SEGMENT,15))
having (AD.CAD_TOTAL_ENERGY_ARR + AD.CAD_TOTAL_NONENERGY_ARR +sum(INVL1.CASA_CURRENT_BALANCE)
                                +sum(INVL1.CASA_THIRTY_BUCKET)+sum(INVL1.CASA_SIXTY_BUCKET)
                                +sum(INVL1.CASA_NINETY_BUCKET)+sum(INVL1.CASA_OVER_NINETY_BUCKET)) <>0
order by Sequence1 desc 
            
            
