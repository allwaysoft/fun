SELECT cat.CAT_TIER_NUMBER,
       cadh.CADH_CCA_AGENCY_CODE, 
       cca.CCA_AGENCY_NAME, 
       sum(cadh.CADH_ENERGY_ARR),
       sum(caph.CAPH_PYMT_AMT)
   FROM   CCS.CCS_AGENCY_TIER cat,
          CCS.CCS_ACCOUNT_PAYMENT_HISTORY caph,
          CCS.CCS_ACCOUNT_DISPATCH_HISTORY cadh,
          CCS.CCS_COLLECTION_AGENCY cca
     WHERE  caph.CAPH_CAD_ID = cadh.CADH_CAD_ID
        AND cadh.CADH_CCA_AGENCY_CODE = cat.CAT_CCA_AGENCY_CODE
        AND cadh.CADH_CCA_AGENCY_CODE=cca.CCA_AGENCY_CODE 
        AND (cadh.CADH_SEND_DATE)>= sysdate - 30  
        AND cadh.CADH_SEND_DATE<= sysdate
        AND caph.CAPH_PYMT_DATE >= sysdate - 30 
        AND caph.CAPH_PYMT_DATE <= sysdate
        AND cadh.CADH_CCA_AGENCY_CODE<>'RM10'
     group by cat.CAT_TIER_NUMBER,
              cadh.CADH_CCA_AGENCY_CODE, 
              cca.CCA_AGENCY_NAME
              
select    cat.cat_tier_number, 
          cat.cat_account_type, 
          cat.cat_cca_agency_code, 
          cca.cca_agency_name, 
          sum(cad.cad_total_energy_arr) tot_placed,                     
          sum(caph.caph_pymt_amt) tot_received
from   ccs_agency_tier cat, 
          ccs_collection_agency cca, 
          ccs_dispatch_control cdc, 
          ccs_account_detail cad,
          ccs_account_payment_history caph 
where   cca.cca_agency_code = cat.cat_cca_agency_code
      and cdc.cdc_cca_agency_code = cca.cca_agency_code
      and cdc.CDC_CAD_ID = cad.CAD_IDENTIFIER
      and cad.cad_identifier = caph_cad_id
      and cdc.cdc_send_date between trunc(add_months(sysdate, -1), 'month') and last_day(trunc(add_months(sysdate, -1), 'month')) group by   cat.cat_tier_number, 
                 cat.cat_account_type, 
                 cat.cat_cca_agency_code, 
                 cca.cca_agency_name                       
    order by cat.cat_tier_number, cat.cat_account_type, cat.cat_cca_agency_code asc
                       
                       
                       
                       select * from ccs_dispatch_control where cdc_send_date
                       BETWEEN to_date('10/01/2007','mm/dd/yyyy')  AND to_date('10/27/2007','mm/dd/yyyy') 
                       
                       

select cat.cat_tier_number, 
          cat.cat_account_type, 
          cat.cat_cca_agency_code, 
          cca.cca_agency_name,
          cad.cad_account_number,
          cad.cad_identifier, 
          sum(cad.cad_total_energy_arr) tot_placed,                     sum(caph.caph_pymt_amt) tot_received
from   ccs_agency_tier cat, 
          ccs_collection_agency cca, 
          ccs_dispatch_control cdc, 
          ccs_account_detail cad,
          ccs_account_payment_history caph 
where   cca.cca_agency_code = cat.cat_cca_agency_code
      and cdc.cdc_cca_agency_code = cca.cca_agency_code
      and cdc.CDC_CAD_ID = cad.CAD_IDENTIFIER
      and cad.cad_identifier = caph.caph_cad_id
      and cad.cad_account_type = cat.CAT_ACCOUNT_TYPE
      and cad.cad_account_type = cat.cat_account_type
      and cdc.cdc_send_date between                                        trunc(add_months(sysdate, -1), 'month') and                             last_day(trunc(add_months(sysdate, -1), 'month')) 
group by   cat.cat_tier_number, 
                 cat.cat_account_type, 
                 cat.cat_cca_agency_code,
                 cad.cad_account_number,
                 cad.cad_identifier,  
                 cca.cca_agency_name                       
order by cat.cat_tier_number, cat.cat_account_type, 
cat.cat_cca_agency_code asc                                           
              
                            