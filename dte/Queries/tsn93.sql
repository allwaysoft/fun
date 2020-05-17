select caph1.caph_cad_id CAD_ID,              
              sum(caph1.caph_pymt_amt) Wk1_PMT_Tot
        from ccs_account_payment_history caph1 
      where  
      caph1.caph_pymt_date between next_day(trunc(sysdate), 'sunday')-14  
          and next_day(trunc( sysdate), 'sunday')-8                        
      group by  caph1.caph_cad_id
      
      
      
      
      
      
      
      SELECT /*+ ORDERED PARALLEL(AD, 14) PARALLEL(CADH, 14) 
                 PARALLEL(CCS_ACCOUNT_SERVICE_AGREEMENT, 14) 
                 USE_HASH(AD, CADH, CCS_ACCOUNT_SERVICE_AGREEMENT) */ 
       distinct cad_account_number,
       cad_identifier,decode(nvl(instr((extract(XMLType(cad_account_xmlstring), '/csbAccount/customer/profile/profileCode/text()').getStringVal()),'LI'),0),0,'N','Y')     
       LOW_INCOME,    
       Nvl(CAD_STATUS_CODE_CURR,'None') status_code,
       nvl(decode(CAD_ENERGY_TYPE, 'E', 'Elec', 'G', 'Gas', 'B', 'Both') , 'Other') energy_type        ,
       CAD_ACCOUNT_TYPE            ,
       nvl(CAD_METER_LOCATION, 'Other') meter_location   ,
       CAD_TOTAL_ENERGY_ARR,
       CAD_TOTAL_NONENERGY_ARR   ,
  cadh.cadh_cad_id,
  cadh.cadh_cca_agency_code,
       sub1.ninety,
       sub1.oninety,
       sub1.sixty,
       sub1.thirty,      
       sysdate Run_date 
FROM CCS_ACCOUNT_DETAIL AD,  
     CCS_ACCOUNT_DISPATCH_HISTORY CADH,
     (select casa_cad_id,  
             sum(CASA_NINETY_BUCKET) ninety,
             sum(CASA_OVER_NINETY_BUCKET) oninety,
             sum(CASA_SIXTY_BUCKET) sixty,
             sum(CASA_THIRTY_BUCKET) thirty
          from CCS_ACCOUNT_SERVICE_AGREEMENT
            group by casa_cad_id) sub1
WHERE  AD.CAD_ACCOUNT_STATUS = 'ACTIVE'
AND    AD.CAD_IDENTIFIER = cadh.cadh_cad_id(+) 
AND    AD.CAD_IDENTIFIER = sub1.CASA_CAD_ID
AND cadh.cadh_send_date = (select /*+ PARALLEL(cadh2, 14) */
                           max(cadh2.cadh_send_date) 
                           from ccs_account_dispatch_history cadh2
                           where cadh.cadh_cad_id = cadh2.cadh_cad_id)
AND (CAD_TOTAL_ENERGY_ARR<>0 or CAD_TOTAL_NONENERGY_ARR<>0 or sub1.oninety<>0 or sub1.ninety<>0 or sub1.sixty<>0 or sub1.thirty<>0)
and rownum <5








       SELECT /*+ ORDERED PARALLEL(AD, 14) PARALLEL(cadh, 14) 
                 PARALLEL(CCS_ACCOUNT_SERVICE_AGREEMENT, 14) 
                 USE_HASH(AD, cadh, CCS_ACCOUNT_SERVICE_AGREEMENT) */ 
       cad_account_number,
       cad_identifier, 
       decode(nvl(instr((extract(XMLType(cad_account_xmlstring), '/csbAccount/customer/profile/profileCode/text()').getStringVal()),'LI'),0),0,'N','Y')     
       LOW_INCOME,    
       Nvl(CAD_STATUS_CODE_CURR,'None') status_code,
       nvl(decode(CAD_ENERGY_TYPE, 'E', 'Elec', 'G', 'Gas', 'B', 'Both') , 'Other') energy_type        ,
       CAD_ACCOUNT_TYPE            ,
       nvl(CAD_METER_LOCATION, 'Other') meter_location   ,       
       CAD_TOTAL_ENERGY_ARR,
       CAD_TOTAL_NONENERGY_ARR   ,
       sub1.ninety,
       sub1.oninety,
       sub1.sixty,
       sub1.thirty,
       sub2.agency_code,
       sysdate Run_date 
FROM CCS_ACCOUNT_DETAIL AD,  
     (select 
             casa_cad_id,  
             sum(CASA_NINETY_BUCKET) ninety,
             sum(CASA_OVER_NINETY_BUCKET) oninety,
             sum(CASA_SIXTY_BUCKET) sixty,
             sum(CASA_THIRTY_BUCKET) thirty
               from CCS_ACCOUNT_SERVICE_AGREEMENT
                 group by casa_cad_id) sub1,
     (select distinct cadh.cadh_cad_id cad_id, 
             cadh.cadh_send_date,
             cadh_cca_agency_code agency_code
               from ccs_account_dispatch_history cadh
                 where cadh.cadh_send_date = (select /*+ PARALLEL(cadh2, 8) */ 
                                                      max(cadh2.cadh_send_date) 
                                                          from ccs_account_dispatch_history cadh2
                                                             where cadh.cadh_cad_id = cadh2.cadh_cad_id))sub2 
WHERE  AD.CAD_ACCOUNT_STATUS = 'ACTIVE'
AND    AD.CAD_IDENTIFIER = sub1.CASA_CAD_ID
AND    AD.CAD_IDENTIFIER = sub2.cad_id  
AND (CAD_TOTAL_ENERGY_ARR<>0 or CAD_TOTAL_NONENERGY_ARR<>0 or sub1.oninety<>0 or sub1.ninety<>0 or sub1.sixty<>0 or sub1.thirty<>0)
AND Rownum <5




select caah.caah_cad_id, 
       caah.caah_agency_code, 
       trunc(caah.caah_process_date),
       caah.caah_status_code, 
       caah.CAAH_REMARK
       from ccs_account_activity_history caah
    where caah_process_date in (select DISTINCT trunc(caah1.caah_process_date) from ccs_account_activity_history caah1
                              where caah.caah_cad_id = caah1.caah_cad_id
                              and caah.caah_agency_code=caah1.caah_agency_code
                              GROUP BY trunc(caah1.caah_process_date))
    and caah_cad_id = 78584

group by      caah.caah_cad_id, 
       caah.caah_agency_code, 
       trunc(caah.caah_process_date),
       caah.caah_status_code, 
       caah.CAAH_REMARK                                                           
       
       select count(1) from ccs_account_dispatch_history