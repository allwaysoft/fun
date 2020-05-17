select cad.CAD_ENERGY_TYPE,   
  cad.cad_account_type,
  cad.cad_status_code_curr, 
  cad.CAD_ACCOUNT_STATUS,            
  --crs.crs_segment, 
          crs.CRS_MODEL,           
          cad.cad_account_number,                                          
          cad.CAD_TOTAL_ENERGY_ARR,
          casa.CASA_CAD_ID,
          decode(nvl(instr((extract(XMLType(cad.cad_account_xmlstring), '/csbAccount/customer/profile/profileCode/text()').getStringVal()),'LI'),0),0,'N','Y')     
LOW_INCOME         
          --sum(casa.CASA_CURRENT_BALANCE) current_bal
          --(casa.casa_effective_date) effective_date,   
from       ccs_account_detail cad, 
           ccs_rmi_score crs,
           ccs_account_service_agreement casa 
where      cad.CAD_ENERGY_TYPE in ('B','E','G') 
      and  crs.crs_model = 'CO'
      and  cad.CAD_ACCOUNT_STATUS in ('ACTIVE','FINAL')
      and  cad.cad_account_type in ('RES','COM')
      and  cad.CAD_IDENTIFIER = CRS.CRS_CAD_ID
      and  cad.CAD_IDENTIFIER = casa.CASA_CAD_ID     
      and  ((casa.CASA_CURRENT_BALANCE)>0 or(cad.CAD_TOTAL_ENERGY_ARR)>0)
      
--group by  --crs.crs_segment, 
         -- crs.crs_score,           
    --      cad.cad_account_type, 
      --    crs.CRS_MODEL,           
        --  cad.cad_account_number,                               
          --cad.cad_status_code_curr,
--          cad.CAD_ENERGY_TYPE, 
  --        cad.CAD_ACCOUNT_STATUS,
    --      cad.CAD_TOTAL_ENERGY_ARR,
      --    casa.CASA_CAD_ID              
order by  cad.CAD_ENERGY_TYPE,   
  cad.cad_account_type,
  cad.cad_status_code_curr, 
  cad.CAD_ACCOUNT_STATUS,            
 crs.crs_segment
   
  
   select casa.casa_cad_id, sum(casa.CASA_CURRENT_BALANCE) current_bal 
   from ccs_account_service_agreement casa   
   group by casa.casa_cad_id

   