select decode(caph_pymt_date,(select caph_pymt_date from ccs_account_payment_history where caph_pymt_date between next_day(trunc( sysdate), 'monday')-100 and 
  next_day(trunc( sysdate), 'monday')-8), sum(caph_pymt_amt))
  from ccs_account_payment_history
  where caph_cad_id =78584
  
  select 
  
  
  
select caph_cad_id,
 sum(decode(trunc(caph_pymt_date,'month'),trunc(add_months(sysdate, -3), 'month'), caph_pymt_amt, 0)) abc,
  sum(decode(trunc(caph_pymt_date,'month'),trunc(add_months(sysdate, -2), 'month'), caph_pymt_amt, 0)) bcd
 from ccs_account_payment_history
 where abc >0
 and rownum < 10
group by caph_cad_id


 
 and
last_day(trunc(add_months(caph_pymt_date,-1),'month'))


select trunc(add_months(sysdate, -3), 'month') from dual