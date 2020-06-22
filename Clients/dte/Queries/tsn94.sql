select crs.crs_segment Segment_Code, 
       substr(crs.crs_segment,3,1) Segment_Level,      
       substr(crs.crs_segment,10,1) Balance, 
       substr(crs.crs_segment,15) Strategy,
       --crs.crs_cad_id,
       --cad.cad_identifier CAD_ID, 
       cad.cad_status_code_curr St_Code,
       cad.cad_account_type Cust_Type,
       cad.cad_energy_type EGB,
       --cad.cad_account_number,      
       count(cad.cad_account_number) No_Accts,
       sum(cad.cad_total_energy_bal) T_BAL,
       sum(cad.cad_total_energy_arr) TARR,
       sum(sub1.TCURR) TCURR,
decode(sum(sub.WK1_PMT_Tot),null,0,sum(sub.WK1_PMT_Tot)) WK1_PMT_Tot,
       sysdate Date_Ran        
from ccs_account_detail cad, 
     ccs_rmi_score crs,      
      (select caph1.caph_cad_id CAD_ID,              
              sum(caph1.caph_pymt_amt) Wk1_PMT_Tot
      from ccs_account_payment_history caph1 
      where  caph1.caph_pymt_date 
       between next_day(trunc( sysdate), 'monday')-14 and 
               next_day(trunc( sysdate), 'monday')-8                    
      group by  caph1.caph_cad_id) sub,
      (select casa_cad_id ,
              sum(casa_current_balance) TCURR
       from ccs_account_service_agreement
       where casa_energy_type in ('E','G')
         and casa_supplier_id  in (1,2,12,26,24,25,54,36,38,88,91,92,93,94)
       group by casa_cad_id) sub1       
where cad.cad_identifier = sub.CAD_ID(+)         and                
      cad.cad_identifier = crs.crs_cad_id        and
      cad.cad_identifier = sub1.casa_cad_id(+)   and
      cad.cad_energy_type in('E','G','B')        and
      crs.crs_model = 'MP'                       and
   (cad.cad_total_energy_bal>0 or cad.cad_total_energy_arr>0 or sub1.TCURR>0)                      
group by crs.crs_segment ,
         --crs.crs_cad_id,  
         substr(crs.crs_segment,3,1) , 
         substr(crs.crs_segment,10,1) , 
         substr(crs.crs_segment,15) ,
         --cad.cad_account_number,
         --cad.cad_identifier,
         cad.cad_status_code_curr ,
         cad.cad_account_type ,
         cad.cad_energy_type 
         
         
         
         
         
         
         
         
         
         
         
         
       select /*+ USE_HASH(cad, crs, caph1, ccs_account_service_agreement) PARALLEL(cad, 8) PARALLEL(crs, 8) PARALLEL(caph1, 8) PARALLEL(ccs_account_service_agreement, 8) */
       crs.crs_segment Segment_Code, 
       substr(crs.crs_segment,3,1) Segment_Level,      
       substr(crs.crs_segment,10,1) Balance, 
       substr(crs.crs_segment,15) Strategy,
       cad.cad_status_code_curr St_Code,
       cad.cad_account_type Cust_Type,
       cad.cad_energy_type EGB,     
       count(cad.cad_account_number) No_Accts,
       sum(cad.cad_total_energy_bal) T_BAL,
       sum(cad.cad_total_energy_arr) TARR,
       sum(sub1.TCURR) TCURR,
decode(sum(sub.WK1_PMT_Tot),null,0,sum(sub.WK1_PMT_Tot)) WK1_PMT_Tot,
       sysdate Date_Ran        
from ccs_account_detail cad, 
     ccs_rmi_score crs,      
      (select caph1.caph_cad_id CAD_ID,              
              sum(caph1.caph_pymt_amt) Wk1_PMT_Tot
      from ccs_account_payment_history caph1 
      where  caph1.caph_pymt_date 
       between next_day(trunc( sysdate), 'monday')-14 and 
               next_day(trunc( sysdate), 'monday')-8                    
      group by  caph1.caph_cad_id) sub,
      (select casa_cad_id ,
              sum(casa_current_balance) TCURR
       from ccs_account_service_agreement
       where casa_energy_type in ('E','G')
         and casa_supplier_id  in (1,2,12,26,24,25,54,36,38,88,91,92,93,94)
       group by casa_cad_id) sub1       
where cad.cad_identifier = sub.CAD_ID(+)         and                
      cad.cad_identifier = crs.crs_cad_id        and
      cad.cad_identifier = sub1.casa_cad_id(+)   and
      cad.cad_energy_type in('E','G','B')        and
      crs.crs_model = 'FN'                       and
   (cad.cad_total_energy_bal>0 or cad.cad_total_energy_arr>0 or sub1.TCURR>0)                      
group by crs.crs_segment ,
         --crs.crs_cad_id,  
         substr(crs.crs_segment,3,1) , 
         substr(crs.crs_segment,10,1) , 
         substr(crs.crs_segment,15) ,         
         cad.cad_status_code_curr ,
         cad.cad_account_type ,
         cad.cad_energy_type 