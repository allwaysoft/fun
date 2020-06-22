select ARD_CUST_IDN||LPAD(ARD_ACCT_SEQ,4,0), count(distinct ard_arrear_type)
  from arrears_detail_trans 
   WHERE ARD_ARREAR_TYPE   in (4,2)
      --and ARD_ENTERPRISE_CODE IN (2,3,7)
       --AND   ARD_ACCT_TYPE='NON'
     group by ARD_CUST_IDN||LPAD(ARD_ACCT_SEQ,4,0)
     order by  count(distinct ard_arrear_type) desc
     
     
     select * from agreement_ar_balances
     where Abal_CUST_IDN = 3081384 
       AND Abal_ACCT_SEQ = '02'
       and abal_cpartkey = 84