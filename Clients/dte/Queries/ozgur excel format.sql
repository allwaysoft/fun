select  cad.CAD_ENERGY_TYPE,   
        cad.cad_account_type,
        cad.CAD_ACCOUNT_STATUS,
        cad.cad_status_code_curr, 
        decode(nvl(instr((extract(XMLType(cad.cad_account_xmlstring), '/csbAccount/customer/profile/profileCode/text()').getStringVal()),'LI'),0),0,'N','Y')     
        LOW_INCOME,
        crs.crs_segment,
        cad.CAD_IDENTIFIER, 
        cad.cad_account_number,
        --count(cad.cad_account_number),                                                                                     
        cad.CAD_TOTAL_ENERGY_ARR,
        b.current_bal           
from       ccs_account_detail cad, 
           ccs_rmi_score crs,
           (select   casa_cad_id, sum(CASA_CURRENT_BALANCE) current_bal 
            from     ccs_account_service_agreement             
            group by casa_cad_id) b
where      cad.CAD_ENERGY_TYPE in ('B','E','G') 
      and  crs.crs_model = 'CO'
      and  cad.CAD_ACCOUNT_STATUS in ('ACTIVE','FINAL')
      and  cad.cad_account_type in ('RES','COM')
      and  cad.CAD_IDENTIFIER = CRS.CRS_CAD_ID 
      and  cad.CAD_IDENTIFIER = b.CASA_CAD_ID    
      and  ((b.current_bal)>0 or(cad.CAD_TOTAL_ENERGY_ARR)>0)

      
      
     