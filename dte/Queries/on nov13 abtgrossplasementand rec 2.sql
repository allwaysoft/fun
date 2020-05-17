select cat.cat_tier_number, cat.cat_account_type, cat.cat_cca_agency_code, cca.cca_agency_name, 
       sum(cad.cad_total_energy_arr)
      from ccs_agency_tier cat, ccs_collection_agency cca, ccs_dispatch_control cdc, ccs_account_detail cad
           
          where cca.cca_agency_code = cat.cat_cca_agency_code
                and cdc.cdc_cca_agency_code = cca.cca_agency_code
                and cdc.CDC_CAD_ID = cad.CAD_IDENTIFIER
                --and cdc.cdc_send_date between trunc(add_months(sysdate, -1), 'month') and
                                              --last_day(trunc(add_months(sysdate, -1), 'month')) 
               group by cat.cat_tier_number, cat.cat_account_type, cat.cat_cca_agency_code, cca.cca_agency_name                       
                       order by cat.cat_tier_number, cat.cat_account_type, cat.cat_cca_agency_code asc
                       
                       select cat.cat_tier_number, 
         -- cat.cat_account_type, 
          cat.cat_cca_agency_code, 
          cca.cca_agency_name, 
          sum(cad.cad_total_energy_arr) tot_placed,                     sum(caph.caph_pymt_amt) tot_received
from   ccs_agency_tier cat, 
          ccs_collection_agency cca, 
          ccs_dispatch_control cdc, 
          ccs_account_detail cad,
          ccs_account_payment_history caph 
where   cat.cat_cca_agency_code = cca.cca_agency_code
      and  cca.cca_agency_code= cdc.cdc_cca_agency_code
      and cdc.CDC_CAD_ID = cad.CAD_IDENTIFIER
      and cad.cad_identifier = caph.caph_cad_id
      and cdc.cdc_send_date between                                        trunc(add_months(sysdate, -1), 'month') and                             last_day(trunc(add_months(sysdate, -1), 'month')) 
group by   cat.cat_tier_number, 
                 --cat.cat_account_type, 
                 cat.cat_cca_agency_code, 
                 cca.cca_agency_name                       
                       order by cat.cat_tier_number, --cat.cat_account_type, 
                       cat.cat_cca_agency_code asc