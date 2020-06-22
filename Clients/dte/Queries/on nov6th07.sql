select   crs.crs_segment, 
          crs.crs_score,           
          cad.cad_account_type, 
          crs.CRS_MODEL,           
          cad.cad_account_number,                               
          cad.CAD_TOTAL_ENERGY_ARR,
          casa.CASA_CAD_ID,
casa.casa_effective_date,
          sum(casa.CASA_CURRENT_BALANCE)   
from       ccs_account_detail cad, 
           ccs_rmi_score crs,
           ccs_account_service_agreement casa 
where      cad.CAD_ENERGY_TYPE ='G' 
      and  crs.crs_model = 'CO'
      and  cad.CAD_ACCOUNT_STATUS = 'FINAL'
      and  cad.cad_account_type in ('RES','COM')
      and  cad.CAD_IDENTIFIER = CRS.CRS_CAD_ID
      and  cad.CAD_IDENTIFIER = casa.CASA_CAD_ID
      --and  casa.casa_effective_date >={?1 Enter Start Date}
      --and casa.casa_effective_date <={?2 Enter End Date}
group by  crs.crs_segment, 
          crs.crs_score,           
          cad.cad_account_type, 
          crs.CRS_MODEL,           
          cad.cad_account_number,                               
          cad.CAD_TOTAL_ENERGY_ARR,
          casa.CASA_CAD_ID,
          casa.casa_effective_date        
 select cad.cad_account_number, cad.CAD_TOTAL_ENERGY_ARR, casa.casa_identifier, casa.casa_current_balance
          from ccs_account_service_agreement casa, ccs_account_detail cad 
          where cad.cad_identifier=casa.casa_cad_id      
          and cad_account_number =289558300025
         
 select   crs.crs_segment, 
          crs.crs_score,           
          cad.cad_account_type, 
          crs.CRS_MODEL,                                                   
          casa.CASA_CAD_ID,
          cad.cad_account_number,
          max(casa.casa_effective_date),
          sum(casa.CASA_CURRENT_BALANCE),                  
          cad.CAD_TOTAL_ENERGY_ARR   
from       ccs_account_detail cad, 
           ccs_rmi_score crs,
           ccs_account_service_agreement casa 
where      cad.CAD_ENERGY_TYPE ='G' 
      and  crs.crs_model = 'CO'
      and  cad.CAD_ACCOUNT_STATUS = 'FINAL'
      and  cad.cad_account_type in ('RES','COM')
      and  cad.CAD_IDENTIFIER = CRS.CRS_CAD_ID
      and  cad.CAD_IDENTIFIER = casa.CASA_CAD_ID
      --and  casa.casa_effective_date >={?1 Enter Start Date}
      --and casa.casa_effective_date <={?2 Enter End Date}
group by  crs.crs_segment, 
          crs.crs_score,           
          cad.cad_account_type, 
          crs.CRS_MODEL,           
          cad.cad_account_number,                               
          cad.CAD_TOTAL_ENERGY_ARR,
          casa.CASA_CAD_ID             
          
select   crs.crs_segment, 
          crs.crs_score,           
          cad.cad_account_type, 
          crs.CRS_MODEL,           
          cad.cad_account_number,                               
          cad.CAD_TOTAL_ENERGY_ARR,
          casa.CASA_CAD_ID,
          max(casa.casa_effective_date),
          sum(casa.CASA_CURRENT_BALANCE)   
from       ccs_account_detail cad, 
           ccs_rmi_score crs,
           ccs_account_service_agreement casa 
where      cad.CAD_ENERGY_TYPE ='E' 
      and  crs.crs_model = 'CO'
      and  cad.CAD_ACCOUNT_STATUS = 'FINAL'
      and  cad.cad_account_type in ('RES','COM')
      and  cad.CAD_IDENTIFIER = CRS.CRS_CAD_ID
      and  cad.CAD_IDENTIFIER = casa.CASA_CAD_ID
     -- and  casa.casa_effective_date >={?1 Enter Start Date}
      --and casa.casa_effective_date <={?2 Enter End Date}
group by  crs.crs_segment, 
          crs.crs_score,           
          cad.cad_account_type, 
          crs.CRS_MODEL,           
          cad.cad_account_number,                               
          cad.CAD_TOTAL_ENERGY_ARR,
          casa.CASA_CAD_ID                  
          


         
         
