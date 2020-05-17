select crs.crs_segment Segment_Code, 
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
       decode(sum(sub.WK1_PMT_Tot),null,0,sum(sub.WK1_PMT_Tot)) WK1_PMT_Tot        
from ccs_account_detail cad, 
     ccs_rmi_score crs,      
      (select caph1.caph_cad_id CAD_ID,              
              sum(caph1.caph_pymt_amt) Wk1_PMT_Tot
      from ccs_account_payment_history caph1 
      where  caph1.caph_pymt_date between to_date('06/23/2005','mm/dd/yyyy') and to_date('07/18/2005','mm/dd/yyyy')
      --between next_day(trunc(sysdate), 'sunday')-14  
        --     and next_day(trunc( sysdate), 'sunday')-8                        
      group by  caph1.caph_cad_id) sub,
      (select casa_cad_id ,
              sum(casa_current_balance) TCURR
       from ccs_account_service_agreement
       where casa_energy_type in ('E','G')
         and casa_supplier_id  in (1,2,26,24,25,54,36,38,88,91,92,93,94)
       group by casa_cad_id) sub1       
where cad.cad_identifier = sub.CAD_ID(+)         and                
      cad.cad_identifier = crs.crs_cad_id        and
      cad.cad_identifier = sub1.casa_cad_id(+)   and
      cad.cad_energy_type in('E','G','B')        and
      crs.crs_model = 'CO'                       and
      (cad.cad_total_energy_bal>0 or cad.cad_total_energy_arr>0 or sub1.TCURR>0 or sub.WK1_PMT_Tot>0)                           
group by crs.crs_segment ,  
         substr(crs.crs_segment,3,1) , 
         substr(crs.crs_segment,10,1) , 
         substr(crs.crs_segment,15) ,
         cad.cad_status_code_curr ,
         cad.cad_account_type ,
         cad.cad_energy_type  
         
         
         
         
         select --crs.crs_segment Segment_Code, 
       --substr(crs.crs_segment,3,1) Segment_Level,      
       --substr(crs.crs_segment,10,1) Balance, 
       --substr(crs.crs_segment,15) Strategy,
       --cad.cad_account_number,  
       --cad.cad_status_code_prev Prev_Code,
       crs.crs_cad_id CRS_CAD_ID,
       cad.cad_identifier CAD_ID, 
       crs.crs_score Risk_Category, 
       cad.cad_status_code_curr St_Code,     
       cad.cad_account_type Cust_Type,
       cad.cad_energy_type EGB,                  
       --count(cad.cad_account_number) No_Accts,
       cad.cad_total_energy_bal T_BAL,
       cad.cad_total_energy_arr TARR,
       sub1.TCURR TCURR,
       count(crs.crs_cad_id),
       decode(sub.WK1_PMT_Tot,null,0,sub.WK1_PMT_Tot) WK1_PMT_Tot        
from ccs_account_detail cad, 
     ccs_rmi_score crs,      
      (select caph1.caph_cad_id CAD_ID,              
              sum(caph1.caph_pymt_amt) Wk1_PMT_Tot
      from ccs_account_payment_history caph1 
      where  caph1.caph_pymt_date between to_date('06/23/2005','mm/dd/yyyy') and to_date('07/18/2005','mm/dd/yyyy')
      --between next_day(trunc(sysdate), 'sunday')-14  
        --     and next_day(trunc( sysdate), 'sunday')-8                        
      group by  caph1.caph_cad_id) sub,
      (select casa_cad_id,
              sum(casa_current_balance) TCURR
       from ccs_account_service_agreement
       group by casa_cad_id) sub1       
where cad.cad_identifier = sub.CAD_ID(+)         and                
      cad.cad_identifier = crs.crs_cad_id        and
      cad.cad_identifier = sub1.casa_cad_id(+)   and
      crs.crs_model = 'CO'                       and 
   (cad.cad_total_energy_bal>0 or cad.cad_total_energy_arr>0 or sub1.TCURR>0 or sub.WK1_PMT_Tot>0) 
 group by  crs.crs_cad_id ,
       cad.cad_identifier , 
       crs.crs_score , 
       cad.cad_status_code_curr ,     
       cad.cad_account_type ,
       cad.cad_energy_type ,                  
       --count(cad.cad_account_number) No_Accts,
       cad.cad_total_energy_bal ,
       cad.cad_total_energy_arr ,
       sub1.TCURR ,
       decode(sub.WK1_PMT_Tot,null,0,sub.WK1_PMT_Tot) 
       order by count(crs.crs_cad_id) desc

         